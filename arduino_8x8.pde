const int data = 9;    
const int clock = 7;
char incByte = 0;
String phrase = "";

void setup() {
  pinMode(data, OUTPUT);  
  pinMode(clock, OUTPUT);

  Serial.begin(9600);  
  Serial.println("Arduino UNO 8x8 LED Sign Controller v1.0");
}

void clockit() {
   digitalWrite(clock, HIGH);
   digitalWrite(clock, LOW); 
}

void staticImage(int index) {
     if (index == 0) {
          /* OOOO OOOO
             0011 1100
             0010 0100
             0010 0100
             0010 0100
             0010 0100
             0011 1100
             0000 0000 */
          pushNewImage("0000000000111100001001000010010000100100001001000011110000000000");
     }
}

void printPrettyImage(String LEDdata) {
     for (int i = 0; i <= 63; i++) {
          if (char(LEDdata[i]) == '1') {
               Serial.print("1"); 
          } else {
               Serial.print("0"); 
          }
          
          if (((i + 1) % 8) == 0) {
               Serial.print("\n");
          } else {
               Serial.print(" "); 
          }
     } 
}

void pushNewImage(String LEDdata) {
     printPrettyImage(LEDdata);
  
     for (int i = 0; i <= 63; i++) {
          if (char(LEDdata[i]) == '1') {
               digitalWrite(data, HIGH);     
          } else { 
               digitalWrite(data, LOW);
          }
          clockit();
     }
}

//IO function regarding the SISO
String serialControl(int force) {
     String input = "";
     char incByte = 0;
     
     //When force = 1, the serial connection will constatly be checked for new data
     //When force = 0, the serial connection will be checked only once
     do {
          if (Serial.available()) {
               Serial.print("Echo: "); 
          }
          while (Serial.available()) {
               incByte = Serial.read();
               input += incByte;
               Serial.write(incByte);
    
               delay(1);
    
               if (!Serial.available()) {
                    Serial.print("\n"); 
                    force = 0;
               }
          }
     } while(force);
     return(input);
}

void loop() {
     if (Serial.available()) { 
          phrase = serialControl(0);
     }  
  
     if (phrase == "ni") {
          Serial.println("New Image?"); 
          
          phrase = serialControl(1);
          pushNewImage(phrase);
          phrase = "";
     } else if (phrase == "stat") {
          Serial.println("Static Image?");
         
          staticImage(0);
          phrase = ""; 
     }
}
