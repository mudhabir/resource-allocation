require "test/unit"
require_relative './resource_allocation'
class ResourceAllocationTest < Test::Unit::TestCase
  describe "Resource allocation test" do
    it "should allocate servers when price is not a constraint" do
      response = [{"total_cost"=>2.065, "servers"=>[["2xlarge", 1]], "region"=>"us_west"}, {"total_cost"=>0.55, "servers"=>[["large", 1]], "region"=>"asia"}]
      expect(ResourceAllocation.new.get_costs(5, 5, 0)).to eq(response)
    end

    it "should allocate servers when CPU count is not a constraint" do
      response = [{"total_cost"=>9.8, "servers"=>[["8xlarge", 1], ["4xlarge", 1], ["large", 1]], "region"=>"asia"}]
      expect(ResourceAllocation.new.get_costs(5, 0, 10)).to eq(response)
    end

    it "should allocate servers when both price and CPU count is given" do
      response = [{"total_cost"=>5.0, "servers"=>[["4xlarge", 1], ["large", 3]], "region"=>"asia"}, {"total_cost"=>2.065, "servers"=>[["2xlarge", 1]], "region"=>"us_west"}]
      expect(ResourceAllocation.new.get_costs(5, 15, 30)).to eq(response)
    end

    it "should not allocate servers when CPU count is high and price is very less" do
      expect(ResourceAllocation.new.get_costs(5, 15, 2)).to eq("cannot assign servers at this price")
    end

    it "should test price_per_cpu method" do
      response =  [["asia-8xlarge", 0.07375], ["us_west-8xlarge", 0.08125], ["asia-4xlarge", 0.08375], ["us_east-8xlarge", 0.0875], ["us_east-10xlarge", 0.088125], ["us_west-10xlarge", 0.0928125], ["us_east-4xlarge", 0.09675], ["us_west-2xlarge", 0.10325], ["asia-large", 0.11], ["us_west-4xlarge", 0.11125], ["us_east-2xlarge", 0.1125], ["us_east-xlarge", 0.115], ["us_east-large", 0.12], ["asia-xlarge", 0.125], ["us_west-large", 0.14]]
      expect(ResourceAllocation.new.price_per_cpu).to eq(response)
    end
  end
end
