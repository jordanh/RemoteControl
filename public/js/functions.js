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
	//$('#controlPanel').append("div id='test'>Querying…</div>");
	var params = {
		gateway_id: $('#gatewaySelect').val()
		, xbee_id: $('#xbeeSelect').val()
	}
	
	$.ajax({
		url: '/configureXBee'
		, data: params
		, success: function(response){
			//$('#test').remove();
			$('#button').removeClass('selected').addClass('de-selected');
			$('#controlPanel').append("div id='test'>Garage Door Opener Configured. Bookmark.</div>");
			alert("success");
		}
	
	});
}


function toggleSensor(){
	var gateway_id = $('#gatewaySelect').val();	
	var xbee_id = $('#xbeeSelect').val();	
	//var state = getSensorState(gateway_id,xbee_id);
	//state = !state;
	//$.ajax()
}



function getReferrer() {
	return document.referrer;
}