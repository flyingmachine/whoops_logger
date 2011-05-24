module WhoopsNotifier
  class Investigator
    # get data from evidence using a strategy to create a report, then send or ignore
    attr_accessor :strategy, :report, :evidence, :ignore_report

    def initialize(strategy, evidence)
      self.strategy = strategy
      self.evidence = evidence
      self.report = Report.new
    end
    
    def investigate!
      create_report
      send_report unless ignore_report
    end
    
    def create_report
      strategy.apply(self)
    end
    
    def send_report
      Sender.send_report(self.report)
    end
  end
end