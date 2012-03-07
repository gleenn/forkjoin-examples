require 'forkjoin'

pool = ForkJoin::Pool.new

# FORK

# Add a job (a proc) to the pool for each line
map_futures = pool.invoke_all(
  ARGF.each_line.map{|line| Proc.new do line.split.map{|word| [word,1]} end }
)

# Get aggregate results
counts = map_futures.map(&:get).inject({}) {|map, value|
  value.each {|k,v| (map[k] ||= []) << v}
  map
}

# JOIN

# Add a job to the pool for each count in the map
reduced_futures = pool.invoke_all(
  counts.map{|k, vs| Proc.new do [k, vs.size] end }
)

# Print out results (or you could "reduce" some other way)
reduced_futures.map(&:get).each{|value|
  puts "%s %d\n" % value
}
