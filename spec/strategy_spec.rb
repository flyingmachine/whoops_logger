require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "WhoopsLogger::Strategy" do
  describe "#initialize" do
    it "adds a strategy to WhoopsLogger.strategies" do
      s = WhoopsLogger::Strategy.new(:test)
      WhoopsLogger.strategies[:test].should == s
    end
    
    it "creates empty arrays for ignore criteria and message_builders" do
      s = WhoopsLogger::Strategy.new(:test)
      s.ignore_criteria.should == []
      s.message_builders.should == []
    end
  end
  
  describe "#add_message_builder" do
    it "adds a named block" do
      s = WhoopsLogger::Strategy.new(:test)
      s.add_message_builder(:add_message) { |message, raw_data| }

      s.message_builders.first.name.should == :add_message
    end
  end
  
  describe "#add_ignore_criteria" do
    it "adds a named ignore criteria block" do
      s = WhoopsLogger::Strategy.new(:test)
      s.add_ignore_criteria(:ignore_if_empty) { |message| }

      s.ignore_criteria.first.name.should == :ignore_if_empty
    end
  end
  
  describe "#call" do
    it "should change the investigator's 'ignore' attribute to true if any ignore criteria are true" do
      strategy = WhoopsLogger::Strategy.new(:test)
      investigator = WhoopsLogger::Investigator.new(strategy, nil)
      
      strategy.add_ignore_criteria(:always_ignore) do |message|
        true
      end
      
      strategy.call(investigator.message, investigator.raw_data)
      investigator.ignore_message?.should == true
    end
    
    it "should modify the investigator's message according to the message modifiers" do
      strategy = WhoopsLogger::Strategy.new(:test)
      investigator = WhoopsLogger::Investigator.new(strategy, {:service => "service"})
      strategy.add_message_builder(:add_details){ |message, raw_data|
        message.service = raw_data[:service] + " test"
      }
      
      strategy.call(investigator.message, investigator.raw_data)
      
      investigator.message.service.should == "service test"
    end
  end
  
  describe "#inspect" do
    it "should list name, message modifier names, and ignore criteria names" do
      strategy = WhoopsLogger::Strategy.new(:awesome_strategy)
      investigator = WhoopsLogger::Investigator.new(strategy, nil)
      
      strategy.add_message_builder(:message1){ }
      strategy.add_message_builder(:message2){ }
      
      strategy.add_ignore_criteria(:ignore1){ true }
      strategy.add_ignore_criteria(:ignore2){ true }
      
      strategy.inspect.should == "awesome_strategy
message builders: message1, message2
ignore criteria: ignore1, ignore2"
      
    end
  end
end