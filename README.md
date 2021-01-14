# resource-allocation
A ruby program to allocate cloud computing resources based on needs.

The program asks for the below inputs:

Usage hours
Minimum number of CPUs
Maximum price

And returns the instances that can be assigned for the above input.

Example:

"Enter usage hours:"
1
"Enter the minimum number of CPUs needed:"
10
"Enter the maximum price:"
2

Output:
[{"total_cost"=>0.89, "servers"=>[["4xlarge", 1], ["large", 2]], "region"=>"asia"}]
