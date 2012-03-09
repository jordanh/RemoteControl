require 'rubygems'
require 'sinatra'
require 'json'
require 'warden'
require './main.rb'

Rack::Builder.new do
  use Rack::Session::Cookie, :secret => "replace this with some secret key"

  use Warden::Manager do |manager|
    manager.default_strategies :password, :basic
    manager.failure_app = Sinatra::Application
  end

  run Sinatra::Application
end