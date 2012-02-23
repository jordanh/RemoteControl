require 'rubygems'
require 'sinatra'
require 'json'
#require 'nokogiri'
require 'net/http'
require 'rexml/document'

####
#
#    function digiAuth
#    @params - none
#    handle Digi authentication failure
#
####

def digiAuth
	msg = "Digi does not recognize your credentials"
	redirect '/logIn?msg='+URI.escape(msg)
end

####
#
#    function digiRequest
#    @params - _uri: digi uri
#			 - _type: post or get
#            - _msg: empty for get; msg body for post
#    @return - Digi request response
#
####

def digiRequest (_uri,_type,_msg)
	uri = URI(_uri)
	req = ''
	if _type=='post'
		req = Net::HTTP::Post.new(uri.path)
		req.content_type = 'text/xml; charset=\"UTF-8\"'
		req.content_length = _msg.length
	elsif _type == 'get'
		req = Net::HTTP::Get.new(uri.request_uri)
	end
	
	req.basic_auth session[:user_name], session[:password]
	
	res = Net::HTTP.start(uri.host, uri.port) do |http|
  		http.request(req,_msg)
	end
	
	if res.code!='200'
		puts res.code, res.msg
		digiAuth()
	end
	return res.body

end

####
#
#    function assertXBee
#    @params - gateway_id, xbee_id
#    check that all XBee I/Os are configured
#	 @return - boolean OK
#
####

def assertXBee(gateway_id,xbee_id)
	uri = "http://developer.idigi.com/ws/sci"
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
	#xml = Nokogiri::XML(digiRequest(uri,'post',msg))
	xml = REXML::Document.new(digiRequest(uri,'post',msg))
	return xml

end

####
#
#    function getXBees
#    @params - gateway_id
#    get list of XBees for a gateway
#	 @return - array of XBee addresses
#
####


def getXBees (gateway_id)
	uri = "http://developer.idigi.com/ws/sci"
	msg = "<sci_request version='1.0'>
		  <send_message>
		    <targets>
		      <device id='"+gateway_id+"'/>
		    </targets>
		    <rci_request version='1.1'>
		    <do_command target='zigbee'><discover/></do_command>
		    </rci_request>
		  </send_message>
		</sci_request>"
			
	#xml = Nokogiri::XML(digiRequest(uri,'post',msg))
	xml = REXML::Document.new(digiRequest(uri,'post',msg))
	xbees = Array.new
	REXML::XPath.match(xml, '//device//ext_addr').each do |x|
		puts x
		xbees.push(x.text)
	end

	return xbees
end

####
#
#    function getGateways
#    @params - none
#    get list of gateways and associated XBees
#	 @return - Hash of gateway->XBee addresses
#
####

def getGateways
	uri = "http://developer.idigi.com/ws/DeviceCore/.json"
	json = JSON digiRequest(uri,'get','')
		
	gateways = Hash.new
	json['items'].each do |i| 
		gateways[i['devConnectwareId']] = getXBees(i['devConnectwareId'])
	end
	
	return gateways
end
