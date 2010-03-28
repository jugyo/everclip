$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'spec'
require 'spec/autorun'

module PBDB
  DIR = File.dirname(__FILE__)
  File.delete(File.join(DIR, 'db'))
end

require 'pbdb'

Spec::Runner.configure do |config|
  config.mock_with :rr
end
