p "P 1"
def count_instance_superclass(instance)
	i = 0
	c = instance.class
	while c != BasicObject
		p c.inspect
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

%w(alice bob carol).each_with_index do |person,index|
	puts ">>#{person} is number #{index}"
end

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
		if n == 1
			@fib_sequence = [1]
		elsif n == 2
			@fib_sequence = [1,1]
		else
			@fib_sequence = [1,1]
			i = 2
			while i < n
				@fib_sequence <<  @fib_sequence[-1] + @fib_sequence[-2]
				i += 1
			end
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
