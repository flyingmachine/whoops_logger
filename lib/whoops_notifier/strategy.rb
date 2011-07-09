module WhoopsNotifier
  class Strategy
    # ask witnesses for data, create a report using a strategy, send or ignore
    attr_accessor :name, :ignore_criteria, :report_builders

    def initialize(name)
      self.name             = name
      self.ignore_criteria  = []
      self.report_builders = []
      WhoopsNotifier.strategies[name] = self
    end
    
    def call(report, evidence)
      report_builders.each do |report_modifier|
        report_modifier.call(report, evidence)
      end
      
      ignore_criteria.each do |ignore_criterion|
        if ignore_criterion.call(report)
          report.ignore = true
          break
        end
      end
    end
    
    # block should take one param, the investigator
    # use evidence to build the report
    def add_report_builder(name, &block)
      give_name(name, block)
      @report_builders << block
    end
    
    # block takes one param, the investigator's report
    def add_ignore_criteria(name, &block)
      give_name(name, block)
      @ignore_criteria << block
    end
    
    def give_name(name, block)
      class << block
        attr_accessor :name
      end
      block.name = name
    end
    
    def inspect
      "#{name}\nreport modifiers: #{report_builders.collect{|r| r.name}.join(", ")}\nignore criteria: #{ignore_criteria.collect{|i| i.name}.join(", ")}"
    end
  end
end