require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Marriage do
  
  def self.it_should_be_valid_for(person1, person2)
    it "should be valid for #{person1} - #{person2}" do
      person1 = instance_variable_get("@#{person1}1")
      person2 = instance_variable_get("@#{person2}2")

      @marriage = Marriage.new(:person => person1, :spouse => person2)
      @marriage.should be_valid

      @marriage = Marriage.new(:person => person2, :spouse => person1)
      @marriage.should be_valid
    end
  end

  def self.it_should_not_be_valid_for(person1, person2)
    it "should not be valid for #{person1} - #{person2}" do
      person1 = instance_variable_get("@#{person1}1")
      person2 = instance_variable_get("@#{person2}2")

      @marriage = Marriage.new(:person => person1, :spouse => person2)
      @marriage.should_not be_valid

      @marriage = Marriage.new(:person => person2, :spouse => person1)
      @marriage.should_not be_valid
    end
  end

  before do
    @unmarried1 = Person.make
    @unmarried2 = Person.make
    
    @married1 = Person.make 
    @married2 = Person.make
    @old_marriage = Marriage.create!(:person => @married1, :spouse => @married2)
    @married1.reload # <- Don't rely on the other ends of the associations
    @married2.reload #    being updated -- they are not.

    @divorced1 = Person.make 
    @divorced2 = Person.make
    @divorced_marriage = Marriage.create!(
      :person => @divorced1, :spouse => @divorced2,
      :start_date => 10.years.ago, :end_date => 1.day.ago
    )
    @divorced1.reload
    @divorced2.reload
  end

  it "is between two different people" do
    marriage = Marriage.new(:person => @unmarried1, :spouse => @unmarried1)
    marriage.should_not be_valid
  end

  it_should_be_valid_for     :unmarried, :unmarried
  it_should_be_valid_for     :unmarried, :divorced
  it_should_be_valid_for     :divorced,  :unmarried
  it_should_be_valid_for     :divorced,  :divorced
  
  it_should_not_be_valid_for :married,   :unmarried
  it_should_not_be_valid_for :married,   :married
  it_should_not_be_valid_for :married,   :divorced
  it_should_not_be_valid_for :unmarried, :married
  it_should_not_be_valid_for :married,   :married
  it_should_not_be_valid_for :divorced,  :married
  
  describe "after saving" do
    before do
      @marriage = Marriage.create!(:person => @unmarried1, :spouse => @unmarried2)
      @unmarried1.reload
      @unmarried2.reload
    end

    it "is known to the first partner" do
      @unmarried1.should have(1).marriages
      @unmarried1.spouse.should == @unmarried2
    end
    
    it "is known to the second partner" do
      @unmarried2.should have(1).marriages
      @unmarried2.spouse.should == @unmarried1
    end
  end
  
  describe ", divorced" do
    it "is no longer current" do
      @divorced1.marriages.at(Date.today).should be_nil
      @divorced2.marriages.at(Date.today).should be_nil
    end
    
    it "is remembered by the divorced couple" do
      @divorced1.marriages.at(2.year.ago).should == @divorced_marriage
      @divorced2.marriages.at(2.year.ago).should == @divorced_marriage
    end
  end
  
  describe "affects people's marriage status" do
    it "marks them as unmarried" do
      @unmarried1.marriages.status.should == :unmarried
    end

    it "marks them as married" do
      @married1.marriages.status.should == :married
    end

    it "marks them as divorced" do
      @divorced1.marriages.status.should == :divorced
    end
  end
end
