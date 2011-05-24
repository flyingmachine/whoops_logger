module WhoopsNotifier
  class Report
    attr_accessor :event_type
    attr_accessor :service
    attr_accessor :environment
    attr_accessor :message
    attr_accessor :identifier
    attr_accessor :event_time
    attr_accessor :details
    
    def initialize
      self.event_time = Time.now
    end
  end
end