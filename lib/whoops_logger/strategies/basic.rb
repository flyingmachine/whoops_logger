strategy = WhoopsLogger::Strategy.new("default::basic")

strategy.add_message_builder(:use_basic_hash) do |message, raw_data|
  message.event_type             = raw_data[:event_type]
  message.service                = raw_data[:service]
  message.environment            = raw_data[:environment]
  message.message                = raw_data[:message]
  message.event_group_identifier = raw_data[:event_group_identifier]
  message.event_time             = raw_data[:event_time] if raw_data[:event_time]
  message.details                = raw_data[:details]
end