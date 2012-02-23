require 'rubygems'
require 'sinatra'
require 'json'
require './main.rb'

enable :sessions
set :session_secret, 'secret'
run Sinatra::Application