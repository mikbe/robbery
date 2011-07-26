require 'benchmark'


Benchmark.bmbm do |bm|
  
  size  = 1000
  times = 1000
  
  x = ("X" * size).split("")
  y = ("Y" * size).split("")
  
  bm.report{times.times{x += y}} # <= waaaaaay slower
  bm.report{times.times{x.concat y}}
  
end