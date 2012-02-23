require 'rubygems'
require 'sinatra'
require 'json'
require './main.rb'

enable :sessions
set :session_secret, ENV['SESSION_KEY']
set :session_domain, ENV['DOMAIN'] || 'localhost'
set :session_expire, 86400
run Sinatra::Application