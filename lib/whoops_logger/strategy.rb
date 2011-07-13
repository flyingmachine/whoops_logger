module WhoopsLogger
  
  # Strategies are responsible for building messages and determining whether a
  # a message should be ignored.
  #
  # Each strategy contains any number of message builders and ignore criteria.
  # 
  # Each message builder and ignore criteria takes a name. This makes adding a
  # message builder or ignore criteria more like adding a method - the name 
  # makes it easier to see the intention of the code. It also makes it easier
  # to get useful info when you inspect the strategy.
  #
  # Strategies use call to actually apply modifiers and criteria for the same
  # reason that Rack uses call. Conceivably, you could add a strategy to the
  # notifier with 
  # WhoopsLogger.strategies[:lambda_stragey] = lambda{ |message, raw_data| 
  #   message.details = raw_data[:detail]
  # }
  # or something along those lines. 
  class Strategy
    attr_accessor :name, :ignore_criteria, :message_builders

    def initialize(name)
      self.name             = name
      self.ignore_criteria  = []
      self.message_builders = []
      WhoopsLogger.strategies[name] = self
    end
    
    def call(message, raw_data)
      message_builders.each do |message_modifier|
        message_modifier.call(message, raw_data)
      end
      
      ignore_criteria.each do |ignore_criterion|
        if ignore_criterion.call(message, raw_data)
          message.ignore = true
          break
        end
      end
    end
    
    # block should take two params, the message and the raw_data
    # use raw_data to build the message
    def add_message_builder(name, &block)
      give_name(name, block)
      @message_builders << block
    end
    
    # block takes one param, the investigator's message
    def add_ignore_criteria(name, &block)
      give_name(name, block)
      @ignore_criteria << block
    end
    
    def give_name(name, block)
      class << block
        attr_accessor :name
      end
      block.name = name
    end
    
    def inspect
      "#{name}\nmessage builders: #{message_builders.collect{|r| r.name}.join(", ")}\nignore criteria: #{ignore_criteria.collect{|i| i.name}.join(", ")}"
    end
  end
end