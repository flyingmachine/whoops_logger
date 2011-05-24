module WhoopsNotifier
  autoload :Configuration, 'whoops_notifier/configuration'
  autoload :Investigator,  'whoops_notifier/investigator'
  autoload :Report,        'whoops_notifier/report'
  autoload :Sender,        'whoops_notifier/sender'
  autoload :Strategy,      'whoops_notifier/strategy'
  
  class << self
    attr_accessor :strategies
    def notify(strategy_name, evidence = {})
      if strategy_name.is_a? Hash
        notify(strategies["default::basic"], strategy_name)
      else
        investigator = Investigator.new(strategies[strategy_name], evidence)
        investigator.investigate!
      end
    end
  end
  
  self.strategies = {}
end