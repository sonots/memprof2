require 'objspace'

class Memprof2
  class << self
    def start
      ObjectSpace.trace_object_allocations_start
    end

    def stop
      ObjectSpace.trace_object_allocations_stop
      ObjectSpace.trace_object_allocations_clear
    end

    def run(&block)
      ObjectSpace.trace_object_allocations(&block)
    end

    def report(opts = {})
      ObjectSpace.trace_object_allocations_stop
      self.new.report(opts)
    ensure
      ObjectSpace.trace_object_allocations_start
    end

    def report!(opts = {})
      report(opts)
      ObjectSpace.trace_object_allocations_clear
    end

    def run_with_report(opts = {}, &block)
      start
      yield
      report(opts)
    ensure
      stop
    end
  end

  def report(opts={})
    configure(opts)
    results = collect_info
    File.open(@out, 'a') do |io|
      results.each do |location, memsize|
        io.puts "#{memsize} #{location}"
      end
    end
  end

  def configure(opts = {})
    @rvalue_size = GC::INTERNAL_CONSTANTS[:RVALUE_SIZE]
    if @trace = opts[:trace]
      raise ArgumentError, "`trace` option must be a Regexp object" unless @trace.is_a?(Regexp)
    end
    if @ignore = opts[:ignore]
      raise ArgumentError, "`ignore` option must be a Regexp object" unless @ignore.is_a?(Regexp)
    end
    @out = opts[:out] || "/dev/stdout"
    self
  end

  def collect_info
    results = {}
    ObjectSpace.each_object do |o|
      next unless (file = ObjectSpace.allocation_sourcefile(o))
      next if file == __FILE__
      next if (@trace  and @trace !~ file)
      next if (@ignore and @ignore =~ file)
      line = ObjectSpace.allocation_sourceline(o)
      if RUBY_VERSION >= "2.2.0"
        # Ruby 2.2.0 takes into account sizeof(RVALUE)
        # https://bugs.ruby-lang.org/issues/8984
        memsize = ObjectSpace.memsize_of(o)
      else
        # Ruby < 2.2.0 does not have ways to get memsize correctly, but let me make a bid as much as possible
        # https://twitter.com/sonots/status/544334978515869698
        memsize = ObjectSpace.memsize_of(o) + @rvalue_size
      end
      memsize = @rvalue_size if memsize > 100_000_000_000 # compensate for API bug
      klass = o.class.name rescue "BasicObject"
      location = "#{file}:#{line}:#{klass}"
      results[location] ||= 0
      results[location] += memsize
    end
    results
  end
end


