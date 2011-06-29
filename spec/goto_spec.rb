describe "Goto macro" do

  context "standard goto functionality" do
    it "provides label and goto" do
      a = 1
      goto :there
      a = 2
      label :there
      a.should == 1
    end

    it "works with multiple gotos and labels" do
      a = 1
      goto :last
      a = 2
      label :first
      a = 3
      goto :end
      label :last
      goto :first
      a = 4
      label :end
      a.should == 3
    end

    it "branches execution inside if exprs" do
      if true
        goto :true
      else
        goto :false
      end
      label :false
      raise "false called"
      label :true
      true.should == true
    end

  end

  it "resolves label names in the current method scope" do

    class GotoMethodScopeTest
      def test1
        a = 1
        goto :next
        a = 2
        label :next
        a
      end
      def test2
        a = 3
        goto :next
        a = 4
        label :next
        a
      end
    end

    t = GotoMethodScopeTest.new
    t.test1.should == 1
    t.test2.should == 3
  end


end
