module WhoopsNotifier
  class Report
    ATTRIBUTES = [:event_type, :service, :environment, :message, :identifier, :event_time, :details]
    ATTRIBUTES.each do |attribute|
      attr_accessor attribute
    end
    
    def initialize
      self.event_time = Time.now
    end
    
    def to_hash
      h = {}
      ATTRIBUTES.each do |attribute|
        h[attribute] = self.send(attribute)
      end
      h
    end
  end
end