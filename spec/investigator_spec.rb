require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "WhoopsNotifier::Investigator" do
  describe "#initialize" do
    it "should raise an exception if strategy is nil" do
      lambda{WhoopsNotifier::Investigator.new(nil, {})}.should raise_exception(ArgumentError)
    end
    
    it "should raise an exception if strategy argument does not respond to call" do
      lambda{WhoopsNotifier::Investigator.new(true, {})}.should raise_exception(ArgumentError)
    end
    
    it "should not raise an exception if strategy argument responds to call" do
      lambda{WhoopsNotifier::Investigator.new(Proc.new{}, {})}.should_not raise_exception
    end
  end
end