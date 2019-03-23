require_relative 'p04_linked_list'
require 'byebug'

class HashMap

  include Enumerable 

  attr_accessor :count, :store, :num_buckets

  def initialize(num_buckets = 8)
    @store = Array.new(num_buckets) { LinkedList.new }
    @count = 0
    @num_buckets = num_buckets
  end
  
  def count
    @count
  end

  def include?(key)
    bucket(key).get(key) != nil
  end

  def set(key, val)
    ll = bucket(key)
    if ll.get(key) != nil
      ll.update(key,val)
    else
      resize! if self.count >= num_buckets
      bucket(key).append(key,val)
      @count += 1
    end
  end

  def get(key) # key = hash[:first]
    # debugger
    bucket(key).get(key)
  end

  def delete(key)
    ll = bucket(key)
    if ll.get(key) != nil
      ll.remove(key)
      @count -= 1
    end
  end

  def each(&prc)
    prc ||= Proc.new { |a,b| a <=> b }
    @store.each do |ll|
      curr_node = ll.first
      while curr_node != @tail
        prc.call(curr_node.key, curr_node.val)
        curr_node = curr_node.next
        if curr_node == @tail 
          break
        end
      end
    end

  end

  # uncomment when you have Enumerable included
  def to_s
    pairs = inject([]) do |strs, (k, v)|
      strs << "#{k.to_s} => #{v.to_s}"
    end
    "{\n" + pairs.join(",\n") + "\n}"
  end

  alias_method :[], :get
  alias_method :[]=, :set

  private

  def num_buckets
    @store.length
  end

  def resize!
    old_store = self.store.dup 
    self.count = 0
    
    self.store = Array.new(num_buckets*2) { LinkedList.new }
    @num_buckets *= 2
    old_store.each do |ll| 
      # set(ll.key, ll.val)
      ll.each { |link| set(link.key, link.val) }
      # curr_node = ll.first 
      # while curr_node != @tail
      #   curr_node = curr_node.next
      #   if curr_node == @tail 
      #     break
      #   end
      #   self.set(curr_node.key, curr_node.val)
      # end
    end
  end

  def bucket(key)
    # optional but useful; return the bucket corresponding to `key`
    self.store[key.hash % @num_buckets]
  end
end
