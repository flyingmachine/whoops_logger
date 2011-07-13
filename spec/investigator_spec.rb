require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "WhoopsLogger::Investigator" do
  describe "#initialize" do
    it "should raise an exception if strategy is nil" do
      lambda{WhoopsLogger::Investigator.new(nil, {})}.should raise_exception(ArgumentError)
    end
    
    it "should raise an exception if strategy argument does not respond to call" do
      lambda{WhoopsLogger::Investigator.new(true, {})}.should raise_exception(ArgumentError)
    end
    
    it "should not raise an exception if strategy argument responds to call" do
      lambda{WhoopsLogger::Investigator.new(Proc.new{}, {})}.should_not raise_exception
    end
  end
  
  describe "#investigate!" do
    it "should not send report if ignore_report? is true" do
      strategy = lambda{}
      investigator = WhoopsLogger::Investigator.new(strategy, {})
      investigator.stub(:ignore_report?).and_return(true)
      
      investigator.should_not_receive(:send_report)
      
      investigator.investigate!
    end
  end  
end