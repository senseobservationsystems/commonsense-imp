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

/* UploadData
p_json_data: the data (such as a table) to be encoded
p_sensor_id: id of the sensor to upload data to
p_session_id: a session id used to identify yourself

returns: The response status code or a curl error message if the value is between 0 and 99.
*/
function UploadData(p_json_data, p_sensor_id, p_session_id){
    local body = {};
    body.data <- [];
    p_json_data.date <- time();
    
    body.data.push(p_json_data);
    
    local upload_request = http.post("http://api.sense-os.nl/sensors/"+p_sensor_id+"/data", {"X-SESSION_ID" : p_session_id, "Content-Type": "application/json"}, http.jsonencode(body));
    
    local upload_response = upload_request.sendsync();
    
    return upload_response.statuscode;
}

/* Example */

// UploadData() adds the current timestamp to the data e.g. {"data":[{value: 1, date: 1385990413}]}

local data = {};
data.value <- 1; // led is on

UploadData(data, 123456, "1234567890abc0123.98765432");

