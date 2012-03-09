/**
 * A Simple Remote Control web app for an XBee network
 * This script requires jQuery.
 *
 * @author Margaret McKenna - mlmckenna.com
 *
*/


/*
	updateXBeeList function
	@params - none
	@return - none
	
	After selecting a gateway id, update the associated list of XBees
	Gateway JSON object is stored in data attr of #data
*/

function updateXBeeList(){
	var gateway_id = $('#gatewaySelect').val();		
	var json = JSON.parse($("#data").attr('data'));
	
	$("#xbeeSelect > .xbee").remove(); //clean up old xbee list
	
	for (var i=0; i<json[gateway_id].length; i++) {
		var xbee = json[gateway_id][i];
		$("#xbeeSelect").append("<option class='xbee' value='"+xbee+"'>"+xbee+"</option>");
	}
}

/*
	configureXBee function
	@params - none
	@return - none
	
	Ajax request to configure XBee for garage door opener
*/

function configureXBee() {
	var params = {
		gateway_id: $('#gatewaySelect').val(),
		xbee_id: $('#xbeeSelect').val()
	}
	
	$('#configure_img').toggle(); //UI ajax indicator
	$('.message').remove(); //clean up old messages
	
	$.ajax({
		url: '/configureXBee'
		, data: params
		, success: function(response){	
			//TO DO: check response?
					
			$('#configure_img').toggle(); //clean up ajax indicator
			
			//Do we want to turn off configure functionality? Or might people want to configure more than one at a time?
			//$('.button').removeClass('selected').addClass('de-selected'); 
			//$('.button').unbind('click');
			
			var garage_url = "http://"+document.location.host+"/garageApp?gateway_id="+params.gateway_id+"&xbee_id="+params.xbee_id;
			$('#control_panel').append("<div class='message'>Garage Door Opener Configured. Drag link to add it to your bookmarks toolbar. <a href='"+garage_url+"'>Garage App</a></div>");
		}
	});
}

/*
	toggleSensor function
  	@params - state : string, "open" or "closed"
  	@return - message from server, or bad credentials page
 
  	Ajax request to check state of sensor; if state != state of sensor, toggle sensor
*/

function toggleSensor(state){	
	var params = {
		 gateway_id: getParam('gateway_id'),
		 xbee_id: getParam('xbee_id'),
		 state: state
	}
	
	$("#"+state+"_img").toggle(); //UI ajax indicator
	$('.message').remove(); //clean up old messages
	
	$.ajax({
		url: '/toggleXBee'
		, data: params
		, success: function(response){
			if (response.match("<")){
				document.write(response); //hack for when you attempt to use an xbee that is not attached to your name
			} else {
				$("#"+state+"_img").toggle(); //clean up ajax indicator
				$('#control_panel').append("<div class='message'>"+response+"</div>");
			}
		}
	});
}


function getSensorState() {
	
	var params = {
		 gateway_id: getParam('gateway_id'),
		 xbee_id: getParam('xbee_id')
	}
		
	$.ajax({
		url: '/sensorState'
		, data: params
		, success: function(response){
			if (response.match("<")){
				document.write(response); //hack for when you attempt to use an xbee that is not attached to your name
			} else {
				$('#current_state_text').text(response);
			}
		}
	});

}


/*
	getParam function
	@params - name : string, key in url parameters
	@return - value of key; if key does not exist, return "/"
	
	Used to pass values on LogIn page and Garage App page
*/

function getParam(name){
	var result = "/";
	var params = window.location.href.split("?");
	if (params.length>1) {
		result = params[1].split(name+"=")[1].split("&")[0];
	}
	return result;
}
