# memprof2

[![Build Status](https://secure.travis-ci.org/sonots/memprof2.png?branch=master)](http://travis-ci.org/sonots/memprof2)

Memprof2 is a Ruby memory profiler for >= Ruby 2.1.0.

# Installation

Execute

```
$ gem install memprof
```

or ddd the following to your `Gemfile`:

```ruby
gem 'memprof2'
```

And then execute:

```plain
$ bundle
```

# API

## Memprof2.report

```ruby
Memprof2.start
12.times{ "abc" }
Memprof2.report(out: "/path/to/file")
Memprof2.stop
```

Start tracking file/line memory size (bytes) information for objects created after calling `Memprof2.start`, and print out a summary of file:line:class pairs created.

```
480 file.rb:2:String
```

*Note*: Call `Memprof2.report` again after `GC.start` to see which objects are cleaned up by the garbage collector:

```ruby
Memprof2.start
10.times{ $last_str = "abc" }

puts '=== Before GC'
Memprof2.report

puts '=== After GC'
GC.start
Memprof2.report

Memprof2.stop
```

After `GC.start`, only the very last instance of `"abc"` will still exist:

```
=== Before GC
400 file.rb:2:String
=== After GC
40 file.rb:2:String
```

*Note*: Use `Memprof2.report!` to clear out tracking data after printing out results.

## Memprof2.run

Simple wrapper for `Memprof2.start/stop` that will start/stop memprof around a given block of ruby code.

```ruby
Memprof2.run do
  100.times{ "abc" }
  100.times{ 1.23 + 1 }
  100.times{ Module.new }
  Memprof2.report(out: "/path/to/file")
end
```

For the block of ruby code, print out file:line:class pairs for ruby objects created.

```
4000  file.rb:2:String
4000  file.rb:3:Float
4000  file.rb:4:Module
```

*Note*: You can call GC.start at the end of the block to print out only objects that are 'leaking' (i.e. objects that still have inbound references).

## ChangeLog

See [CHANGELOG.md](CHANGELOG.md) for details.

## See Also

* [Ruby でラインメモリプロファイラ](http://qiita.com/sonots/items/c14b3e3ca8e6f7dfb651) (Japanese)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new [Pull Request](../../pull/new/master)

## Copyright

Copyright (c) 2014 Naotoshi Seo. See [LICENSE.txt](LICENSE.txt) for details.
