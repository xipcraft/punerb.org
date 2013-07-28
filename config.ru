require 'rubygems'
require File.join(File.dirname(__FILE__), 'lib/pune.rb')

#use Rack::FiberPool
run Pune::App