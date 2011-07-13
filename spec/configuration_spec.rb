describe "WhoopsLogger::Configuration" do
  describe "#set" do 
    before(:each) {
      @real_config = WhoopsLogger.config.to_hash
      WhoopsLogger::Configuration::OPTIONS.each do |option|
        WhoopsLogger.config.send("#{option}=", nil) if WhoopsLogger.config.respond_to?("#{option}=".to_sym)
      end
    }
    after(:each) { 
      WhoopsLogger.config.set(@real_config)
    }
    
    let(:config_path) { File.join(File.dirname(__FILE__), "fixtures/whoops_logger.yml") }
    it "should set the config from a yaml filename" do
      WhoopsLogger.config.set(config_path)
      WhoopsLogger.config.host.should == "whoops.com"
    end

    it "should set the config from a file" do
      WhoopsLogger.config.set(File.open(config_path))
      WhoopsLogger.config.host.should == "whoops.com"
    end

    it "should set the config from a hash" do
      WhoopsLogger.config.set({
        :host => "whoops.com",
      })
      WhoopsLogger.config.host.should == "whoops.com"
    end
    
    it "should allow string keys" do
      WhoopsLogger.config.set({
        "host" => "whoops.com",
      })
      WhoopsLogger.config.host.should == "whoops.com"
    end
  end
end