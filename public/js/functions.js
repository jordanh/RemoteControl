function updateXBeeList(){
	var gateway_id = $('#gatewaySelect').val();		
	var json = JSON.parse($("#data").attr('data'));
	
	$("#xbeeSelect > .xbee").remove(); //clean up old xbee list
	
	for (var i=0; i<json[gateway_id].length; i++) {
		var xbee = json[gateway_id][i];
		$("#xbeeSelect").append("<option class='xbee' value='"+xbee+"'>"+xbee+"</option>");
	}
}


function toggleSensor(){
	var gateway_id = $('#gatewaySelect').val();	
	var xbee_id = $('#xbeeSelect').val();	
	//var state = getSensorState(gateway_id,xbee_id);
	//state = !state;
	//$.ajax()
}



