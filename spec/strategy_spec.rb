require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "WhoopsNotifier::Strategy" do
  describe "#initialize" do
    it "should add strategy to WhoopsNotifier.strategies" do
      s = WhoopsNotifier::Strategy.new(:test)
      WhoopsNotifier.strategies[:test].should == s
    end
    
    it "should create empty arrays for ignore criteria and report_modifiers" do
      s = WhoopsNotifier::Strategy.new(:test)
      s.ignore_criteria.should == []
      s.report_modifiers.should == []
    end
  end
  
  describe "#add_report_modifier" do
    it "should add a named block" do
      s = WhoopsNotifier::Strategy.new(:test)
      s.add_report_modifier(:add_message) { |investigator| }

      s.report_modifiers.first.name.should == :add_message
    end
  end
  
  describe "#call" do
    it "should change the investigator's 'ignore' attribute to true if any ignore criteria are true" do
      strategy = WhoopsNotifier::Strategy.new(:test)
      investigator = WhoopsNotifier::Investigator.new(strategy, nil)
      
      strategy.add_ignore_criterion(:always_ignore) do |report|
        true
      end
      
      strategy.call(investigator)
      investigator.ignore_report.should == true
    end
    
    it "should modify the investigator's report according to the report modifiers" do
      strategy = WhoopsNotifier::Strategy.new(:test)
      investigator = WhoopsNotifier::Investigator.new(strategy, {:service => "service"})
      strategy.add_report_modifier(:add_details){ |report, evidence|
        report.service = evidence[:service] + " test"
      }
      
      strategy.call(investigator)
      
      investigator.report.service.should == "service test"
    end
  end
  
  describe "#inspect" do
    it "should list name, report modifier names, and ignore criteria names" do
      strategy = WhoopsNotifier::Strategy.new(:awesome_strategy)
      investigator = WhoopsNotifier::Investigator.new(strategy, nil)
      
      strategy.add_report_modifier(:report1){ }
      strategy.add_report_modifier(:report2){ }
      
      strategy.add_ignore_criterion(:ignore1){ true }
      strategy.add_ignore_criterion(:ignore2){ true }
      
      strategy.inspect.should == "awesome_strategy
report modifiers: report1, report2
ignore criteria: ignore1, ignore2"
      
    end
  end
end