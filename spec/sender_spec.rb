require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe WhoopsNotifier::Sender do
  describe "#send_report" do
    it "should send a report to the configured URL when given a config object" do
      FakeWeb.register_uri(:post, "http://whoops.com/events/", :body => "success")
      
      sender = WhoopsNotifier::Sender.new(WhoopsNotifier.config)
      sender.send_report({:test => true})

      request = FakeWeb.last_request
      request.body.should =~ /"test"/
    end
  end
end