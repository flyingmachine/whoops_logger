require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "WhoopsLogger" do
  before(:each) { FakeWeb.clean_registry }
  
  describe ".strategies" do
    it "is a hash with keys of strategy names and values of strategy objects" do
      WhoopsLogger.strategies.each do |key, value|
        (key.instance_of?(Symbol) || key.instance_of?(String)).should be_true
        value.should be_a WhoopsLogger::Strategy
      end
    end
  end
  
  describe ".config" do
    it "returns a WhoopsLogger::Configuration object" do
      WhoopsLogger.config.should be_a(WhoopsLogger::Configuration)
    end
  end
  
  describe ".log" do
    let(:message_creator){ double(:message_creator, :create! => nil, :message => nil) }
    
    it "uses the basic strategy if no strategy name is provided" do
      WhoopsLogger.stub(:send_message)
      message_creator.stub(:ignore_message?).and_return(false)
      WhoopsLogger::MessageCreator.should_receive(:new).with(WhoopsLogger.strategies["default::basic"], {}).and_return(message_creator)
      WhoopsLogger.log({})
    end
    
    it "sends a message when the message_creator is not ignoring the event" do
      message_creator.should_receive(:ignore_message?).and_return(false)
      WhoopsLogger::MessageCreator.stub(:new).and_return(message_creator)
      
      WhoopsLogger.should_receive(:send_message)
      WhoopsLogger.log({})
    end
    
    it "does not sned a request if the message_creator is ignoring the event" do
      message_creator.should_receive(:ignore_message?).and_return(true)
      WhoopsLogger::MessageCreator.stub(:new).and_return(message_creator)
      
      WhoopsLogger.should_not_receive(:send_message)
      WhoopsLogger.log({})
    end
  end
  
  describe ".send_message" do
    it "should send a message to the configured URL" do
      FakeWeb.register_uri(:post, "http://whoops.com/events/", :body => "success")
      WhoopsLogger.log({})
      request = FakeWeb.last_request
      request.body.should =~ /"event"/
    end
  end
end