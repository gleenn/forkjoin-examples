require 'rubygems'
require 'forkjoin'


class Spoon < ForkJoin::Task
	def initialize(i)
		@i = i
	end

	def call
		return @i if @i >= 100
		f = Spoon.new(@i+1)
		f.fork
		@i + f.join
	end
end

pool = ForkJoin::Pool.new

puts pool.invoke(Spoon.new(1))
