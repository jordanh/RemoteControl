require 'rubygems'
require 'sinatra'
require 'cgi'
require 'json'
require 'rack/ssl'
require './main'
require './src/digiAPI'

disable :sessions
disable :flash
use Rack::SSL, :exclude => lambda { |env| env["SERVER_NAME"] == "localhost" || env["SERVER_NAME"] == "mlm-mbp.local"}
	
use Rack::Session::Pool, :expire_after => 2592000, :key => 'rack.session', :secret => ENV['SESSION_KEY']  || 'session secret'	

run Main::App
