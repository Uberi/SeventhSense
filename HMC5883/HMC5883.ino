/*
An Arduino code example for interfacing with the HMC5883

by: Jordan McConnell
 SparkFun Electronics
 created on: 6/30/11
 license: OSHW 1.0, http://freedomdefined.org/OSHW

Analog input 4 I2C SDA
Analog input 5 I2C SCL
*/

#include <Wire.h> //I2C Arduino Library

#define MAGNETOMETER_OVERFLOW (-4096)
#define TRIG_SCALE (long)10000
#define TAN_22_5 (long)4142 // TRIG_SCALE * tan(22.5 deg)
#define NORTH 1
#define NORTHEAST 2
#define EAST 3
#define SOUTHEAST 4
#define SOUTH 5
#define SOUTHWEST 6
#define WEST 7
#define NORTHWEST 8
#define NO_DIRECTION 0

static long axis_x, axis_y;
char get_direction(int x, int y, int z) {
    // handle overflow values
    if (x == MAGNETOMETER_OVERFLOW
     || y == MAGNETOMETER_OVERFLOW
     || z == MAGNETOMETER_OVERFLOW)
        return NO_DIRECTION; // unknown index

    axis_x = (long)x;
    axis_y = (long)y;
    
    // handle edge cases
    if (axis_x == 0 && axis_y == 0) // no angle
        return NO_DIRECTION;
    if (axis_x == 0)
        return y < 0 ? SOUTH : NORTH;
    if (axis_y == 0)
        return x < 0 ? WEST : EAST;

    // handle the cases in between the extremes
    if (axis_x > 0 && axis_y > 0) { // first quadrant
        if (axis_y * TRIG_SCALE < axis_x * TAN_22_5) // angle less than 22.5 degrees
            return EAST;
        if (axis_x * TRIG_SCALE < axis_y * TAN_22_5) // angle more than 90 - 22.5 degrees
            return NORTH;
        return NORTHEAST;
    }
    if (axis_x < 0 && axis_y > 0) { // second quadrant
        if (axis_y * TRIG_SCALE < -axis_x * TAN_22_5) // angle less than 90 + 22.5 degrees
            return WEST;
        if (-axis_x * TRIG_SCALE < axis_y * TAN_22_5) // angle more than 180 - 22.5 degrees
            return NORTH;
        return NORTHWEST;
    }
    if (axis_x < 0 && axis_y < 0) { // third quadrant
        if (-axis_y * TRIG_SCALE < -axis_x * TAN_22_5) // angle less than 180 + 22.5 degrees
            return WEST;
        if (-axis_x * TRIG_SCALE < -axis_y * TAN_22_5) // angle more than 270 - 22.5 degrees
            return SOUTH;
        return SOUTHWEST;
    }
    // fourth quadrant
    if (-axis_y * TRIG_SCALE < axis_x * TAN_22_5) // angle less than 270 + 22.5 degrees
        return EAST;
    if (axis_x * TRIG_SCALE < -axis_y * TAN_22_5) // angle more than 360 - 22.5 degrees
        return SOUTH;
    return SOUTHEAST;
}

#define address 0x1E //0011110b, I2C 7bit address of HMC5883

void setup(){
  //Initialize Serial and I2C communications
  Serial.begin(9600);
  Wire.begin();
  return;
  
  //Put the HMC5883 IC into the correct operating mode
  Wire.beginTransmission(address); //open communication with HMC5883
  Wire.write(0x02); //select mode register
  Wire.write(0x00); //continuous measurement mode
  Wire.endTransmission();
}

void loop(){
  
  int x,y,z; //triple axis data

  Serial.println("start");

  //Tell the HMC5883 where to begin reading data
  Wire.beginTransmission(address);
  Wire.write(0x03); //select register 3, X MSB register
  Wire.endTransmission();
  
 
 //Read data from each axis, 2 registers per axis
  Wire.requestFrom(address, 6);
  if(6<=Wire.available()){
    x = Wire.read()<<8; //X msb
    x |= Wire.read(); //X lsb
    z = Wire.read()<<8; //Z msb
    z |= Wire.read(); //Z lsb
    y = Wire.read()<<8; //Y msb
    y |= Wire.read(); //Y lsb
  }
  
  //Print out values of each axis
  Serial.print("x: ");
  Serial.print(x);
  Serial.print("  y: ");
  Serial.print(y);
  Serial.print("  z: ");
  Serial.print(z);
  Serial.print(" dir: ");
  Serial.print((int)get_direction(x, y, z));
  Serial.println();
  
  delay(250);
}
