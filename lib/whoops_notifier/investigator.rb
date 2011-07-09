module WhoopsNotifier
  class Investigator
    # get data from evidence using a strategy to create a report and decide whether it should be ignored
    attr_accessor :strategy, :report, :evidence

    def initialize(strategy, evidence)
      raise ArgumentError, "strategy can not be nil" if strategy.nil?
      raise ArgumentError, "strategy must respond to 'call'" unless strategy.respond_to?(:call)
      self.strategy = strategy
      self.evidence = evidence
      self.report = Report.new
    end
    
    def investigate!
      strategy.call(report, evidence)
    end
    
    def ignore_report?
      report.ignore?
    end
  end
end