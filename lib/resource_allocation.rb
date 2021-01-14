class ResourceAllocation
  CPU_SIZE = ['large', 'xlarge', '2xlarge', '4xlarge', '8xlarge', '10xlarge']

  CPU_COUNT = {
    'large'=> 1,
    'xlarge'=> 2,
    '2xlarge'=> 4,
    '4xlarge'=> 8,
    '8xlarge'=> 16,
    '10xlarge'=> 32,
  }

  # We can update the cost of instances, add or remove instances in a region
  RESOURCES = {
    us_east: {
      'large'=> 0.12,
      'xlarge'=> 0.23,
      '2xlarge'=> 0.45,
      '4xlarge'=> 0.774,
      '8xlarge'=> 1.4,
      '10xlarge'=> 2.82
    },
    us_west: {
      'large'=> 0.14,
      '2xlarge'=> 0.413,
      '4xlarge'=> 0.89,
      '8xlarge'=> 1.3,
      '10xlarge'=> 2.97
    },
    asia: {
      'large'=> 0.11,
      'xlarge'=> 0.25,
      '4xlarge'=> 0.67,
      '8xlarge'=> 1.18
    }
  }
  def initialize
    @unit_cpu_price = price_per_cpu
    p 'Enter usage hours:'
    hours = gets.to_i
    p 'Enter the minimum number of CPUs needed:'
    cpus = gets.to_i
    p 'Enter the maximum price:'
    price = gets.to_f
    p get_costs(hours, cpus, price)
  end

  def price_per_cpu
    unit_cpu_price = []
    # Calculate the cost for 1 CPU for each of the instance. This will help in fetching servers with minimum cost
    RESOURCES.each do |region, instances|
      CPU_SIZE.each do |size|
        unit_cpu_price << ["#{region}-#{size}", RESOURCES[region][size] / CPU_COUNT[size]] if RESOURCES[region][size]
      end
    end
    unit_cpu_price.sort_by { |pair| pair[1] }
  end

  def get_costs(hours, cpus, price)
    result = []
    region_wise_data = {}
    if price == 0 # if price is not a constraint
      cpu_based(region_wise_data, hours, cpus)
    elsif cpus == 0 # if CPU is not a constraint
      cost_based_data(region_wise_data, hours, price)
    else
      # allocate CPUs within given price, check if allocation possible, else return
      alloc_possible = cpu_and_cost_based(region_wise_data, hours, cpus, price)
      return 'cannot assign servers at this price' unless alloc_possible
    end
    region_wise_data.each do |region, data|
      data['region'] = region
      result << data
    end
    result
  end

  def cpu_based(region_wise_data, hours, price)
    @unit_cpu_price.each do |resource|
      region, instance = resource[0].split('-')
      cost_per_server = RESOURCES[region.to_sym][instance] * hours
      instance_count = cpus / CPU_COUNT[instance]
      next if instance_count == 0

      region_data_calc(region_wise_data, region, instance, cost_per_server, instance_count)
      cpus -= (CPU_COUNT[instance] * instance_count)
      break if cpus == 0
    end
  end

  def cost_based(region_wise_data, hours, price)
    @unit_cpu_price.each do |resource|
      region, instance = resource[0].split('-')
      cost_per_server = RESOURCES[region.to_sym][instance] * hours
      instance_count = (price / cost_per_server).to_i
      next if instance_count == 0

      region_data_calc(region_wise_data, region, instance, cost_per_server, instance_count)
      price -= (cost_per_server * instance_count)
      break if price == 0
    end
  end

  def cpu_and_cost_based(region_wise_data, hours, cpus, price)
    @unit_cpu_price.each do |resource|
      region, instance = resource[0].split('-')
      cost_per_server = RESOURCES[region.to_sym][instance] * hours
      instance_needed = cpus.to_i / CPU_COUNT[instance].to_i
      # instance count assigned should me minimum of instance needed or maximum instances that can be bought from the price
      instance_count = [(price / cost_per_server).to_i, instance_needed].min
      next if instance_count == 0

      region_data_calc(region_wise_data, region, instance, cost_per_server, instance_count)
      price -= (cost_per_server * instance_count)
      cpus -= (CPU_COUNT[instance] * instance_count)
      break if price == 0 || cpus <= 0
    end
    return cpus <= 0
  end

  def region_data_calc(region_wise_data, region, instance, cost_per_server, instance_count)
    region_wise_data[region] = { 'total_cost' => 0, 'servers' => [] } if region_wise_data[region].nil?
    region_wise_data[region]['total_cost'] += (cost_per_server * instance_count)
    region_wise_data[region]['servers'] << [instance, instance_count]
  end
end

ResourceAllocation.new
