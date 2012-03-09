// After selecting a gateway id, update the associated list of XBees
// Gateway JSON object is stored in data attr of #data
function updateXBeeList(){
	var gateway_id = $('#gatewaySelect').val();		
	var json = JSON.parse($("#data").attr('data'));
	
	$("#xbeeSelect > .xbee").remove(); //clean up old xbee list
	
	for (var i=0; i<json[gateway_id].length; i++) {
		var xbee = json[gateway_id][i];
		$("#xbeeSelect").append("<option class='xbee' value='"+xbee+"'>"+xbee+"</option>");
	}
}

function configureXBee() {
	var params = {
		gateway_id: $('#gatewaySelect').val()
		, xbee_id: $('#xbeeSelect').val()
	}
	
	$.ajax({
		url: '/configureXBee'
		, data: params
		, success: function(response){
			console.log(response);
			$('.button').removeClass('selected').addClass('de-selected');
			$('.button').unbind('click');
			$('#control_panel').append("<div id='test'>Garage Door Opener Configured. Bookmark.</div>");
			var garage_url = "http://"+document.location.host+"/garageApp?gateway_id="+params.gateway_id+"&xbee_id="+params.xbee_id;
			$('#control_panel').append("<div id='test2'><a href='"+garage_url+"'</a>"+garage_url+"</div>");
		}
	
	});
}


function toggleSensor(state){	
	var params = {
		gateway_id: getParam('gateway_id')
		, xbee_id: getParam('xbee_id')
		, state: state
	}
	$.ajax({
		url: '/toggleXBee'
		, data: params
		, success: function(response){
			console.log(response);
		}
	
	});
}



function getParam(name){
	var result = "/";
	var params = window.location.href.split("?");
	if (params.length>0) {
		result = params[1].split(name+"=")[1].split("&")[0];
	}
	return result;
}
