describe "Recur macro" do

  class GotoTest
    def factorial(n, product)
      if n == 0
        product
      else
        recur(n - 1, n * product)
      end
    end
  end

  it "rebinds variables to passed args and goes to the start of the method" do
    t = GotoTest.new
    t.factorial(4,1).should == 24
  end

  it "works with methods with default arguments" do
    def default(a=1)
      if a == 10
        :ok
      else
        recur(a + 1)
      end
    end

    default.should == :ok
  end

end
#

