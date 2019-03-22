class HashSet
  attr_accessor :count, :store, :key, :num_buckets

  def initialize(num_buckets = 8)
    @store = Array.new(num_buckets) { Array.new }
    @count = 0
    @num_buckets = num_buckets
  end

  def insert(key)
     value = key.hash
     # debugger
     return false if include?(key)
     # self.count += 1
     resize! if self.count >= num_buckets
     self[key] << value
     self.count += 1
     true
  end

  def include?(key)
    value = key.hash
    self[key].include?(value)
  end

  def remove(key)
    value = key.hash
    if include?(key)
      self.count -= 1 
      self[key].delete(value)
    end
  end

  private

  def [](key)
    value = key.hash
    # optional but useful; return the bucket corresponding to `num`
    store[value % num_buckets]
  end

  def num_buckets
    @store.length
  end

  def resize!
    old_store = self.store.dup 
    self.count = 0
    self.store = Array.new(num_buckets*2) { Array.new }
    @num_buckets *= 2
    old_store.flatten.each { |el| insert(el) }
  end
end
