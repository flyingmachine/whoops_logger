rspec_dir = File.dirname(__FILE__)

$LOAD_PATH.unshift(File.join(rspec_dir, '..', 'lib'))
$LOAD_PATH.unshift(rspec_dir)
require 'rspec'
require 'whoops_logger'
require 'fakeweb'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{rspec_dir}/support/**/*.rb"].each {|f| require f}

WhoopsLogger.config.set(File.join(rspec_dir, "fixtures", "whoops_logger.yml"))