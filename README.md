# resource-allocation
A ruby program to allocate cloud computing resources based on needs.

The program asks for the below inputs:

Usage hours
Minimum number of CPUs
Maximum price

And returns the instances that can be assigned for the above input.

Example:

"Enter usage hours, minimum CPU needed and maximum price"
1 10 1

Output:
[{"total_cost"=>0.89, "servers"=>[["4xlarge", 1], ["large", 2]], "region"=>"asia"}]

When the price or CPU is passed as 0 or 'NA', it is considered that there are no constraints on the limit for those. Below is one such example:

"Enter usage hours, minimum CPU needed and maximum price"
2 20 0

Output:
[{"total_cost"=>2.36, "servers"=>[["8xlarge", 1]], "region"=>"asia"}, {"total_cost"=>0.826, "servers"=>[["2xlarge", 1]], "region"=>"us_west"}]

For the above, price is passed as 0 and hence we can allocate the required number of CPUs at any price without any constraint.

To run the program, go to the path where allocation is cloned and use the below command:

ruby lib/resource_allocation.rb

To run the test cases, use the below command:

rspec lib/resource_allocation_test.rb
