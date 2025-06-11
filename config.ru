require 'bundler'
Bundler.require

set :port, 4567

require './lib/controller'
run Sinatra::Application



