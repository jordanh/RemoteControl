function checkLogInStatus(){

}

function getGatewayList(){
	//$.ajax()
}


function getXbeeList(gateway_id){
	//$.ajax()
}

function getSensorState(gateway_id,xbee_id){
	//$.ajax()
	return state;
}


function toggleSensor(gateway_id,xbee_id,state){
	var state = getSensorState(gateway_id,xbee_id);
	state = !state;
	//$.ajax()
}