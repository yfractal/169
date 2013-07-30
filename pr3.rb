p "P 1"
def should_be(test,expect)
	puts test.to_s
	puts "Should be " + expect.to_s
end

def count_instance_superclass(instance)
	i = 0
	c = instance.class
	while c != BasicObject
		# p c.inspect
		c = c.superclass 
		i += 1
	end
	return i
end

p count_instance_superclass(5)

puts "\nP 2"
def get_calss_and_ancestor_class(obj)
	cl = obj.class 
	if cl == BasicObject
		super_cl = nil
	else
		super_cl = cl.superclass
	end
	p "obj's class is " + cl.to_s
	p "obj's superclass is " + super_cl.to_s
end

get_calss_and_ancestor_class(5)

puts "\nP 3"
class Fixnum
	def seconds  ; self ; end;
	def minutes  ; self * 60; end;
	def hours    ; self * 60 * 60; end;

	def days     ; self * 60 * 60 * 24; end;

	def ago      ; Time.now - self ; end;
	def from_now ; Time.new + self ; end;

	def method_missing(method_id,*args)
		name = method_id.to_s
		if name =~ /^(second|minute|hour|day)$/
			self.send(name + 's')
		else
			super
		end
	end
end
	
p Time.now.inspect
p 5.minutes.ago.to_s


class Time
	def at_beginning_of_year
		year = Time.now.year
		return Time.new(year)
	end
end


puts Time.now.at_beginning_of_year.to_s
puts Time.now.at_beginning_of_year + 1.day


puts "\nP 4"
puts "It is pending"
class Foo
	def method_missing(method_id,*args)
		name = method_id.to_s
		# puts name
		if name == "bar2"
			attr_accessor name.to_s
		end
	end

	def self.attr_accessor_with_history(field)
	end

	attr_accessor_with_history :bar2


	def bar=(b)
		@bar = b
	end
	def bar
		return @bar
	end

end

f = Foo.new
# f.attr_accessor_with_history("2")
puts "bar 2 is "
f.bar2 = 1
r = f.bar2
puts r

puts "pending\n"

puts "P 5  Mix-ins and Iterators"
include Enumerable

module Enumerable
	def each_with_custom_index(start,slice)
		i = start
		self.each do |e|
			yield e,i
			i += slice
		end
	end
end

%w(alice bob carol).each_with_custom_index(3,2) do |person,index|
	puts ">>#{person} is number #{index}"
end

puts "\n"
puts "P 6"

class FibSequence
	attr_accessor :n,:fib_sequence
	def initialize(n)
		@n = n
		get_fib_sequence!(n)
	end

	def get_fib_sequence!(n)
		def get_fib_sequence_from_3!
			i = 2
			while i < n
				@fib_sequence <<  @fib_sequence[-1] + @fib_sequence[-2]
				i += 1
			end
		end

		if n == 1
			@fib_sequence = [1]
		elsif n == 2
			@fib_sequence = [1,1]
		else
			@fib_sequence = [1,1]
			get_fib_sequence_from_3!()
		end
		
		return @fib_sequence
	end
	def each
		@fib_sequence.each do |fib|
			yield fib
		end
	end
end
f = FibSequence.new(10)
puts f.fib_sequence

f = FibSequence.new(6)
f.each {|s| print(s,':')}.to_s
puts "\n"
puts f.reject {|s| s.odd?}.to_s
puts f.map{|x| x*2}.to_s
puts "\n"


puts "P 7"
lastfib = "Suprise!"
f = FibSequence.new(3).each do |f|
	print lastfib
end
puts "f is "
puts f.to_s
puts "\n"

f = FibSequence.new(3).each do 
	print "Rah"
end

puts "P 8"
puts "pending"
puts "\n"
puts "p 9"
module Enumerable
	def each_with_flattening
		self.each do |ele|
			if ele.class == Array 
				ele.each_with_flattening do |e|
					yield e 
				end
			else 
				yield ele
			end
		end
	end
end


arr = [1,[2,3],4,[5,6],7]
arr.each_with_flattening do |s|
	print "#{s},"
end
puts "\n"

arr2 = [1,[2,[3,4,[5,6],[7,8],9],10],11]
arr2.each_with_flattening do |s|
	print "#{s},"
end
# it must be array


puts "\nP 10"

module Enumerable
	def each_permuted
		c = []
		# copy(self,c)
		self.each do |e|
			c << e
		end
		while not c.empty?
			rand_index = rand * c.length
			ele = c[rand_index]
			yield ele
			c.delete(ele)
		end
	end
end

t = (1..10).to_a
t.each_permuted do |r|
	puts r
end
puts "\nP 11"

class BinaryTree
	attr_accessor :ele,:l_child,:r_child
	def initialize(ele,l_child = nil,r_child = nil)
		@ele = ele
		@l_child = l_child
		@r_child = r_child
	end

	def empty?
		return self == nil
	end

	def <<(ele)
		ele = BinaryTree.new(ele)
		curr = self
		parent = curr

		def go_left_right(compare,compared)
			if compare.ele < compared.ele
				return compared.l_child
			else
				return compared.r_child
			end
		end

		while curr != nil
			parent = curr
			curr = go_left_right(ele,curr)
		end

		if ele.ele < parent.ele
			parent.l_child = ele
		else
			parent.r_child = ele
		end

		return self
	end

	def each
		if self != nil
			if self.l_child != nil
				self.l_child.each do |e|
					yield e 
				end
			end

			yield self

			if self.r_child != nil
				self.r_child.each do |e|
					yield e 
				end
			end
		end
	end

	def include?(&elt)
		self.each do |e|
			if e.ele == elt.call
				return true
			end
		end
		return false
	end

	def all?(&block)
		self.each do |e|
			if not block.call(e.ele)
				return  false
			end
		end
		return true
	end

	def any?(&block)
		self.each do |e|		
			if block.call(e.ele)
				return true
			end
		end
		return false
	end
end
head = BinaryTree.new(17)
head << 9 << 15 << 11 << 33 << 1
puts "each "
head.each do |e|
	puts e.ele
end
r = head.include? do 
	11
end
puts should_be(r,"true")
r2 = head.include? do 
	111
end
puts "all"
puts should_be(r2,false)

r_all = head.all? do |e|
	e % 2 == 1
end
should_be(r_all,"true")

r_all2 = head.all? do |e |
	e >= 10
end

should_be(r_all2,"false")

puts "any?"
r1 = head.any? do |e|
	e >= 10
end
should_be(r1,true)
r2 = head.any? do |e|
	e % 2 == 0
end
should_be(r2,false)

def receive_block(&block)
	puts block.call(1,2)
end

receive_block do |a,b|
	a + b
end
# defind a function the call it 

def lam(&block)
	block.call(1)
end

# puts lam(lambda {|x| x+ 1})

r = lam do |x|
	x + 1
end
puts r
