def total2(from, to, &block)
  result = 0
  from.upto(to) do |num|
    if block
      result += block.call(num)
    else
      result += num
    end
  end
  result
end

p total2(1, 10)
p total2(1, 10) {|i| i ** 2 } 
