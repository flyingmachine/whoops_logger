module WhoopsLogger
  class Message
    ATTRIBUTES = [
      :event_type,
      :service, 
      :environment,
      :message,
      :event_group_identifier,
      :event_time,
      :details,
      :logger_strategy_name
    ]
    ATTRIBUTES.each do |attribute|
      attr_accessor attribute
    end
    
    attr_accessor :ignore
    
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
    
    def ignore?
      ignore
    end
  end
end