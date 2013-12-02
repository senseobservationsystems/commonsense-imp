credentials <- {}; // create a table containing our credentials

credentials.username <- "user";
credentials.password <- "5f4dcc3b5aa765d61d8327deb882cf99";

device.on("initialise", function(impeeid){ // device tells me to start ...
    uuid <- impeeid; // store my impee id
    session_id <- GetSessionId(credentials); // store my session_id
    
    photoresistor_id <- CreateSensor("gl5528", "ldr", "photoresistor", "json", "\"{\\\"lux\\\":\\\"Integer\\\"}\"", uuid, session_id);
    
    server.log("uuid: "+uuid); // print my impeeid in the log
    server.log("session_id: "+session_id); // print my session_id
    server.log("photoresistor_id: "+photoresistor_id); // print my photoresistor_id
});

device.on("upload", function(value){
    local data = {}; // create a table 
    data.lux <- value; // put the value from the sensor as value for the sensor
    
    UploadData(data, photoresistor_id, session_id); // upload the data to the right sensor
    server.log("uploaded data.");
});

/*
	Read the wiki for documentation of the functions below.
	https://github.com/senseobservationsystems/commonsense-imp/wiki
*/

function GetSessionId(p_credentials){
    local post_request = http.post("http://api.sense-os.nl/login", {"Content-Type": "application/json"}, http.jsonencode(p_credentials));
    
    local post_response = post_request.sendsync();
    
    return (200 == post_response.statuscode) ? http.jsondecode(post_response.body).session_id : post_response.statuscode;
}

function GetDeviceArray(p_session_id){
    local get_request = http.get("http://api.sense-os.nl/devices", {"X-SESSION_ID" : p_session_id});
    
    local get_response = get_request.sendsync();
    
    return (200 == get_response.statuscode && "" != get_response.body) ? http.jsondecode(get_response.body).devices : get_response.statuscode;
}

function GetDeviceId(p_uuid, p_device_array){
    for(local i = 0; i < p_device_array.len(); i++){
           if(p_device_array[i].uuid == p_uuid){
                return p_device_array[i].id;
            }else{
                continue;
            }
    }
    return null;
}

function GetSensorArray(p_device_id, p_session_id){
    local get_request = http.get("http://api.sense-os.nl/devices/"+p_device_id+"/sensors", {"X-SESSION_ID" : p_session_id});
    
    local get_response = get_request.sendsync();
    
    return (200 == get_response.statuscode && "" != get_response.body) ? http.jsondecode(get_response.body).sensors : get_response.statuscode;
}

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

function AddSensorToDevice(p_sensor_id, p_uuid, p_session_id){
    local device_body = {};
    device_body.device <- {};
    device_body.device.uuid <- p_uuid;
    device_body.device.type <- "Electric Imp";
    
    local device_request = http.post("http://api.sense-os.nl/sensors/"+p_sensor_id+"/device", {"X-SESSION_ID" : p_session_id, "Content-Type": "application/json"}, http.jsonencode(device_body));
    
    local device_response = device_request.sendsync();
    
    return device_response.statuscode;
}

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

function UploadData(p_json_data, p_sensor_id, p_session_id){
    local body = {};
    body.data <- [];
    p_json_data.date <- time();
    
    body.data.push(p_json_data);
    
    local upload_request = http.post("http://api.sense-os.nl/sensors/"+p_sensor_id+"/data", {"X-SESSION_ID" : p_session_id, "Content-Type": "application/json"}, http.jsonencode(body));
    
    local upload_response = upload_request.sendsync();
    
    return upload_response.statuscode;
}

function GetLatestData(p_sensor_id, p_session_id){
    local data_request = http.get("http://api.sense-os.nl/sensors/"+p_sensor_id+"/data?last=true", {"X-SESSION_ID" : p_session_id, "Content-Type": "application/json"});
    
    local data_response = data_request.sendsync();
    
    return (200 == data_response.statuscode) ? http.jsondecode(data_response.body).data[0] : data_response.statuscode;
}
