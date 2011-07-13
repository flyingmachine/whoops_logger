require 'net/http'
require 'net/https'
require 'json'

module WhoopsLogger
  autoload :Configuration, 'whoops_logger/configuration'
  autoload :Investigator,  'whoops_logger/investigator'
  autoload :Report,        'whoops_logger/report'
  autoload :Sender,        'whoops_logger/sender'
  autoload :Strategy,      'whoops_logger/strategy'
  
  class << self
    attr_accessor :strategies, :config
    
    # @overload notify(evidence)
    #   Notify using the default basic strategy
    #   @param [Hash] evidence the evidence expected by the basic strategy, used by strategy to build report
    # @overload notify(strategy_name, evidence)
    #   @param [Symbol, String] strategy_name
    #   @param [Hash] evidence same as above
    def notify(strategy_name, evidence = {})
      if strategy_name.is_a? Hash
        notify("default::basic", strategy_name)
      else
        investigator = Investigator.new(strategies[strategy_name], evidence)
        investigator.investigate!
        send_report(investigator.report) unless investigator.ignore_report?
      end
    end
    
    def send_report(report)
      Sender.new(WhoopsLogger.config.to_hash).send_report(report.to_hash)
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