int redPin = 9;    // LED connected to digital pin 9
int greenPin = 11;
int bluePin = 10;
int pins[] = 
{
    redPin, greenPin, bluePin
};

int photoPin = 0;
int redPot = 1;
int greenPot = 2;
int bluePot = 3;

int photoVal = -1;
int rr, gg, bb = -1;
int minmax, rmax, gmax, bmax = 0;

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
  delay(500);
  rmax = analogRead(photoPin);
  digitalWrite(redPin, HIGH);

  digitalWrite(greenPin, LOW);
  delay(500);
  gmax = analogRead(photoPin);
  digitalWrite(greenPin, HIGH);

  digitalWrite(bluePin, LOW);
  delay(500);
  bmax = analogRead(photoPin);
  digitalWrite(bluePin, HIGH);
  
   sendMax();
   minmax = min(rmax, min(gmax, bmax));
   setRGB(255, 255, 255);
}

void setRGB(int red, int green, int blue) 
{
  red = map(red, 0, minmax, 255, 0);
  green = map(green, 0, minmax,  255, 0);
  blue = map(blue, 0, minmax,  255, 0);
  
  //For some reason some values were mapping negative
  constrain(red, 0, 255);
  constrain(green, 0, 255);
  constrain(blue, 0, 255);
  
  analogWrite(redPin, red);
  analogWrite(greenPin, green);
  analogWrite(bluePin, blue);
  sendRGB(red, green, blue);
}

void sendRGB(int red, int green, int blue) 
{
      Serial.print(" { \"red\" : ");
      Serial.print(red);
      Serial.print(", \"green\" : ");
      Serial.print(green);
      Serial.print(", \"blue\" : ");
      Serial.print(blue);
      Serial.println("}");
}

void sendMax()
{

    Serial.print(" { \"rmax\" : ");
    Serial.print(rmax);
    Serial.print(", \"gmax\" : ");
    Serial.print(gmax);
    Serial.print(", \"bmax\" : ");
    Serial.print(bmax);
    Serial.println("}");
}



void loop() 
{
  rr = analogRead(redPot);
  gg = analogRead(greenPot);
  bb = analogRead(bluePot);
  setRGB(rr, gg, bb);
  //(rr, gg, bb);

  
}
