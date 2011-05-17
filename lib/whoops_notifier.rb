%w(configuration event_notification sender).each do |file|
  require "whoops_notifier/#{file}"
end