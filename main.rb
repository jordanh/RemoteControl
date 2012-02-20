require 'rubygems'
require 'sinatra'
require 'json'
require 'net/http'

enable :sessions

def digiAuth
	msg = "Digi does not recognize your credentials"
	redirect '/logIn?msg='+URI.escape(msg)
end


def digiRequest (_uri,_type,_msg)
	uri = URI(_uri)
	req = ''
	if _type=='post'
		req = Net::HTTP::Post.new(uri.path)
		req.content_type = 'text/xml; charset=\"UTF-8\"'
		req.body(_msg)
	elsif _type == 'get'
		req = Net::HTTP::Get.new(uri.request_uri)
	end

	res = Net::HTTP.start(uri.hostname, uri.port) do |http|
  		http.request(req)
	end
	
	if res.code!='200'
		digiAuth()
	end
		
	json = JSON res.body
	return json

end

def assertXBee(gateway_id,xbee_id)
	uri = URI("http://developer.idigi.com/ws/sci/.json")
	msg = '<sci_request version="1.0">
			  <send_message>
			    <targets>
			      <device id="'+gateway_id+'"/>
			    </targets>
			    <rci_request version="1.1">
			      <do_command target="xig">
			        <at hw_address="'+xbee_id+'" command="D0" value="1" />      
			        <at hw_address="'+xbee_id+'" command="D1" value="4" />
			        <at hw_address="'+xbee_id+'" command="D2" value="4" />      
			        <at hw_address="'+xbee_id+'" command="D3" value="3" />
			        <at hw_address="'+xbee_id+'" command="D4" value="3" />
			        <at hw_address="'+xbee_id+'" command="IR" value="30000" />
			        <at hw_address="'+xbee_id+'" command="IC" value="0x000C" />
			        <at hw_address="'+xbee_id+'" command="WR" apply="True" />
			      </do_command>
			    </rci_request>
			  </send_message>
			</sci_request>'
	json = JSON digiRequest(uri,'post',msg)
	puts json
	return json

end

def getXBees (gateway_id)
	puts gateway_id
	msg = "<?xml version='1.0' encoding='UTF-8'?><sci_request version='1.0'>
		  <send_message>
		    <targets>
		      <device id='"+gateway_id+"'/>
		    </targets>
		    <rci_request version='1.1'>
		    <do_command target='zigbee'><discover/></do_command>
		    </rci_request>
		  </send_message>
		</sci_request>"
	uri = URI("http://developer.idigi.com/ws/sci/.json")		
	
	json = JSON digiRequest(uri,'post',msg)
	puts json
	return json
end

def getGateways
	uri = URI('http://developer.idigi.com/ws/DeviceCore/.json')
	json = JSON digiRequest(uri,'get')
		
	gateway_ids = Array.new
	json['items'].each do |i| 
		gateway_ids.push(i['devConnectwareId'])
		getXBees(i['devConnectwareId'])
	end
	puts gateway_ids.length
	return gateway_ids
end



configure do
	def auth (type)
  		condition do
    		redirect "/logIn" unless send("is_#{type}?")
  		end
	end		
end

before do
	def is_user?
		puts "before"
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
	redirect '/'
end

get '/', :auth => :user do
	@server = 'http://'+request.env['HTTP_HOST']
   	#@gateway_ids = getGateways()
   	@gateway_ids = Array.new
    #puts "gateways"
    haml :index,  :locals => { :title => 'XBee Remote Control',:log_state => "Log Out",:log_state_url => '/logOut' }
end

get '/logOut' do
	session[:user_name] = nil
	@server = 'http://'+request.env['HTTP_HOST']
    haml :logOut,  :locals => { :title => 'Logged Out: XBee Remote Control',:log_state => "Log In",:log_state_url => '/logIn' }
end