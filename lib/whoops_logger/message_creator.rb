module WhoopsLogger
  
  # A "glue" class which coordinates message creation
  class MessageCreator
    # get data from raw_data using a strategy to create a message and decide whether it should be ignored
    attr_accessor :strategy, :message, :raw_data

    def initialize(strategy, raw_data)
      raise ArgumentError, "strategy can not be nil" if strategy.nil?
      raise ArgumentError, "strategy must respond to 'call'" unless strategy.respond_to?(:call)
      self.strategy = strategy
      self.raw_data = raw_data
      self.message = Message.new
      self.message.event_time = Time.now
      self.message.logger_strategy_name = strategy.respond_to?(:name) ? strategy.name : 'anonymous'
    end
    
    def create!
      strategy.call(message, raw_data)
    end
    
    def ignore_message?
      message.ignore?
    end
  end
end
