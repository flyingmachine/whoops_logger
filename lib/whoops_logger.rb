require 'net/http'
require 'net/https'
require 'json'

module WhoopsLogger
  autoload :Configuration,   'whoops_logger/configuration'
  autoload :MessageCreator,  'whoops_logger/message_creator'
  autoload :Message,         'whoops_logger/message'
  autoload :Sender,          'whoops_logger/sender'
  autoload :Strategy,        'whoops_logger/strategy'
  
  class << self
    attr_accessor :strategies, :config
    
    # @overload log(raw_data)
    #   Notify using the default basic strategy
    #   @param [Hash] raw_data the raw_data expected by the basic strategy, used by strategy to build message
    # @overload log(strategy_name, raw_data)
    #   @param [Symbol, String] strategy_name
    #   @param [Hash] raw_data same as above
    def log(strategy_name, raw_data = {})
      if strategy_name.is_a? Hash
        log("default::basic", strategy_name)
      else
        message_creator = MessageCreator.new(strategies[strategy_name], raw_data)
        message_creator.create!
        send_message(message_creator.message) unless message_creator.ignore_message?
      end
    end
    
    def send_message(message)
      Sender.new(WhoopsLogger.config.to_hash).send_message(message.to_hash)
    end
  end
  
  def self.config
    @config ||= Configuration.new
  end
  
  self.strategies = {}
end

Dir[File.join(File.dirname(__FILE__),"whoops_logger/strategies/*.rb")].each do |strategy_file|
  require strategy_file
end