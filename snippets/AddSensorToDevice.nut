/* Copyright (©) 2013 Sense Observation Systems B.V.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * Author: Miguel Lo-A-Foe (miguel@sense-os.nl)
 */

/* addSensorToDevice
p_sensor_id: id of the sensor to be added to device p_uuid
p_uuid: unique id of this imp
p_session_id: api session id

returns: status code from api or a curl error message if it's between 0 and 99
*/
function AddSensorToDevice(p_sensor_id, p_uuid, p_session_id){
    local device_body = {};
    device_body.device <- {};
    device_body.device.uuid <- p_uuid;
    device_body.device.type <- "Electric Imp";
    
    local device_request = http.post("http://api.sense-os.nl/sensors/"+p_sensor_id+"/device", {"X-SESSION_ID" : p_session_id, "Content-Type": "application/json"}, http.jsonencode(device_body));
    
    local device_response = device_request.sendsync();
    	
    return device_response.statuscode;
}

/* Example */

local statuscode = AddSensorToDevice(123456, 123a4b5cdef4ghij, 1234567890abc0123.98765432);

if(statuscode == 201){
	server.log("Sensor successfully added to device!");
}else{
	server.log("Something went wrong! error: "+statuscode);
}

