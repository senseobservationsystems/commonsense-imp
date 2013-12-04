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

device.on("initialise", function(impeeid){ // device tells me to start ...
    uuid <- impeeid; // store my impee id
    session_id <- GetSessionId(credentials); // store my session_id
    
    photoresistor_id <- CreateSensor("gl5528", "ldr", "photoresistor", "json", "\"{\\\"lux\\\":\\\"Integer\\\"}\"", uuid, session_id);
    
    server.log("uuid: "+uuid); // print my impeeid in the log
    server.log("session_id: "+session_id); // print my session_id
    server.log("photoresistor_id: "+photoresistor_id); // print my photoresistor_id
});
