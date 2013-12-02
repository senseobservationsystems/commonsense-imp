device.on("initialise", function(impeeid){ // device tells me to start ...
    uuid <- impeeid; // store my impee id
    session_id <- GetSessionId(credentials); // store my session_id
    
    photoresistor_id <- CreateSensor("gl5528", "ldr", "photoresistor", "json", "\"{\\\"lux\\\":\\\"Integer\\\"}\"", uuid, session_id);
    
    server.log("uuid: "+uuid); // print my impeeid in the log
    server.log("session_id: "+session_id); // print my session_id
    server.log("photoresistor_id: "+photoresistor_id); // print my photoresistor_id
});
