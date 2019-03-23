class Node
  attr_reader :key
  attr_accessor :val, :next, :prev

  def initialize(key = nil, val = nil)
    @key = key
    @val = val
    @next = nil
    @prev = nil
  end

  def to_s
    "#{@key}: #{@val}"
  end

  def remove
    # optional but useful, connects previous link to next link
    # and removes self from list.
  end
end

class LinkedList

  include Enumerable

  attr_accessor :head, :tail

  def initialize
    @head = Node.new()
    @tail = Node.new()
    @head.next = @tail
    @tail.prev = @head

  end

  def [](i)
    each_with_index { |link, j| return link if i == j }
    nil
  end

  def first
    @head.next
  end

  def last
    @tail.prev
  end

  def empty?
    first == @tail
  end

  def get(key)
    curr_node = first
    while curr_node.key != key
      curr_node = curr_node.next
      if curr_node == tail || curr_node == nil # && curr_node.key != key
        return nil
      end
    end
    curr_node.val
  end

  def include?(key)
    curr_node = first
    while curr_node.key != key
      curr_node = curr_node.next
      if curr_node == tail && curr_node.key != key
        return false
      end
    end   

    true
  end

  def append(key, val)
    new_node = Node.new(key,val)
    new_node.next = @tail
    new_node.prev = last
    last.next = new_node
    tail.prev = new_node
  end

  def update(key, val)
    return nil if empty?
    curr_node = first
    while curr_node.key != key
      curr_node = curr_node.next
      if curr_node == tail && curr_node.key != key
        return nil
      end
    end
    curr_node.val = val
  end

  def remove(key)
    curr_node = first
    while curr_node.key != key
      curr_node = curr_node.next
      if curr_node == tail && curr_node.key != key
        return nil
      end
    end
    prev_node, next_node = curr_node.prev, curr_node.next
    prev_node.next = next_node
    next_node.prev = prev_node
  end

  def each(&prc)
    prc ||= Proc.new { |a,b| a <=> b }
    vals = []
    curr_node = first
    while curr_node != @tail
      prc.call(curr_node)
      curr_node = curr_node.next
      if curr_node == @tail 
        break
      end
      # prc.call(curr_node)
    end
  end

  # uncomment when you have `each` working and `Enumerable` included
  def to_s
    inject([]) { |acc, link| acc << "[#{link.key}, #{link.val}]" }.join(", ")
  end
end
