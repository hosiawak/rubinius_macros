describe "Andand macro" do

  it "rewrites foo.andand.bar into __x__ = foo; x && x.bar" do
    [1,2,3].andand.to_s.should == "123"
    nil.andand.to_s.should == nil
  end

  it "rewrites sends with 1 argument" do
    [1,2,3].andand.inject(:+).should == 6
    #
  end

  it "rewrites sends with many arguments" do
    [1,2,3].andand.inject(0, :+).should == 6
  end

  it "rewrites sends with block" do
    [1,2,3].andand.inject { |sum,n| sum + n}.should == 6
  end

  it "rewrites sends with passed block" do
    sum = proc { |sum,n| sum + n}
    [1,2,3].andand.inject(&sum).should == 6
  end

  it "rewrites sends with passed block and argument" do
    sum = proc { |sum,n| sum + n}
    [1,2,3].andand.inject(0, &sum).should == 6
  end

  it "rewrites sends with block and argument" do
    [1,2,3].andand.inject(0) { |sum,n| sum + n}.should == 6
  end

  describe "with blocks" do
    it "passes left argument as a block parameter" do
      'foo'.andand { |fu| fu + 'bar'}.should == 'foobar'
      # fu = 'foo' and fu + 'bar'
      #
    end

#    it "degenerates block with no parameter and one statement" do
#      'foo'.andand { :bar }.should == :bar
#    end
  end
end
