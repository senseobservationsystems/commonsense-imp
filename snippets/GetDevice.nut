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

/* GetDeviceArray
p_session_id: a session id used to identify yourself

returns: An array containing the device objects or the response status code in case of failure.
*/
function GetDeviceArray(p_session_id){
    local get_request = http.get("http://api.sense-os.nl/devices", {"X-SESSION_ID" : p_session_id});
    
    local get_response = get_request.sendsync();
    
    return (200 == get_response.statuscode && "" != get_response.body) ? http.jsondecode(get_response.body).devices : get_response.statuscode;
}

/* Example */

local device_array = GetDeviceArray("1234567890abc0123.98765432");

server.log("Found the following devices:");
for(local i = 0; i < device_array.len();i++){
    server.log(device_array[i].type + " with id " + device_array[i].id);
}

/* GetDeviceId
p_uuid: the unique id to look for
p_device_array: the array containing device objects

returns: The device id belonging to p_uuid or null if it does not exist.
*/
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

