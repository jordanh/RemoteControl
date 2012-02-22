####
#
#    A Simple RemoteControl web app for an XBee network
#    @author - Margaret McKenna
#
####

require 'rubygems'
require 'sinatra'
require 'json'
require 'net/http'
require './src/digiAPI'

configure do
	## Handle authencation
	puts "SESSION",session
	def auth (type)
  		condition do
    		redirect "/logIn" unless send("is_#{type}?")
  		end
	end		
end

before do
	def is_user?
      	session[:user_name] != nil
    end    
end

get '/logIn' do
	@server = 'http://'+request.env['HTTP_HOST']
    haml :logIn,  :locals => { :title => 'Log In: XBee Remote Control',:msg => params[:msg],:log_state => "Log In",:log_state_url => '/logIn' }
end

post '/logIn' do
	session[:user_name] = params[:user_name]
	session[:password] = params[:user_password]
	puts "SESSION",session
	redirect '/'
end

get '/', :auth => :user do
	@server = 'http://'+request.env['HTTP_HOST']
   	@gateway_ids = getGateways()
    haml :index,  :locals => { :title => 'XBee Remote Control',:log_state => "Log Out",:log_state_url => '/logOut' }
end

get '/logOut' do
	session[:user_name] = nil
	@server = 'http://'+request.env['HTTP_HOST']
    haml :logOut,  :locals => { :title => 'Logged Out: XBee Remote Control',:log_state => "Log In",:log_state_url => '/logIn' }
end