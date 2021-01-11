class ResourceAllocation
  attr_reader :alloc
  def initialize
    @alloc = 'alloc'
  end
end

puts "Allocation: #{ResourceAllocation.new.alloc}"
