$:.unshift File.dirname(__FILE__)

require 'oj'
require 'multi_json'
require 'redis'
require 'hiredis'
require 'em-synchrony'
require 'sinatra/base'
require 'sinatra/synchrony'
require 'awesome_print'
require "addressable/uri"
require "multimap"
require 'em-synchrony/em-http'
require 'mailgunner'

module PuneRuby; end

require 'pune_ruby/store'
require 'pune_ruby/app'

PuneRuby::Store.init_db