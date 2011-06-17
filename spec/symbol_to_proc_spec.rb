describe "Symbol to proc macro" do

  before(:all) do
    Symbol.class_eval do
      def to_proc
        raise "undefined"
      end
    end
  end

  it "should handle (&:map) calls" do
    [1,2].map(&:to_s).should == ["1", "2"]
  end
end
