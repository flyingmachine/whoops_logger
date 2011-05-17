require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "WhoopsNotifier::EventNotification" do
  describe ".before_send" do
    it "should add a block if one provided, otherwise return an array of blocks" do
      WhoopsNotifier::EventNotification.before_send { "test" }
      WhoopsNotifier::EventNotification.before_send.size.should == 1 
      WhoopsNotifier::EventNotification.before_send[0].call.should == "test"
    end
  end
end