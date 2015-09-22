#line 1 "C:/Users/Anthony/Dropbox/Projects/SeventhSense/SeventhSense Controller/Controller.c"
#line 45 "C:/Users/Anthony/Dropbox/Projects/SeventhSense/SeventhSense Controller/Controller.c"
int magnetic_x = 0;
int magnetic_y = 0;
int magnetic_z = 0;

void init_magnetometer() {
 TRISB = 0x00;
 PORTB = 0x00;

 I2C1_Init(100000);

 I2C1_Start();
 I2C1_Wr( 0x3C );
 I2C1_Wr(0x00);
 I2C1_Wr(0b01110000);
 I2C1_Stop();
}





void init_timer1() {
 T1CON = 0x31;
 TMR1IF_bit = 0;
 TMR1H = 0x48;
 TMR1L = 0xE5;
 TMR1IE_bit = 1;
 INTCON = 0xC0;
}

void main() {
 CM1CON0 = CM2CON0 = 0b111;
 ANSEL = ANSELH = 0;
 IDLEN_bit = 1;

 TRISC = 0x00;
  RC7_bit  =  RC6_bit  =  RC3_bit  =  RC4_bit  =  RC5_bit  =  RC2_bit  = 0;


 PORTC = 0xFF;

 asm sleep;
}

void get_magnetometer(int *x, int *y, int *z) {

 I2C1_Start();
 I2C1_Wr( 0x3C );
 I2C1_Wr(0x02);
 I2C1_Wr(0b00000001);
 I2C1_Stop();

 delay_ms(150);


 I2C1_Start();
 I2C1_Wr( 0x3D );
 *x = (I2C1_Rd(1) << 8) | I2C1_Rd(1);
 *z = (I2C1_Rd(1) << 8) | I2C1_Rd(1);
 *y = (I2C1_Rd(1) << 8) | I2C1_Rd(0);
 I2C1_Stop();
}

void notify(int index) {
 switch (index) {
 case 1:  RC7_bit  = 1; break;
 case 2:  RC6_bit  = 1; break;
 case 3:  RC3_bit  = 1; break;
 case 4:  RC4_bit  = 1; break;
 case 5:  RC5_bit  = 1; break;
 case 6:  RC2_bit  = 1; break;
 case 7:  RC1_bit  = 1; break;
 case 8:  RC0_bit  = 1; break;
 }
 delay_ms(200);
 switch (index) {
 case 1:  RC7_bit  = 0; break;
 case 2:  RC6_bit  = 0; break;
 case 3:  RC3_bit  = 0; break;
 case 4:  RC4_bit  = 0; break;
 case 5:  RC5_bit  = 0; break;
 case 6:  RC2_bit  = 0; break;
 case 7:  RC1_bit  = 0; break;
 case 8:  RC0_bit  = 0; break;
 }
}

static long axis_x, axis_y;
char get_direction(int x, int y, int z) {

 if (x ==  (-4096) 
 || y ==  (-4096) 
 || z ==  (-4096) )
 return  0 ;

 axis_x = (long)x;
 axis_y = (long)y;


 if (axis_x == 0 && axis_y == 0)
 return  0 ;
 if (axis_x == 0)
 return y < 0 ?  5  :  1 ;
 if (axis_y == 0)
 return x < 0 ?  7  :  3 ;


 if (axis_x > 0 && axis_y > 0) {
 if (axis_y *  (long)10000  < axis_x *  (long)4142 )
 return  3 ;
 if (axis_x *  (long)10000  < axis_y *  (long)4142 )
 return  1 ;
 return  2 ;
 }
 if (axis_x < 0 && axis_y > 0) {
 if (axis_y *  (long)10000  < -axis_x *  (long)4142 )
 return  7 ;
 if (-axis_x *  (long)10000  < axis_y *  (long)4142 )
 return  1 ;
 return  8 ;
 }
 if (axis_x < 0 && axis_y < 0) {
 if (-axis_y *  (long)10000  < -axis_x *  (long)4142 )
 return  7 ;
 if (-axis_x *  (long)10000  < -axis_y *  (long)4142 )
 return  5 ;
 return  6 ;
 }

 if (-axis_y *  (long)10000  < axis_x *  (long)4142 )
 return  3 ;
 if (axis_x *  (long)10000  < -axis_y *  (long)4142 )
 return  5 ;
 return  4 ;
}

static char magnetometer_uninitialized = 1;
void interrupt(){
 if (TMR1IF_bit){

 TMR1IF_bit = 0;
 TMR1H = 0x48;
 TMR1L = 0xE5;

 if (magnetometer_uninitialized) {
 init_magnetometer();
 magnetometer_uninitialized = 0;
 }
 else {
 get_magnetometer(&magnetic_x, &magnetic_y, &magnetic_z);
 notify(get_direction(magnetic_x, magnetic_y, magnetic_z));
 }
 }
}
