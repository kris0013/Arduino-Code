// Sweep
// by BARRAGAN <http://barraganstudio.com> 
// This example code is in the public domain.


#include <Servo.h> 
 
Servo myservo;  // create servo object to control a servo 
                // a maximum of eight servo objects can be created 
int pos = 0;    // variable to store the servo position 

int outsideTemp = 0;
int insideTemp = 1;

// another change.

void setup() 
{ 
  myservo.attach(9);  // attaches the servo on pin 9 to the servo object 
   Serial.begin(9600);  
} 
 
 
void loop() 
{
 readOutsideTemp();
 readInsideTemp();
 compareTemps();
}


void readOutsideTemp () {
 float temperature1 = getVoltage(outsideTemp);  //getting the voltage reading from the temperature sensor
 temperature1 = (temperature1 - .5) * 100;          //converting from 10 mv per degree wit 500 mV offset
                                                  //to degrees ((volatge - 500mV) times 100)
Serial.print ("Outside Temperature:");
 Serial.println(temperature1);                       //printing the result
}

void readInsideTemp () {
  float temperature2 = getVoltage(insideTemp);  //getting the voltage reading from the temperature sensor
 temperature2 = (temperature2 - .5) * 100;          //converting from 10 mv per degree wit 500 mV offset
                                                  //to degrees ((volatge - 500mV) times 100)
  Serial.print ("Inside Temperature:");
 Serial.println(temperature2);                                                     
                                                  
         delay(5000);                                     //waiting 5 seconds
}

void compareTemps() {
 if (temperature2 > temperature1) {
   myservo.write (90);
 }
 else {
  myservo.write (0); 
 }
  
}

/*
 * getVoltage() - returns the voltage on the analog input defined by
 * pin
 */
float getVoltage(int pin){
 return (analogRead(pin) * .004882814); //converting from a 0 to 1024 digital range
                                        // to 0 to 5 volts (each 1 reading equals ~ 5 millivolts
}

