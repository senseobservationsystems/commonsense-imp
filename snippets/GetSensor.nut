/* GetSensorArray
p_device_id: the device id to retrieve sensors from
p_session_id: a session id used to identify yourself

returns: an array containing the sensors or the response code from commonsense
*/

function GetSensorArray(p_device_id, p_session_id){
    local get_request = http.get("http://api.sense-os.nl/devices/"+p_device_id+"/sensors", {"X-SESSION_ID" : p_session_id});
    
    local get_response = get_request.sendsync();
    
    return (200 == get_response.statuscode && "" != get_response.body) ? http.jsondecode(get_response.body).sensors : get_response.statuscode;
}

/* Example */

local sensor_array = GetSensorArray(654321, "1234567890abc0123.98765432");

server.log("device 654321 contains the following sensors:");
for(local i = 0; i < sensor_array.len();i++){
    server.log(sensor_array[i].name + " with id " + sensor_array[i].id);
}

/* GetSensorId
p_name: a name used to identify the sensor
p_display_name: name displayed in the dashboard (optional)
p_device_type: description of the device
p_data_type: type of the data e.g. int, string, json
p_data_structure: string containing the json data structure, required when using json
p_sensor_array: the array the look through

returns: a sensor id which has all these parameters or null if there is no sensor with these parameters
*/

function GetSensorId(p_name, p_display_name, p_device_type, p_data_type, p_data_structure, p_sensor_array){
    for(local i = 0; i < p_sensor_array.len(); i++){
        if((p_sensor_array[i].name != p_name) || (p_sensor_array[i].device_type != p_device_type) || (p_sensor_array[i].data_type != p_data_type) || (p_sensor_array[i].data_structure != p_data_structure)){
                    continue;
        }else if(("" == p_sensor_array[i].display_name) && (null != p_display_name)){
                    continue;
        }
        return p_sensor_array[i].id;
    }
    return null;
}

/* Example */

local sensor_array = GetSensorArray(654321, "1234567890abc0123.98765432");
local sensor_id = GetSensorId("gl5528", "ldr", "photoresistor", "json", "\"{\\\"lux\\\":\\\"Integer\\\"}\"", sensor_array);

if(sensor_id != null){
    server.log("A sensor with these attributes already exists! its sensor id is: " + sensor_id);
}else{
    server.log("No such sensor exists, create one!");
}

