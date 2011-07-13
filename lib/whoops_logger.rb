require 'net/http'
require 'net/https'
require 'json'

module WhoopsLogger
  autoload :Configuration, 'whoops_logger/configuration'
  autoload :Investigator,  'whoops_logger/investigator'
  autoload :Message,       'whoops_logger/message'
  autoload :Sender,        'whoops_logger/sender'
  autoload :Strategy,      'whoops_logger/strategy'
  
  class << self
    attr_accessor :strategies, :config
    
    # @overload notify(raw_data)
    #   Notify using the default basic strategy
    #   @param [Hash] raw_data the raw_data expected by the basic strategy, used by strategy to build message
    # @overload notify(strategy_name, raw_data)
    #   @param [Symbol, String] strategy_name
    #   @param [Hash] raw_data same as above
    def notify(strategy_name, raw_data = {})
      if strategy_name.is_a? Hash
        notify("default::basic", strategy_name)
      else
        investigator = Investigator.new(strategies[strategy_name], raw_data)
        investigator.investigate!
        send_message(investigator.message) unless investigator.ignore_message?
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