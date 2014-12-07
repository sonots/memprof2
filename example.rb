require 'memprof2'

##############
Memprof2.start
12.times{ "abc" }
Memprof2.report
Memprof2.stop


##############
Memprof2.start
10.times{ $last_str = "abc" }

puts '=== Before GC'
Memprof2.report

puts '=== After GC'
GC.start
Memprof2.report

Memprof2.stop

#############
Memprof2.run do
  100.times{ "abc" }
  100.times{ 1.23 + 1 }
  100.times{ Module.new }
  Memprof2.report(out: "example.out")
end
