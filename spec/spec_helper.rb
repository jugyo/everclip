$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'spec'
require 'spec/autorun'

require 'everclip'

EverClip.init(File.dirname(__FILE__))
db_file_path = File.join(File.dirname(__FILE__), 'db')
File.delete(db_file_path) if File.exists?(db_file_path)
EverClip::PID_FILE = '/tmp/everclip_pid_test'
File.delete(EverClip::PID_FILE) if File.exists?(EverClip::PID_FILE)

Spec::Runner.configure do |config|
  config.mock_with :rr
end
