strategy = WhoopsNotifier::Strategy.new("default::basic")

strategy.add_report_modifier(:use_basic_hash) do |report, evidence|
  report.event_type             = evidence[:event_type]
  report.service                = evidence[:service]
  report.environment            = evidence[:environment]
  report.message                = evidence[:message]
  report.event_group_identifier = evidence[:event_group_identifier]
  report.event_time             = evidence[:event_time] if evidence[:event_time]
  report.details                = evidence[:details]
end