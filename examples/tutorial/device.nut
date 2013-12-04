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

agent.send("initialise", hardware.getimpeeid()); // tell the agent to get started

photoresistor <- hardware.pin1;
photoresistor.configure(ANALOG_IN);

photoresistor_value <- 0;

led <- hardware.pin9;
led.configure(PWM_OUT, 1.0/200, 0)

function ReadPR(){
    photoresistor_value = photoresistor.read();
    
    led.write(1 - (photoresistor_value.tofloat()/math.pow(2,16)));
    
    imp.wakeup(0.001, ReadPR);
}

function UploadData(){
    agent.send("upload", photoresistor_value);
    
    imp.wakeup(5, UploadData); // wakeup in 10 seconds to do the same thing again
}

ReadPR();
UploadData();
