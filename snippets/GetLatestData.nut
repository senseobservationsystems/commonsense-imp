/* GetLatestData()
p_sensor_id: id of the sensor to retrieve data of
p_session_id: a session id used to identify yourself

returns: A table containing the decoded json response.
*/

function GetLatestData(p_sensor_id, p_session_id){
    local data_request = http.get("http://api.sense-os.nl/sensors/"+p_sensor_id+"/data?last=true", {"X-SESSION_ID" : p_session_id, "Content-Type": "application/json"});
    
    local data_response = data_request.sendsync();
    
    return (200 == data_response.statuscode) ? http.jsondecode(data_response.body).data[0] : data_response.statuscode;
}

/* Example */

local latest_data = GetLatestData(, "1234567890abc0123.98765432");
local state = "unknown";

if(latest_data.value == 0){
	state = "off"
}else if(latest_data.value == 1){
	state = "on"
}

server.log("state of led: " + state);

