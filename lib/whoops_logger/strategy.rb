module WhoopsLogger
  
  # Strategies are responsible for building Reports and determining whether a
  # a Report should be ignored.
  #
  # Each strategy contains any number of report builders and ignore criteria.
  # 
  # Each report builder and ignore criteria takes a name. This makes adding a
  # report builder or ignore criteria more like adding a method - the name 
  # makes it easier to see the intention of the code. It also makes it easier
  # to get useful info when you inspect the strategy.
  #
  # Strategies use call to actually apply modifiers and criteria for the same
  # reason that Rack uses call. Conceivably, you could add a strategy to the
  # notifier with 
  # WhoopsLogger.strategies[:lambda_stragey] = lambda{ |report, evidence| 
  #   report.details = evidence[:detail]
  # }
  # or something along those lines. 
  class Strategy
    attr_accessor :name, :ignore_criteria, :report_builders

    def initialize(name)
      self.name             = name
      self.ignore_criteria  = []
      self.report_builders = []
      WhoopsLogger.strategies[name] = self
    end
    
    def call(report, evidence)
      report_builders.each do |report_modifier|
        report_modifier.call(report, evidence)
      end
      
      ignore_criteria.each do |ignore_criterion|
        if ignore_criterion.call(report, evidence)
          report.ignore = true
          break
        end
      end
    end
    
    # block should take two params, the report and the evidence
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
      "#{name}\nreport builders: #{report_builders.collect{|r| r.name}.join(", ")}\nignore criteria: #{ignore_criteria.collect{|i| i.name}.join(", ")}"
    end
  end
end