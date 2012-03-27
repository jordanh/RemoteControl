require 'rubygems'
require 'sinatra'
require 'cgi'
require 'json'
require 'rack/ssl'
require './main'
require './src/digiAPI'

disable :sessions
disable :flash
set :session_secret, ENV['SESSION_KEY']

run Main::App
