require 'rubygems'
require 'sinatra'
require 'cgi'
require 'json'
require 'rack/ssl'
require './main'
require './src/digiAPI'
 
run Main::App
