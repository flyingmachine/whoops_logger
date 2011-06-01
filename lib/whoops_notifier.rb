require 'net/http'
require 'net/https'
require 'json'

module WhoopsNotifier
  autoload :Configuration, 'whoops_notifier/configuration'
  autoload :Investigator,  'whoops_notifier/investigator'
  autoload :Report,        'whoops_notifier/report'
  autoload :Sender,        'whoops_notifier/sender'
  autoload :Strategy,      'whoops_notifier/strategy'
  
  class << self
    attr_accessor :strategies, :config
    def notify(strategy_name, evidence = {})
      if strategy_name.is_a? Hash
        notify("default::basic", strategy_name)
      else
        investigator = Investigator.new(strategies[strategy_name], evidence)
        investigator.investigate!
      end
    end
  end
  
  def self.config
    @config ||= Configuration.new
  end
  
  
  self.strategies = {}
end

Dir[File.join(File.dirname(__FILE__),"whoops_notifier/strategies/*.rb")].each do |strategy_file|
  require strategy_file
end