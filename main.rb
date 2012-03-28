####
#
#    A Simple Remote Control web app for an XBee network
#    @author - Margaret McKenna
#
#    Functionality to log in with iDigi creditials, configure an XBee
#    for the Garage Door Remote, and open/close the garage door
#
#    Templating is via haml
#
#
#
####

module Main
class App < Sinatra::Base

	#Use SSL for all requests except for in development
	use Rack::SSL, :exclude => lambda { |env| env["SERVER_NAME"] == "localhost" || env["SERVER_NAME"] == "mlm-mbp.local"}
	
	use Rack::Session::Pool, :expire_after => 2592000, :key => 'rack.session', :secret => settings.session_secret  || 'session secret'	
	
	#/configuration is the default page
	not_found do
		redirect '/configuration'
	end
	
	get '/logIn' do
		@server = 'http://'+request.env['HTTP_HOST']
	    haml :logIn,  :locals => { :title => 'Log In: XBee Garage Door',:msg => params[:msg],:log_state => "Log In",:log_state_url => '/logIn' }
	end
	
	post '/logIn' do
		session[:user_name] = params[:user_name]
		session[:password] = params[:user_password]
		path = '/configuration'
		
		#the referring site is set by functions.js in the client and passed as a post param
		if params[:referrer]!=''
			path = CGI::unescape(params[:referrer])
		end
		redirect path
	end
	
	get '/configuration' do
		if session[:user_name]!=nil
			@server = 'http://'+request.env['HTTP_HOST']
		   	@gateway_ids = getGateways()
		    haml :index,  :locals => { :title => 'Configure: XBee Garage Door',:log_state => "Log Out",:log_state_url => '/logOut' }
		else
			redirect '/logIn?ref='+CGI::escape(request.fullpath)
		end
	end
	
	get '/configureXBee' do
		if session[:user_name]!=nil
			@xbee_response = configureXBee(params[:gateway_id],params[:xbee_id])
			return @xbee_response
		else
			redirect '/logIn'
		end
	end
	
	get '/garageApp' do
		if session[:user_name]!=nil
			@server = 'http://'+request.env['HTTP_HOST']
		    haml :garageApp,  :locals => { :title => 'XBee Garage Door',:log_state => "Log Out",:log_state_url => '/logOut' }
		else
			redirect '/logIn?ref='+CGI::escape(request.fullpath)
		end
	end
	
	get '/toggleXBee' do
		if session[:user_name]!=nil
			@msg = ''
			state_hash = { 'True'=>'open','False'=>'closed' }
			
			@xbee_state = getXBeeState(params[:gateway_id],params[:xbee_id])
			if state_hash[@xbee_state]==params[:state]
				@msg = "The garage door is already "+params[:state]+"."
				return @msg
			else
				toggleXBee(params[:gateway_id],params[:xbee_id])
				@msg = "Success"
				return @msg
			end
		else
			redirect '/logIn'
		end
	end
	
	get '/sensorState' do
		if session[:user_name]!=nil
			@msg = ''
			state_hash = { 'True'=>'open','False'=>'closed' }
			@xbee_state = getXBeeState(params[:gateway_id],params[:xbee_id])
			@msg = state_hash[@xbee_state]
			return @msg
		else
			redirect '/logIn'
		end
	end

	get '/logOut' do
		session.clear
		redirect '/login'
	end
	
end
end