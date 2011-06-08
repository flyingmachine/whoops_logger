describe "WhoopsNotifier::Configuration" do
  describe "#set" do 
    before(:each) {
      @real_config = WhoopsNotifier.config.to_hash
      WhoopsNotifier::Configuration::OPTIONS.each do |option|
        WhoopsNotifier.config.send("#{option}=", nil) if WhoopsNotifier.config.respond_to?("#{option}=".to_sym)
      end
    }
    after(:each) { 
      WhoopsNotifier.config.set(@real_config)
    }
    
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