module WhoopsNotifier
  class Investigator
    # get data from evidence using a strategy to create a report and decide whether it should be ignored
    attr_accessor :strategy, :report, :evidence, :ignore_report
    alias :ignore_report? :ignore_report

    def initialize(strategy, evidence)
      raise ArgumentError, "strategy can not be nil" if strategy.nil?
      raise ArgumentError, "strategy must respond to 'call'" unless strategy.respond_to?(:call)
      self.strategy = strategy
      self.evidence = evidence
      self.report = Report.new
    end
    
    def investigate!
      create_report
    end
    
    def create_report
      strategy.call(self)
    end
  end
end