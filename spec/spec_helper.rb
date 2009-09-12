require 'rubygems'
require 'spork'
require 'fakeweb'
require 'init'

Spork.prefork do
  require 'spec/autorun'
  
  Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}
  
  FakeWeb.allow_net_connect = false

  Spec::Runner.configure do |config|
    # nothing
  end
end

Spork.each_run do
  # nothing
end

def fakeweb_read(filename)
  File.read(File.join(File.dirname(__FILE__), "fixtures", filename))
end