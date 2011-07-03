describe "Swap macro" do

  it "swaps the values of 2 local variables passed as arguments" do
    a, b = 1, 2
    swap(a,b)
    a.should == 2
    b.should == 1
  end

  it "swaps the values of 2 instance variables passed as arguments" do
    @a, @b = 1, 2
    swap(@a,@b)
    @a.should == 2
    @b.should == 1
  end

  it "swaps the values of 2 class variables passed as arguments" do
    @@a, @@b = 1, 2
    swap(@@a,@@b)
    @@a.should == 2
    @@b.should == 1
  end

  it "swaps the values of 2 global variables passed as arguments" do
    $a, $b = 1, 2
    swap($a,$b)
    $a.should == 2
    $b.should == 1
  end

  it "swaps the values of an instance and class variable passed as arguments" do
    @a, @@b = 1, 2
    swap(@a,@@b)
    @a.should == 2
    @@b.should == 1
  end


  it "raises CompileError if number of passed args is not 2" do
    lambda { eval("swap(a)") }.should raise_error(Rubinius::CompileError)
    lambda { eval("swap(a,b,c)") }.should raise_error(Rubinius::CompileError)
  end

end


