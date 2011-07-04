require 'benchmark'
require 'benchmark/ips'

class RecurBench
  def recur_fib(n)
    if n == 0
      0
    else
      recur(n - 1)
    end
  end

  def normal_fib(n)
    if n == 0
      0
    else
      normal_fib(n - 1)
    end
  end
end
#
@b = Recurbench.new

Benchmark.ips do |x|
  x.compare!

  x.report "normal_fib" do
    @b.normal_fib(9000)
  end

  x.report "recur_fib" do
    @b.recur_fib(9000)
  end

end
