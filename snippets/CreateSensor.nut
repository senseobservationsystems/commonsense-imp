/*This function requires the following other library functions:
- GetDeviceArray  
- GetDeviceId  
- GetSensorArray  
- GetSensorId  
- AddSensorToDevice
*/

/* CreateSensor
p_name: a name used to identify the sensor
p_display_name: name displayed in the dashboard (optional)
p_device_type: description of the device
p_data_type: type of the data e.g. int, string, json
p_data_structure: string containing the json data structure, required when using json
p_uuid: unique id of the imp to add this sensor to
p_session_id: a session id used to identify yourself

returns: The id of the created sensor or the return status code in case of failure.
*/

function CreateSensor(p_name, p_display_name, p_device_type, p_data_type, p_data_structure, p_uuid, p_session_id){
    local device_array;
    local device_id;
    local sensor_array;
    local sensor_id;
    
    device_array = GetDeviceArray(p_session_id);
    
    if(200 != device_array){
        device_id = GetDeviceId(p_uuid, device_array);
        
        if(null != device_id){
            sensor_array = GetSensorArray(device_id, p_session_id);
            
            if(200 != sensor_array)
                sensor_id = GetSensorId(p_name, p_display_name, p_device_type, p_data_type, p_data_structure, sensor_array);
                
                if(null != sensor_id)
                    return sensor_id;
        }
        
    }
    
    local sensor_body = {};
    sensor_body.sensor <- {};
    sensor_body.sensor.name <- p_name;
    sensor_body.sensor.display_name <- p_display_name;
    sensor_body.sensor.device_type <- p_device_type;
    sensor_body.sensor.data_type <- p_data_type;
    if("json" == sensor_body.sensor.data_type)
        sensor_body.sensor.data_structure <- p_data_structure;
    
    local sensor_request = http.post("http://api.sense-os.nl/sensors", {"X-SESSION_ID" : p_session_id, "Content-Type": "application/json"}, http.jsonencode(sensor_body));
    
    local sensor_response = sensor_request.sendsync();
    if(201 != sensor_response.statuscode){
        server.log("Sensor creation failed! status: "+sensor_response.statuscode);
        return sensor_response.statuscode;
    }

    sensor_id = http.jsondecode(sensor_response.body).sensor.id;

    local sensor_added_status = AddSensorToDevice(sensor_id, p_uuid, p_session_id);
    
    return (201 == sensor_added_status) ? sensor_id : sensor_added_status;
}

/* Example */

local photoresistor_id = CreateSensor("gl5528", "ldr", "photoresistor", "json", "\"{\\\"lux\\\":\\\"Integer\\\"}\"", uuid, session_id);

server.log("photoresistor_id: " + photoresistor_id);

