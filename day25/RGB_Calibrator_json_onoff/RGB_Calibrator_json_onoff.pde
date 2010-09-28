/*
* The RGB Calibrator
* 
* Find, and monitor max brightness of red, green, and blue in an RGB led
*/


int redPin = 9;    // LED connected to digital pin 9
int greenPin = 11;
int bluePin = 10;
int pins[] = 
{
    redPin, greenPin, bluePin
};
int i =0;

int photoPin = 0;
int potPin = 1;

int photoVal = -1;
int r,g,b = -1;
int rmax, gmax, bmax = 0;
int rmin, gmin, bmin = 1024;
char on = '-';
long interval = 500; 
long previousMillis = 0;

void setup()  
{ 
  Serial.begin(9600);
 // Serial.println("Setup done");
  
  pinMode(redPin, OUTPUT);     
  pinMode(greenPin, OUTPUT);     
  pinMode(bluePin, OUTPUT);  
  digitalWrite(redPin, HIGH);
  digitalWrite(greenPin, HIGH);
  digitalWrite(bluePin, HIGH); 

  digitalWrite(redPin, LOW);
  delay(1000);
  digitalWrite(redPin, HIGH);

  digitalWrite(greenPin, LOW);
  delay(1000);
  digitalWrite(greenPin, HIGH);

  digitalWrite(bluePin, LOW);
  delay(1000);
  digitalWrite(bluePin, HIGH);
  
} 


void loop()  
{
  if (i > 2) //The number of LEDS being measured
  {
     i = 0; 
  }
  if (Serial.available()) {
    on = Serial.read();
  } 
  
  if (on == '!' ) {
    digitalWrite(pins[i], LOW);     
    photoVal = analogRead(photoPin);
  
  
    switch (i)
    {
     case 0: //red led
       r = photoVal;
       rmin = min(rmin, r);
       rmax = max(rmax, r);
       break;
     case 1: //green led
       g = photoVal;
       gmin = min(gmin, g);
       gmax = max(gmax, g);
       break;
     case 2: //blue led
       b = photoVal;
       bmin = min(bmin, b);
       bmax = max(bmax, b);
      break;
     default: //should not happen
       break;
      
    }
    Serial.print ("{ \"entry\" :");
    Serial.print(" { \"photoVal\" : ");
    Serial.print(photoVal);
    
    Serial.print(", \"rmax\" : ");
    Serial.print(rmax);
    Serial.print(", \"gmax\" : ");
    Serial.print(gmax);
    Serial.print(", \"bmax\" : ");
    Serial.print(bmax);
    
    Serial.print(", \"rmin\" : ");
    Serial.print(rmin);
    Serial.print(", \"gmin\" : ");
    Serial.print(gmin);
    Serial.print(", \"bmin\" : ");
    Serial.print(bmin);
    
    Serial.print(", \"r\" : ");
    Serial.print(r);
    Serial.print(", \"g\" : ");
    Serial.print(g);
    Serial.print(", \"b\" : ");
    Serial.print(b);
    Serial.println("}}");
    
    if (millis() - previousMillis > interval) {
      previousMillis = millis();   
      digitalWrite(pins[i], HIGH);
      i++;    
     }
  }
  else 
  {	
    digitalWrite(pins[i], HIGH);
  }
 }



