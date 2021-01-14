class ResourceAllocation
  CPU_COUNT = {
    'large'=> 1,
    'xlarge'=> 2,
    '2xlarge'=> 4,
    '4xlarge'=> 8,
    '8xlarge'=> 16,
    '10xlarge'=> 32,
  }
  def initialize
    # We can update the cost of instances, add or remove instances in a region
    @resources = {
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
        'xlarge'=> 0.20,
        '4xlarge'=> 0.67,
        '8xlarge'=> 1.18
      }
    }
    @unit_cpu_price = price_per_cpu
    p 'Enter usage hours:'
    hours = gets.to_i
    p 'Enter the minimum number of CPUs needed:'
    cpus = gets.to_i
    p 'Enter the maximum price:'
    price = gets.to_f
    get_costs(hours, cpus, price)
  end

  def price_per_cpu
    unit_cpu_price = []
    # Calculate the cost for 1 CPU for each of the instance
    @resources.each do |region, instances|
      unit_cpu_price << ["#{region}-large", @resources[region]['large']] if @resources[region]['large']
      unit_cpu_price << ["#{region}-xlarge", @resources[region]['xlarge'] / CPU_COUNT['xlarge']] if @resources[region]['xlarge']
      unit_cpu_price << ["#{region}-2xlarge", @resources[region]['2xlarge'] / CPU_COUNT['2xlarge']] if @resources[region]['2xlarge']
      unit_cpu_price << ["#{region}-4xlarge", @resources[region]['4xlarge'] / CPU_COUNT['4xlarge']] if @resources[region]['4xlarge']
      unit_cpu_price << ["#{region}-8xlarge", @resources[region]['8xlarge'] / CPU_COUNT['8xlarge']] if @resources[region]['8xlarge']
      unit_cpu_price << ["#{region}-10xlarge", @resources[region]['10xlarge'] / CPU_COUNT['10xlarge']] if @resources[region]['10xlarge']
    end
    unit_cpu_price.sort_by { |pair| pair[1] }
  end

  def get_costs(hours, cpus, price)
    soln = []
    region_wise_data = {}
    if price == 0 # if price is not a constraint
      @unit_cpu_price.each do |resource|
        region, instance = resource[0].split('-')
        instance_count = cpus.to_i / CPU_COUNT[instance].to_i
        next if instance_count == 0

        region_wise_data[region] = { 'total_cost' => 0, 'servers' => [] } if region_wise_data[region].nil?
        region_wise_data[region]['total_cost'] += @resources[region.to_sym][instance] * instance_count * hours
        region_wise_data[region]['servers'] << [instance, instance_count]
        cpus -= (CPU_COUNT[instance] * instance_count)
        break if cpus == 0
      end
    elsif cpus == 0 # if CPU is not a constraint
      @unit_cpu_price.each do |resource|
        region, instance = resource[0].split('-')
        cost_per_server = @resources[region.to_sym][instance] * hours
        instance_count = (price / cost_per_server).to_i
        next if instance_count == 0

        region_wise_data[region] = { 'total_cost' => 0, 'servers' => [] } if region_wise_data[region].nil?
        region_wise_data[region]['total_cost'] += (cost_per_server * instance_count)
        region_wise_data[region]['servers'] << [instance, instance_count]
        price -= (cost_per_server * instance_count)
        break if price == 0
      end
    else
      @unit_cpu_price.each do |resource|
        region, instance = resource[0].split('-')
      end
    end
    p region_wise_data
  end
end

ResourceAllocation.new
