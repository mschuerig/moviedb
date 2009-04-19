require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

require 'rack/mock'

describe RequestConditioner do

  describe "given Range header" do
    before do
      @rc = RequestConditioner.new({'Range' => 'items=10-100'}, {})
    end
    
    it "extracts offset" do
      @rc.offset.should == 10
    end
    
    it "extracts limit" do
      @rc.limit.should == 91
    end

    describe "without end item" do
      before do
        @rc = RequestConditioner.new({'Range' => 'items=10-'}, {})
      end
    
      it "extracts offset" do
        @rc.offset.should == 10
      end
      
      it "extracts no limit" do
        @rc.limit.should be_nil
      end
    end
  end

  describe "with a normal, a mapped and a bad condition attribute" do
    before do
      @rc = RequestConditioner.new({},
        { :query => [{:attribute => 'normal', :op => '=', :target => 'usual'},
                     {:attribute => 'mapped', :op => '<', :target => 'connected'},
                     {:attribute => 'bad', :op => '>', :target => 'ignored'}] },
        { :allowed => ['normal', 'mapped'],
          :conditions => { :mapped => 'mapped1 :op ?' } }
      )
    end
    
    it "builds a condition array" do
      @rc.conditions.should == ["normal = ? AND mapped1 < ?", "usual", "connected"]
    end
  end
  
  describe "with a wildcard condition target" do
    before do
      @rc = RequestConditioner.new({},
        { :query => [{:attribute => 'name', :op => '=', :target => 'mys*'}] }
      )
    end
    
    it "converts the operation to a LIKE comparison" do
      @rc.conditions.should == ["name LIKE ?", "mys%"]
    end
  end
  
  describe "with two attribute target occurrences in template" do
    before do
      @rc = RequestConditioner.new({},
        { :query => [{:attribute => 'mapped', :op => '=', :target => '10'}] },
        { :conditions => { :mapped => '(mapped1 :op ?) OR (mapped2 :op ?)' } }
      )
    end
    
    it "adds target values twice" do
      @rc.conditions.should == ["(mapped1 = ?) OR (mapped2 = ?)", '10', '10']
    end
  end

  describe "with a normal, a mapped and a bad order attribute" do
    before do
      @rc = RequestConditioner.new({},
        { :order => [{:attribute => 'normal', :dir => 'DESC'},
                     {:attribute => 'mapped'},
                     {:attribute => 'bad'}] },
        { :allowed => ['normal', 'mapped'],
          :order => { :mapped => 'mapped1 :dir, mapped2 :dir' } }
      )
    end
    
    it "puts everything in order" do
      @rc.order.should == "normal DESC, mapped1 ASC, mapped2 ASC"
    end
  end
end
