module WhoopsNotifier
  class Investigator
    # get data from evidence using a strategy to create a report, then send or ignore
    attr_accessor :strategy, :report, :evidence, :ignore_report

    def initialize(strategy, evidence)
      raise ArgumentError, "strategy can not be nil" if strategy.nil?
      raise ArgumentError, "strategy must respond to 'call'" unless strategy.respond_to?(:call)
      self.strategy = strategy
      self.evidence = evidence
      self.report = Report.new
    end
    
    def investigate!
      create_report
      send_report unless ignore_report
    end
    
    def create_report
      strategy.call(self)
    end
    
    def send_report
      hash = {:event => self.report.to_hash}
      data = hash.to_json
      Sender.new(WhoopsNotifier.config.to_hash).send_report(data)
    end
  end
end