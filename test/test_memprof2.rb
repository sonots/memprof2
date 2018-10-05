require_relative 'helper'

class TestMemprof2 < Test::Unit::TestCase
  def rvalue_size
    GC::INTERNAL_CONSTANTS[:RVALUE_SIZE]
  end

  def find(results, key_match)
    results.find {|k, v| k =~ key_match }.last
  end

  def test_start_stop
    memprof = Memprof2.new.configure({})
    Memprof2.start
    a = "abc"
    12.times{ "abc" }
    results = memprof.collect_info
    Memprof2.stop
    assert_equal(rvalue_size, find(results, /test_memprof2.rb:15:String/))
    assert_equal(rvalue_size * 12, find(results, /test_memprof2.rb:16:String/))
  end

  def test_run
    memprof = Memprof2.new.configure({})
    results = nil
    Memprof2.run do
      a = "abc"
      results = memprof.collect_info
    end
    assert_equal(rvalue_size, find(results, /test_memprof2.rb:27:String/))
  end

  def test_report_out
    opts = {out: "tmp/test_report.out"}
    Memprof2.start
    a = "abc"
    Memprof2.report(opts)
    Memprof2.stop
    assert_match("test/test_memprof2.rb:36:String\n", File.read(opts[:out]))
  end

  def test_report!
    opts_bang = {out: "tmp/test_report_bang.out"}
    opts = {out: "tmp/test_report.out"}
    Memprof2.start
    a = "abc"
    Memprof2.report!(opts_bang) # clear
    Memprof2.report(opts)
    Memprof2.stop
    assert_match("test/test_memprof2.rb:46:String\n", File.read(opts_bang[:out]))
    assert_match("", File.read(opts[:out]))
  end

  def test_run_with_result
    opts = {out: "tmp/test_run_with_report.out"}
    Memprof2.run_with_report(opts) do
      a = "abc"
    end
    assert_match("test/test_memprof2.rb:57:String\n", File.read(opts[:out]))
  end
end
