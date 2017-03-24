libdir = File.dirname(__FILE__)
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)
Dir.glob(File.join(libdir, 'besepa', 'utils','*.rb')).each {|f| require f }
Dir.glob(File.join(libdir, 'besepa', 'api_calls','*.rb')).each {|f| require f }
require File.join(libdir, 'besepa', 'errors', 'besepa_error.rb')
Dir.glob(File.join(libdir, 'besepa', 'errors','*.rb')).each {|f| require f }
require File.join(libdir, 'besepa', 'resource.rb')
Dir.glob(File.join(libdir, 'besepa', '*.rb')).each {|f| require f }

module Besepa

  extend Utils::ApiConfig

end
