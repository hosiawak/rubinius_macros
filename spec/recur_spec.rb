describe "Recur macro" do

  class RecurTest
    def factorial(n, product)
      if n == 0
        product
      else
        recur(n - 1, n * product)
      end
    end

    def fib(n, x, y)
      if n == 0
        x
      else
        recur(n - 1, y, x + y)
      end
    end

    def default_arg_simple(a = 1)
      a == 10 ? :ok : recur(a + 1)
    end

    def default_arg_non_literal(a = 1 + 0)
      a == 10 ? :ok : recur(a + 1)
    end

    def default_arg_mixture(a = mixture_helper + 0 - 1, b = mixture_helper + 10)
      a == 10 ? :ok : recur(a + 1, 10)
    end

    def mixture_helper
      1
    end

    def splat_arg_factorial(*ary)
      if ary[0] == 0
        ary[1]
      else
        recur(ary[0] - 1, ary[0] * ary[1])
      end
    end

    def required_and_splat_factorial(n, *ary)
      if n == 0
        ary[0]
      else
        recur(n - 1, n * ary[0]);
      end
    end
  end

  before(:all) do
    @t = RecurTest.new
  end

  it "rebinds variables to passed args and goes to the start of the method" do
    @t.factorial(4,1).should == 24
  end

  it "doesn't blow the stack with too many call frames" do
    @t.fib(10_000, 0, 1).to_s[0...10].should == "3364476487"
  end

  context "optional args" do
    it "works with optional args set to literal values" do
      @t.default_arg_simple.should == :ok
    end

    it "works with optional args set to non literal values" do
      @t.default_arg_non_literal.should == :ok
    end

    it "works with optional args set to literal values, non literal values and method calls" do
      @t.default_arg_mixture.should == :ok
    end
  end

  context "splat args" do
    it "destructures args passed to recur into the splat arg" do
      @t.splat_arg_factorial(4,1).should == 24
    end

    it "passes args as normal up to the splat arg which is destructured" do
      @t.required_and_splat_factorial(4,1).should == 24
    end
  end

  context "error reporting" do
    it "raises CompileError when an argument is passed to recur but the method doesn't define one" do
      m = "def no_arg;recur(1);end"
      lambda { eval(m)}.should raise_error(Rubinius::CompileError)
    end

    it "raises CompileError when more arguments passed to recur than the method defines" do
      m = "def too_many_args(a);recur(1,2);end"
      lambda { eval(m)}.should raise_error(Rubinius::CompileError)
    end

    it "doesn't raise CompileError when more than required args passed to recur if the method uses a splat arg" do
      m = "def not_enough(a,*b);recur(1,2,3);end"
      lambda { eval(m)}.should_not raise_error(Rubinius::CompileError)
    end

  end

end


