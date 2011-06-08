rspec_dir = File.dirname(__FILE__)

$LOAD_PATH.unshift(File.join(rspec_dir, '..', 'lib'))
$LOAD_PATH.unshift(rspec_dir)
require 'rspec'
require 'whoops_notifier'
require 'fakeweb'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{rspec_dir}/support/**/*.rb"].each {|f| require f}

WhoopsNotifier.config.set(File.join(rspec_dir, "fixtures", "whoops_notifier.yml"))