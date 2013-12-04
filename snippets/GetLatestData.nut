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

