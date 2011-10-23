#include <Servo.h> 
//servo 
Servo myservo;  // create servo object to control a servo              
int pos = 0;    // variable to store the servo position 
int outsideTempPin = 0; // outside temp sensor in anolog pin 0
int insideTempPin = 1; // inside temp sensor in anolog pin 1
float outsideTemp = 0;
float insideTemp = 0;

//Window
float OperativeTemp = 24.5; // recommended crieteria for thermal comfort & ventilation rates for a category C single office in summer. 
float allowance = 2.5;
int windowState = 0;         //Boolean variable, 0 = open, 1 = closed
float avgSpeed = 0;


//wind cups
int inputPin = 8; //wind sensor pin
unsigned long time[5] = {
  0, 0, 0, 0, 0};
int lastButtonState = LOW;
float curSpeed = 0;


void setup() //merged setups: wind and servo
{ 
  myservo.attach(9);  // attaches the servo on pin 9 to the servo object 
   pinMode(inputPin, INPUT); //wind sensor to input
   Serial.begin(9600);  
} 


void loop () {
  readoutsideTempPin();
  readinsideTempPin();
  readWindSensor ();
  windowOpen ();
  servoAction ();
  
  
}

void readoutsideTempPin () {
 float outsideTemp = getVoltage(outsideTempPin);  //getting the voltage reading from the temperature sensor
 outsideTemp = (outsideTemp - .5) * 100;          //converting from 10 mv per degree wit 500 mV offset
                                                  //to degrees ((volatge - 500mV) times 100)
Serial.print ("Outside Temperature:");
 Serial.println(outsideTemp);                       //printing the result
}

void readinsideTempPin () {
  float insideTemp = getVoltage(insideTempPin);  //getting the voltage reading from the temperature sensor
 insideTemp = (insideTemp - .5) * 100;          //converting from 10 mv per degree wit 500 mV offset
                                                  //to degrees ((volatge - 500mV) times 100)
  Serial.print ("Inside Temperature:");
 Serial.println(insideTemp);                                                     
                                                  
}

void readWindSensor(){

  // test first to check button state
  int reading = digitalRead(inputPin);
  unsigned long curTime = millis();
  if (reading != lastButtonState) {
    if (reading == LOW) {
      unsigned long curTime = millis();
      for(int i=4; i>0; i--) {
        time[i] = time[(i-1)];
      }
      time[0] = curTime;
      curSpeed = getSpeed();
      Serial.print ("Wind Speed:");
      Serial.println(curSpeed);
    }
    lastButtonState = reading;
  }

}

void windowOpen() {

    if (curSpeed > 0.18) { // if air volcity is > 0.18
     windowState = 1;
   }
   if (curSpeed < 0.17) { // if air volcity is > 0.18
     windowState = 0;
   }
   if (outsideTemp > (OperativeTemp + allowance)) { // if outside temperature is above summer operative temperature plus allowance
     windowState = 1;
   }  
   if (outsideTemp < (OperativeTemp - allowance)) { // if outside temperature is below summer operative temperature minus allowance
     windowState = 1;
   }   
   if ((insideTemp > (OperativeTemp - allowance)) && (insideTemp < (OperativeTemp + allowance))) { // if inside temperature 
                                       //is above summer operative temp minus allowance & below summer operatve temp plus allowance
     windowState = 1;                    
     }
 
else  windowState = 0;
}


void servoAction() {
 if (windowState = 1) {
     Serial.println ("Window State = 1");
   myservo.write (120);
 }
 else {
  myservo.write (00); 
       Serial.println ("Window State = 0");
 }
}




float getVoltage(int pin){
 return (analogRead(pin) * .004882814); //converting from a 0 to 1024 digital range
                                        // to 0 to 5 volts (each 1 reading equals ~ 5 millivolts
}
float getSpeed() {
  float avgSpeed;
  avgSpeed = (time[0] - time[4]); //Difference in time b/w first and fifth rev.
  avgSpeed = (avgSpeed / 1000); //Convert to seconds
  avgSpeed = (.2 / avgSpeed); //Divide circumference in meters by second, gives m/s 
  return avgSpeed;
}  
