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
	
	$('.mm-thumbnail').toggle(); //UI ajax indicator
	$('.alert').remove(); //clean up old messages
	
	$.ajax({
		url: '/configureXBee'
		, data: params
		, success: function(response){	
			$('.mm-thumbnail').toggle(); //clean up ajax indicator

			var garage_url = "http://"+document.location.host+"/garageApp?gateway_id="+params.gateway_id+"&xbee_id="+params.xbee_id;
			$('#configure').append("<div class='alert alert-success'><h4 class='alert-heading'>Garage Door Remote Configured</h4> Drag link to add it to your bookmarks toolbar. <a href='"+garage_url+"'>Garage App</a></div>");
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
	
	$("#garage-thumbnail").toggle();
	$("#garage_wrapper").addClass("dimmed");
	
	$.ajax({
		url: '/toggleXBee'
		, data: params
		, success: function(response){
			if (response.match("<")){
				document.write(response); //hack for when you attempt to use an xbee that is not attached to your name
			} else {
				$("#garage-thumbnail").toggle();				
				$('#current_state').append("<div class='message alert alert-info'>"+response+"</div>");
				$("#garage_wrapper").removeClass("dimmed");
				$('.message').fadeOut(4000);
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
				var old_class = 'closed';
				if (response=='closed') {
					old_class = 'open';
				}
				$('#garage_wrapper').removeClass('garage_'+old_class).addClass('garage_'+response);
				$('#current_state_text').text("The garage door is "+response+".");
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
	if (params.length>1 & params[1].match(name)!=null) { 
		result = params[1].split(name+"=")[1].split("&")[0];
	}
	return result;
}


