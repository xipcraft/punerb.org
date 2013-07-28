ENV['RACK_ENV'] = 'test'

require File.join(File.dirname(__FILE__), '..', '..', 'lib/pune_ruby.rb')
require 'capybara'
require 'webmock/cucumber'
require 'capybara/cucumber'
require 'rspec'
require 'pune_ruby/test'
require 'timecop'
require 'webrat'
require 'rack/test'

Capybara.app = PuneRuby::App

Webrat.configure do |config|
  config.mode = :rack
end

# Select an alternative database so that parallel test execution can happen smoothly
EM.synchrony { PuneRuby::Store.gdb.select(1); EM.stop} if ENV['DB_ONE']
EM.synchrony { PuneRuby::Store.gdb.select(2); EM.stop} if ENV['DB_TWO']

Sinatra::Synchrony.patch_tests!

class PuneRubyCukeWorld
  include Capybara::DSL
  include RSpec::Expectations
  include RSpec::Matchers
  include PuneRuby::Test

  include Rack::Test::Methods
  include Webrat::Methods
  include Webrat::Matchers

  Webrat::Methods.delegate_to_session :response_code, :response_body

  def app; PuneRuby::App; end
end

World do
  PuneRubyCukeWorld.new
end

Before do
  EM.stop if EM.reactor_running?
  EM.synchrony { PuneRuby::Store.flush_db; EM.stop }

  # O4:00 In the evening on November 26th, 2012 which was a Monday
  @present_time = Time.local(2012,11,26,16,00,00)

  Timecop.travel @present_time

  # WebMock.allow_net_connect!
end

After do
  EM.stop if EM.reactor_running?
  EM.synchrony { PuneRuby::Store.flush_db; EM.stop }

  Timecop.return
end


