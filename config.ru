require 'rubygems'
require 'sinatra'
require 'json'
require 'nokogiri'
require './main.rb'

use Rack::Session::Cookie
run Sinatra::Application