module WhoopsNotifier
  class Investigator
    # ask witnesses for data, create a report using a strategy, send or ignore
    attr_accessor :strategy, :report, :witnesses, :ignore_report

    def initialize(strategy, witnesses)
      self.strategy = strategy
      self.witnesses = witnesses
      self.report = Report.new
    end
    
    def investigate!
      create_report
      send unless ignore_report
    end
    
    def create_report
      strategy.apply(self)
    end
    
    def send
      Sender.send_report(self.report)
    end
  end
end