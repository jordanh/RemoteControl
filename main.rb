require 'rubygems'
require 'net/http'
require 'sinatra'
require 'json'

configure do   

end

not_found do
	redirect to('/')
end

get '/' do
    @server = 'http://'+request.env['HTTP_HOST']
    haml :index,  :locals => { :title => 'XBee Remote Control' }
end

get '/logIn' do
	@server = 'http://'+request.env['HTTP_HOST']
    haml :logIn,  :locals => { :title => 'Log In: XBee Remote Control' }
end

get '/logOut' do
	@server = 'http://'+request.env['HTTP_HOST']
    haml :logOut,  :locals => { :title => 'Logged Out: XBee Remote Control' }
end

post '/getXbeeList' do

end

post '/getSensorState' do

end

post '/setSensorState' do

end