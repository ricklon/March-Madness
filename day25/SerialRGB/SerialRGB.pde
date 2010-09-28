/*
* Echo Serial on the Arduino
* with advice from Mark Sproul
*/
char str[10]; 

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
int minmax, rmax, gmax, bmax = 0;

char on = '-';
long interval = 500; 
long previousMillis = 0;


void setup() {
  Serial.begin(9600);
  Serial.println("Start");
  
  
  pinMode(redPin, OUTPUT);     
  pinMode(greenPin, OUTPUT);     
  pinMode(bluePin, OUTPUT);  
  digitalWrite(redPin, HIGH);
  digitalWrite(greenPin, HIGH);
  digitalWrite(bluePin, HIGH); 

  digitalWrite(redPin, LOW);
  delay(1000);
  rmax = analogRead(photoPin);
  digitalWrite(redPin, HIGH);

  digitalWrite(greenPin, LOW);
  delay(1000);
  gmax = analogRead(photoPin);
  digitalWrite(greenPin, HIGH);

  digitalWrite(bluePin, LOW);
  delay(1000);
  bmax = analogRead(photoPin);
  digitalWrite(bluePin, HIGH);
  
   sendMax(rmax, gmax, bmax);
   minmax = min(rmax, min(gmax, bmax));
  setRGB(100,100,100);
}

void setRGB(int red, int green, int blue) 
{
  red = map(red, 0, minmax, 0, 255);
  green = map(green, 0, minmax, 0, 255);
  blue = map(blue, 0, minmax, 0, 255);
  digitalWrite(redPin, red);
  digitalWrite(greenPin, green);
  digitalWrite(bluePin, blue);
}

void sendMax(int red, int green, int blue)
{

    Serial.print(" { \"rmax\" : ");
    Serial.print(rmax);
    Serial.print(", \"gmax\" : ");
    Serial.print(gmax);
    Serial.print(", \"bmax\" : ");
    Serial.print(bmax);
    
    Serial.println("}");
}

/*
int myAtoi(char* numstr) 
{
  int number;
  int ii;
  
  number = 0;
  ii = 0;
  while (numstr[ii]) 
  {
    number = number*10;
    number += numstr[ii] & 0x0f;
    ii++
  }
  return number;
}
*/


void loop() 
{
int ii = 0;
boolean keepgoing = true;


while (keepgoing) 
{
  Serial.println("{keepgoing}");
  while (Serial.available() ) 
    {
     {
      str[ii] = Serial.read();
      //Echo the character as you type
      //Serial.write(str[ii]);
      if (str[ii] == 0x0d )
      {
        keepgoing = false;
      }
      ii++;
      }
    }
    
} 
  str[ii] = 0;
  Serial.println();
  Serial.println(str);

}




