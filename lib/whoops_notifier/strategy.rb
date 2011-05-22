module WhoopsNotifier
  class Strategy
    # ask witnesses for data, create a report using a strategy, send or ignore
    attr_accessor :name, :ignore_criteria, :report_modifiers

    def initialize(strategy, witnesses)
      self.strategy = strategy
      self.witnesses = witnesses
      
      create_report
      send unless ingore
    end
    
    def apply(interrogator)
      report_modifiers.each do |report_modifier|
        report_modifier.call(interrogator)
      end
      
      ignore_criteria.each do |ignore_criterion|
        if ignore_criterion.call(interrogator.report)
          interrogator.ignore_report = true
          break
        end
      end
    end
    
    def create_report
      strategy.apply(self)
    end
    
    def send
      Sender.send(self.report)
    end
    
    # def add_report_modifier
    # end
    # 
    # def add_ignore_criterion
    # end
    
  end
end