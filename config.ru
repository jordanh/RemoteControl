require 'rubygems'
require 'sinatra'
require 'cgi'
require 'json'
require 'warden'
require './main'
require './src/digiAPI'
 
run Main::App
