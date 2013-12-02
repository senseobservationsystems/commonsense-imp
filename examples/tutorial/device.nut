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
