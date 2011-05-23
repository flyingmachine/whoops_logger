require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "WhoopsNotifier::Strategy" do
  describe "#add_report_modifier" do
    it "should add a named block" do
      s = WhoopsNotifier::Strategy.new(:test)      
      s.add_report_modifier(:add_message) { |investigator| }

      s.report_modifiers.first.name.should == :add_message
    end
  end
  
  describe "#apply" do
    it "should change the investigator's 'ignore' attribute to true if any ignore criteria are true" do
      strategy = WhoopsNotifier::Strategy.new(:test)
      investigator = WhoopsNotifier::Investigator.new(strategy, nil)
      
      strategy.add_ignore_criterion(:always_ignore) do |report|
        true
      end
      
      strategy.apply(investigator)
      investigator.ignore_report.should == true
    end
  end
end