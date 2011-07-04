require 'benchmark'
require 'benchmark/ips'

Benchmark.ips do |x|
  x.compare!

  @s = :to_s
  x.report "normal symbol to proc" do
    [1].map(&@s)
  end

  x.report "rewritten symbol to proc" do
    [1].map(&:to_s)
  end



end
