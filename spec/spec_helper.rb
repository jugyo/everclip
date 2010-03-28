$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'spec'
require 'spec/autorun'

module PBDB
  DIR = File.dirname(__FILE__)
  db_file_path = File.join(DIR, 'db')
  File.delete(db_file_path) if File.exists?(db_file_path)
end

require 'pbdb'

Spec::Runner.configure do |config|
  config.mock_with :rr
end
