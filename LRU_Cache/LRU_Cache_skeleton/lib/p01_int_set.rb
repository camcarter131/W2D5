require 'byebug'

class MaxIntSet

  attr_reader :store, :max

  def initialize(max)
    @store = Array.new(max) {false}
    @max = max
  end

  def insert(num)
    validate!(num)
    store[num] = true if !include?(num)
  end

  def remove(num) 
    validate!(num)
    store[num] = false if include?(num)
  end

  def include?(num)
    validate!(num)
    @store[num] == true
  end

  private

  def is_valid?(num)
    num.between?(0, max-1)
  end

  def validate!(num)
    raise "Out of bounds" if !is_valid?(num)
  end
end


class IntSet
  attr_reader :store, :num_buckets

  def initialize(num_buckets = 20)
    @store = Array.new(num_buckets) { Array.new }
    @num_buckets = num_buckets
  end

  def insert(num)
    if !include?(num)
      self[num] << num 
      return true
    end
    false
  end

  def remove(num)
    self[num].delete(num) if include?(num)
  end

  def include?(num)
    self[num].include?(num)
  end

  private

  def [](num)
    # optional but useful; return the bucket corresponding to `num`
    store[num % num_buckets]
  end

  def num_buckets
    @store.length
  end
end

class ResizingIntSet
  attr_accessor :count, :num_buckets, :store

  def initialize(num_buckets = 20)
    @store = Array.new(num_buckets) { Array.new }
    @count = 0
    @num_buckets = num_buckets
  end

  def insert(num)
    # debugger
    return false if include?(num)
    # self.count += 1
    resize! if self.count >= num_buckets
    self[num] << num
    self.count += 1
    true
  end

  def remove(num)
    if include?(num)
      self.count -= 1 
      self[num].delete(num)
    end

  end

  def include?(num)

    self[num].include?(num)
  end

  private

  def [](num)
    # optional but useful; return the bucket corresponding to `num`
    store[num % num_buckets]
  end

  def num_buckets
    @store.length
  end

  def resize!
    # debugger
    old_store = self.store.dup 
    self.count = 0
    self.store = Array.new(num_buckets*2) { Array.new }
    @num_buckets *= 2
    old_store.flatten.each { |el| insert(el) }
  end
end
