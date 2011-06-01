describe "WhoopsNotifier::Configuration" do
  describe "#set" do 
    after(:each) { WhoopsNotifier.config.host = nil }
    let(:config_path) { File.join(File.dirname(__FILE__), "fixtures/whoops_notifier.yml") }
    it "should set the config from a yaml filename" do
      WhoopsNotifier.config.set(config_path)
      WhoopsNotifier.config.host.should == "whoops.com"
    end

    it "should set the config from a file" do
      WhoopsNotifier.config.set(File.open(config_path))
      WhoopsNotifier.config.host.should == "whoops.com"
    end

    it "should set the config from a hash" do
      WhoopsNotifier.config.set({
        :host => "whoops.com",
      })
      WhoopsNotifier.config.host.should == "whoops.com"
    end
    
    it "should allow string keys" do
      WhoopsNotifier.config.set({
        "host" => "whoops.com",
      })
      WhoopsNotifier.config.host.should == "whoops.com"
    end
  end
end