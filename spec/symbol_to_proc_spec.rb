describe "Symbol to proc macro" do

  before(:all) do
    Symbol.class_eval do
      def to_proc
        raise "undefined"
      end
    end
  end

  it "rewrites &:sym_name as a proc {|x| x.sym_name}" do
    [1,2].map(&:to_s).should == ["1", "2"]
  end

  it "binds to Symbol#to_proc calls" do
    # :abc.to_proc == proc {|x| x.abc}
    p = :to_s.to_proc
    p.call(0).should == "0"
  end

end
