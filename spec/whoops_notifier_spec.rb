require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "WhoopsNotifier" do
  before(:each) { FakeWeb.clean_registry }
  
  describe ".strategies" do
    it "is a hash with keys of strategy names and values of strategy objects" do
      WhoopsNotifier.strategies.each do |key, value|
        (key.instance_of?(Symbol) || key.instance_of?(String)).should be_true
        value.should be_a WhoopsNotifier::Strategy
      end
    end
  end
  
  describe ".config" do
    it "returns a WhoopsNotifier::Configuration object" do
      WhoopsNotifier.config.should be_a(WhoopsNotifier::Configuration)
    end
  end
  
  describe ".notify" do
    let(:investigator){ double(:investigator, :investigate! => nil, :report => nil) }
    
    it "uses the basic strategy if no strategy name is provided" do
      WhoopsNotifier.stub(:send_report)
      investigator.stub(:ignore_report?).and_return(false)
      WhoopsNotifier::Investigator.should_receive(:new).with(WhoopsNotifier.strategies["default::basic"], {}).and_return(investigator)
      WhoopsNotifier.notify({})
    end
    
    it "sends a report when the investigator is not ignoring the event" do
      investigator.should_receive(:ignore_report?).and_return(false)
      WhoopsNotifier::Investigator.stub(:new).and_return(investigator)
      
      WhoopsNotifier.should_receive(:send_report)
      WhoopsNotifier.notify({})
    end
    
    it "does not sned a request if the investigator is ignoring the event" do
      investigator.should_receive(:ignore_report?).and_return(true)
      WhoopsNotifier::Investigator.stub(:new).and_return(investigator)
      
      WhoopsNotifier.should_not_receive(:send_report)
      WhoopsNotifier.notify({})
    end
  end
  
  describe ".send_report" do
    it "should send a report to the configured URL" do
      FakeWeb.register_uri(:post, "http://whoops.com/events/", :body => "success")
      WhoopsNotifier.notify({})
      request = FakeWeb.last_request
      request.body.should =~ /"event"/
    end
  end
end