
_init_magnetometer:

;Controller.c,49 :: 		void init_magnetometer() {
;Controller.c,50 :: 		TRISB = 0x00; // PORTB as output (required for I2C to work)
	CLRF        TRISB+0 
;Controller.c,51 :: 		PORTB = 0x00; // initialize PORTB to 0 for I2C
	CLRF        PORTB+0 
;Controller.c,53 :: 		I2C1_Init(100000); // start the I2C communication channel in standard mode (100 kbps)
	MOVLW       2
	MOVWF       SSPADD+0 
	CALL        _I2C1_Init+0, 0
;Controller.c,55 :: 		I2C1_Start();
	CALL        _I2C1_Start+0, 0
;Controller.c,56 :: 		I2C1_Wr(MAGNETOMETER_WRITE); // write to magnetometer
	MOVLW       60
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;Controller.c,57 :: 		I2C1_Wr(0x00); // write to configuration A register
	CLRF        FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;Controller.c,58 :: 		I2C1_Wr(0b01110000); // average 8 samples
	MOVLW       112
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;Controller.c,59 :: 		I2C1_Stop();
	CALL        _I2C1_Stop+0, 0
;Controller.c,60 :: 		}
L_end_init_magnetometer:
	RETURN      0
; end of _init_magnetometer

_init_timer1:

;Controller.c,66 :: 		void init_timer1() {
;Controller.c,67 :: 		T1CON = 0x31;
	MOVLW       49
	MOVWF       T1CON+0 
;Controller.c,68 :: 		TMR1IF_bit = 0;
	BCF         TMR1IF_bit+0, BitPos(TMR1IF_bit+0) 
;Controller.c,69 :: 		TMR1H = 0x48;
	MOVLW       72
	MOVWF       TMR1H+0 
;Controller.c,70 :: 		TMR1L = 0xE5;
	MOVLW       229
	MOVWF       TMR1L+0 
;Controller.c,71 :: 		TMR1IE_bit = 1;
	BSF         TMR1IE_bit+0, BitPos(TMR1IE_bit+0) 
;Controller.c,72 :: 		INTCON = 0xC0;
	MOVLW       192
	MOVWF       INTCON+0 
;Controller.c,73 :: 		}
L_end_init_timer1:
	RETURN      0
; end of _init_timer1

_main:

;Controller.c,75 :: 		void main() {
;Controller.c,76 :: 		CM1CON0 = CM2CON0 = 0b111; // comparator configuration
	MOVLW       7
	MOVWF       CM2CON0+0 
	MOVF        CM2CON0+0, 0 
	MOVWF       CM1CON0+0 
;Controller.c,77 :: 		ANSEL = ANSELH = 0; // use digital I/O
	CLRF        ANSELH+0 
	CLRF        ANSEL+0 
;Controller.c,78 :: 		IDLEN_bit = 1; // enable Idle mode when sleeping (timer1 only works in normal and idle mode)
	BSF         IDLEN_bit+0, BitPos(IDLEN_bit+0) 
;Controller.c,80 :: 		TRISC = 0x00; // PORTC as output
	CLRF        TRISC+0 
;Controller.c,81 :: 		MOTOR1 = MOTOR2 = MOTOR3 = MOTOR4 = MOTOR5 = MOTOR6 = 0; // reset port state
	BCF         RC2_bit+0, BitPos(RC2_bit+0) 
	BTFSC       RC2_bit+0, BitPos(RC2_bit+0) 
	GOTO        L__main62
	BCF         RC5_bit+0, BitPos(RC5_bit+0) 
	GOTO        L__main63
L__main62:
	BSF         RC5_bit+0, BitPos(RC5_bit+0) 
L__main63:
	BTFSC       RC5_bit+0, BitPos(RC5_bit+0) 
	GOTO        L__main64
	BCF         RC4_bit+0, BitPos(RC4_bit+0) 
	GOTO        L__main65
L__main64:
	BSF         RC4_bit+0, BitPos(RC4_bit+0) 
L__main65:
	BTFSC       RC4_bit+0, BitPos(RC4_bit+0) 
	GOTO        L__main66
	BCF         RC3_bit+0, BitPos(RC3_bit+0) 
	GOTO        L__main67
L__main66:
	BSF         RC3_bit+0, BitPos(RC3_bit+0) 
L__main67:
	BTFSC       RC3_bit+0, BitPos(RC3_bit+0) 
	GOTO        L__main68
	BCF         RC6_bit+0, BitPos(RC6_bit+0) 
	GOTO        L__main69
L__main68:
	BSF         RC6_bit+0, BitPos(RC6_bit+0) 
L__main69:
	BTFSC       RC6_bit+0, BitPos(RC6_bit+0) 
	GOTO        L__main70
	BCF         RC7_bit+0, BitPos(RC7_bit+0) 
	GOTO        L__main71
L__main70:
	BSF         RC7_bit+0, BitPos(RC7_bit+0) 
L__main71:
;Controller.c,84 :: 		PORTC = 0xFF;
	MOVLW       255
	MOVWF       PORTC+0 
;Controller.c,86 :: 		asm sleep; // go into idle mode, later to be woken up by timer1
	SLEEP
;Controller.c,87 :: 		}
L_end_main:
	GOTO        $+0
; end of _main

_get_magnetometer:

;Controller.c,89 :: 		void get_magnetometer(int *x, int *y, int *z) {
;Controller.c,91 :: 		I2C1_Start();
	CALL        _I2C1_Start+0, 0
;Controller.c,92 :: 		I2C1_Wr(MAGNETOMETER_WRITE); // write to magnetometer
	MOVLW       60
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;Controller.c,93 :: 		I2C1_Wr(0x02); // write to mode register
	MOVLW       2
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;Controller.c,94 :: 		I2C1_Wr(0b00000001); // single measurement mode
	MOVLW       1
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;Controller.c,95 :: 		I2C1_Stop();
	CALL        _I2C1_Stop+0, 0
;Controller.c,97 :: 		delay_ms(150); // wait for the magnetometer to make a reading
	MOVLW       49
	MOVWF       R12, 0
	MOVLW       178
	MOVWF       R13, 0
L_get_magnetometer0:
	DECFSZ      R13, 1, 1
	BRA         L_get_magnetometer0
	DECFSZ      R12, 1, 1
	BRA         L_get_magnetometer0
	NOP
;Controller.c,100 :: 		I2C1_Start();
	CALL        _I2C1_Start+0, 0
;Controller.c,101 :: 		I2C1_Wr(MAGNETOMETER_READ); // read from magnetometer
	MOVLW       61
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;Controller.c,102 :: 		*x = (I2C1_Rd(1) << 8) | I2C1_Rd(1);
	MOVLW       1
	MOVWF       FARG_I2C1_Rd_ack+0 
	CALL        _I2C1_Rd+0, 0
	MOVF        R0, 0 
	MOVWF       FLOC__get_magnetometer+1 
	CLRF        FLOC__get_magnetometer+0 
	MOVLW       1
	MOVWF       FARG_I2C1_Rd_ack+0 
	CALL        _I2C1_Rd+0, 0
	MOVLW       0
	MOVWF       R1 
	MOVF        FLOC__get_magnetometer+0, 0 
	IORWF       R0, 1 
	MOVF        FLOC__get_magnetometer+1, 0 
	IORWF       R1, 1 
	MOVFF       FARG_get_magnetometer_x+0, FSR1
	MOVFF       FARG_get_magnetometer_x+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
	MOVF        R1, 0 
	MOVWF       POSTINC1+0 
;Controller.c,103 :: 		*z = (I2C1_Rd(1) << 8) | I2C1_Rd(1);
	MOVLW       1
	MOVWF       FARG_I2C1_Rd_ack+0 
	CALL        _I2C1_Rd+0, 0
	MOVF        R0, 0 
	MOVWF       FLOC__get_magnetometer+1 
	CLRF        FLOC__get_magnetometer+0 
	MOVLW       1
	MOVWF       FARG_I2C1_Rd_ack+0 
	CALL        _I2C1_Rd+0, 0
	MOVLW       0
	MOVWF       R1 
	MOVF        FLOC__get_magnetometer+0, 0 
	IORWF       R0, 1 
	MOVF        FLOC__get_magnetometer+1, 0 
	IORWF       R1, 1 
	MOVFF       FARG_get_magnetometer_z+0, FSR1
	MOVFF       FARG_get_magnetometer_z+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
	MOVF        R1, 0 
	MOVWF       POSTINC1+0 
;Controller.c,104 :: 		*y = (I2C1_Rd(1) << 8) | I2C1_Rd(0); // we always NACK the last value to indicate that we are done reading
	MOVLW       1
	MOVWF       FARG_I2C1_Rd_ack+0 
	CALL        _I2C1_Rd+0, 0
	MOVF        R0, 0 
	MOVWF       FLOC__get_magnetometer+1 
	CLRF        FLOC__get_magnetometer+0 
	CLRF        FARG_I2C1_Rd_ack+0 
	CALL        _I2C1_Rd+0, 0
	MOVLW       0
	MOVWF       R1 
	MOVF        FLOC__get_magnetometer+0, 0 
	IORWF       R0, 1 
	MOVF        FLOC__get_magnetometer+1, 0 
	IORWF       R1, 1 
	MOVFF       FARG_get_magnetometer_y+0, FSR1
	MOVFF       FARG_get_magnetometer_y+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
	MOVF        R1, 0 
	MOVWF       POSTINC1+0 
;Controller.c,105 :: 		I2C1_Stop();
	CALL        _I2C1_Stop+0, 0
;Controller.c,106 :: 		}
L_end_get_magnetometer:
	RETURN      0
; end of _get_magnetometer

_notify:

;Controller.c,108 :: 		void notify(int index) {
;Controller.c,109 :: 		switch (index) {
	GOTO        L_notify1
;Controller.c,110 :: 		case 1: MOTOR1 = 1; break;
L_notify3:
	BSF         RC7_bit+0, BitPos(RC7_bit+0) 
	GOTO        L_notify2
;Controller.c,111 :: 		case 2: MOTOR2 = 1; break;
L_notify4:
	BSF         RC6_bit+0, BitPos(RC6_bit+0) 
	GOTO        L_notify2
;Controller.c,112 :: 		case 3: MOTOR3 = 1; break;
L_notify5:
	BSF         RC3_bit+0, BitPos(RC3_bit+0) 
	GOTO        L_notify2
;Controller.c,113 :: 		case 4: MOTOR4 = 1; break;
L_notify6:
	BSF         RC4_bit+0, BitPos(RC4_bit+0) 
	GOTO        L_notify2
;Controller.c,114 :: 		case 5: MOTOR5 = 1; break;
L_notify7:
	BSF         RC5_bit+0, BitPos(RC5_bit+0) 
	GOTO        L_notify2
;Controller.c,115 :: 		case 6: MOTOR6 = 1; break;
L_notify8:
	BSF         RC2_bit+0, BitPos(RC2_bit+0) 
	GOTO        L_notify2
;Controller.c,116 :: 		case 7: MOTOR7 = 1; break;
L_notify9:
	BSF         RC1_bit+0, BitPos(RC1_bit+0) 
	GOTO        L_notify2
;Controller.c,117 :: 		case 8: MOTOR8 = 1; break;
L_notify10:
	BSF         RC0_bit+0, BitPos(RC0_bit+0) 
	GOTO        L_notify2
;Controller.c,118 :: 		}
L_notify1:
	MOVLW       0
	XORWF       FARG_notify_index+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__notify74
	MOVLW       1
	XORWF       FARG_notify_index+0, 0 
L__notify74:
	BTFSC       STATUS+0, 2 
	GOTO        L_notify3
	MOVLW       0
	XORWF       FARG_notify_index+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__notify75
	MOVLW       2
	XORWF       FARG_notify_index+0, 0 
L__notify75:
	BTFSC       STATUS+0, 2 
	GOTO        L_notify4
	MOVLW       0
	XORWF       FARG_notify_index+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__notify76
	MOVLW       3
	XORWF       FARG_notify_index+0, 0 
L__notify76:
	BTFSC       STATUS+0, 2 
	GOTO        L_notify5
	MOVLW       0
	XORWF       FARG_notify_index+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__notify77
	MOVLW       4
	XORWF       FARG_notify_index+0, 0 
L__notify77:
	BTFSC       STATUS+0, 2 
	GOTO        L_notify6
	MOVLW       0
	XORWF       FARG_notify_index+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__notify78
	MOVLW       5
	XORWF       FARG_notify_index+0, 0 
L__notify78:
	BTFSC       STATUS+0, 2 
	GOTO        L_notify7
	MOVLW       0
	XORWF       FARG_notify_index+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__notify79
	MOVLW       6
	XORWF       FARG_notify_index+0, 0 
L__notify79:
	BTFSC       STATUS+0, 2 
	GOTO        L_notify8
	MOVLW       0
	XORWF       FARG_notify_index+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__notify80
	MOVLW       7
	XORWF       FARG_notify_index+0, 0 
L__notify80:
	BTFSC       STATUS+0, 2 
	GOTO        L_notify9
	MOVLW       0
	XORWF       FARG_notify_index+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__notify81
	MOVLW       8
	XORWF       FARG_notify_index+0, 0 
L__notify81:
	BTFSC       STATUS+0, 2 
	GOTO        L_notify10
L_notify2:
;Controller.c,119 :: 		delay_ms(200);
	MOVLW       65
	MOVWF       R12, 0
	MOVLW       238
	MOVWF       R13, 0
L_notify11:
	DECFSZ      R13, 1, 1
	BRA         L_notify11
	DECFSZ      R12, 1, 1
	BRA         L_notify11
	NOP
;Controller.c,120 :: 		switch (index) {
	GOTO        L_notify12
;Controller.c,121 :: 		case 1: MOTOR1 = 0; break;
L_notify14:
	BCF         RC7_bit+0, BitPos(RC7_bit+0) 
	GOTO        L_notify13
;Controller.c,122 :: 		case 2: MOTOR2 = 0; break;
L_notify15:
	BCF         RC6_bit+0, BitPos(RC6_bit+0) 
	GOTO        L_notify13
;Controller.c,123 :: 		case 3: MOTOR3 = 0; break;
L_notify16:
	BCF         RC3_bit+0, BitPos(RC3_bit+0) 
	GOTO        L_notify13
;Controller.c,124 :: 		case 4: MOTOR4 = 0; break;
L_notify17:
	BCF         RC4_bit+0, BitPos(RC4_bit+0) 
	GOTO        L_notify13
;Controller.c,125 :: 		case 5: MOTOR5 = 0; break;
L_notify18:
	BCF         RC5_bit+0, BitPos(RC5_bit+0) 
	GOTO        L_notify13
;Controller.c,126 :: 		case 6: MOTOR6 = 0; break;
L_notify19:
	BCF         RC2_bit+0, BitPos(RC2_bit+0) 
	GOTO        L_notify13
;Controller.c,127 :: 		case 7: MOTOR7 = 0; break;
L_notify20:
	BCF         RC1_bit+0, BitPos(RC1_bit+0) 
	GOTO        L_notify13
;Controller.c,128 :: 		case 8: MOTOR8 = 0; break;
L_notify21:
	BCF         RC0_bit+0, BitPos(RC0_bit+0) 
	GOTO        L_notify13
;Controller.c,129 :: 		}
L_notify12:
	MOVLW       0
	XORWF       FARG_notify_index+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__notify82
	MOVLW       1
	XORWF       FARG_notify_index+0, 0 
L__notify82:
	BTFSC       STATUS+0, 2 
	GOTO        L_notify14
	MOVLW       0
	XORWF       FARG_notify_index+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__notify83
	MOVLW       2
	XORWF       FARG_notify_index+0, 0 
L__notify83:
	BTFSC       STATUS+0, 2 
	GOTO        L_notify15
	MOVLW       0
	XORWF       FARG_notify_index+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__notify84
	MOVLW       3
	XORWF       FARG_notify_index+0, 0 
L__notify84:
	BTFSC       STATUS+0, 2 
	GOTO        L_notify16
	MOVLW       0
	XORWF       FARG_notify_index+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__notify85
	MOVLW       4
	XORWF       FARG_notify_index+0, 0 
L__notify85:
	BTFSC       STATUS+0, 2 
	GOTO        L_notify17
	MOVLW       0
	XORWF       FARG_notify_index+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__notify86
	MOVLW       5
	XORWF       FARG_notify_index+0, 0 
L__notify86:
	BTFSC       STATUS+0, 2 
	GOTO        L_notify18
	MOVLW       0
	XORWF       FARG_notify_index+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__notify87
	MOVLW       6
	XORWF       FARG_notify_index+0, 0 
L__notify87:
	BTFSC       STATUS+0, 2 
	GOTO        L_notify19
	MOVLW       0
	XORWF       FARG_notify_index+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__notify88
	MOVLW       7
	XORWF       FARG_notify_index+0, 0 
L__notify88:
	BTFSC       STATUS+0, 2 
	GOTO        L_notify20
	MOVLW       0
	XORWF       FARG_notify_index+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__notify89
	MOVLW       8
	XORWF       FARG_notify_index+0, 0 
L__notify89:
	BTFSC       STATUS+0, 2 
	GOTO        L_notify21
L_notify13:
;Controller.c,130 :: 		}
L_end_notify:
	RETURN      0
; end of _notify

_get_direction:

;Controller.c,133 :: 		char get_direction(int x, int y, int z) {
;Controller.c,136 :: 		|| y == MAGNETOMETER_OVERFLOW
	MOVF        FARG_get_direction_x+1, 0 
	XORLW       240
	BTFSS       STATUS+0, 2 
	GOTO        L__get_direction91
	MOVLW       0
	XORWF       FARG_get_direction_x+0, 0 
L__get_direction91:
	BTFSC       STATUS+0, 2 
	GOTO        L__get_direction58
	MOVF        FARG_get_direction_y+1, 0 
	XORLW       240
	BTFSS       STATUS+0, 2 
	GOTO        L__get_direction92
	MOVLW       0
	XORWF       FARG_get_direction_y+0, 0 
L__get_direction92:
	BTFSC       STATUS+0, 2 
	GOTO        L__get_direction58
;Controller.c,137 :: 		|| z == MAGNETOMETER_OVERFLOW)
	MOVF        FARG_get_direction_z+1, 0 
	XORLW       240
	BTFSS       STATUS+0, 2 
	GOTO        L__get_direction93
	MOVLW       0
	XORWF       FARG_get_direction_z+0, 0 
L__get_direction93:
	BTFSC       STATUS+0, 2 
	GOTO        L__get_direction58
	GOTO        L_get_direction24
L__get_direction58:
;Controller.c,138 :: 		return NO_DIRECTION; // unknown index
	CLRF        R0 
	GOTO        L_end_get_direction
L_get_direction24:
;Controller.c,140 :: 		axis_x = (long)x;
	MOVF        FARG_get_direction_x+0, 0 
	MOVWF       R1 
	MOVF        FARG_get_direction_x+1, 0 
	MOVWF       R2 
	MOVLW       0
	BTFSC       FARG_get_direction_x+1, 7 
	MOVLW       255
	MOVWF       R3 
	MOVWF       R4 
	MOVF        R1, 0 
	MOVWF       Controller_axis_x+0 
	MOVF        R2, 0 
	MOVWF       Controller_axis_x+1 
	MOVF        R3, 0 
	MOVWF       Controller_axis_x+2 
	MOVF        R4, 0 
	MOVWF       Controller_axis_x+3 
;Controller.c,141 :: 		axis_y = (long)y;
	MOVF        FARG_get_direction_y+0, 0 
	MOVWF       Controller_axis_y+0 
	MOVF        FARG_get_direction_y+1, 0 
	MOVWF       Controller_axis_y+1 
	MOVLW       0
	BTFSC       FARG_get_direction_y+1, 7 
	MOVLW       255
	MOVWF       Controller_axis_y+2 
	MOVWF       Controller_axis_y+3 
;Controller.c,144 :: 		if (axis_x == 0 && axis_y == 0) // no angle
	MOVLW       0
	MOVWF       R0 
	XORWF       R4, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__get_direction94
	MOVF        R0, 0 
	XORWF       R3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__get_direction94
	MOVF        R0, 0 
	XORWF       R2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__get_direction94
	MOVF        R1, 0 
	XORLW       0
L__get_direction94:
	BTFSS       STATUS+0, 2 
	GOTO        L_get_direction27
	MOVLW       0
	MOVWF       R0 
	XORWF       Controller_axis_y+3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__get_direction95
	MOVF        R0, 0 
	XORWF       Controller_axis_y+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__get_direction95
	MOVF        R0, 0 
	XORWF       Controller_axis_y+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__get_direction95
	MOVF        Controller_axis_y+0, 0 
	XORLW       0
L__get_direction95:
	BTFSS       STATUS+0, 2 
	GOTO        L_get_direction27
L__get_direction57:
;Controller.c,145 :: 		return NO_DIRECTION;
	CLRF        R0 
	GOTO        L_end_get_direction
L_get_direction27:
;Controller.c,146 :: 		if (axis_x == 0)
	MOVLW       0
	MOVWF       R0 
	XORWF       Controller_axis_x+3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__get_direction96
	MOVF        R0, 0 
	XORWF       Controller_axis_x+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__get_direction96
	MOVF        R0, 0 
	XORWF       Controller_axis_x+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__get_direction96
	MOVF        Controller_axis_x+0, 0 
	XORLW       0
L__get_direction96:
	BTFSS       STATUS+0, 2 
	GOTO        L_get_direction28
;Controller.c,147 :: 		return y < 0 ? SOUTH : NORTH;
	MOVLW       128
	XORWF       FARG_get_direction_y+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__get_direction97
	MOVLW       0
	SUBWF       FARG_get_direction_y+0, 0 
L__get_direction97:
	BTFSC       STATUS+0, 0 
	GOTO        L_get_direction29
	MOVLW       5
	MOVWF       R0 
	GOTO        L_get_direction30
L_get_direction29:
	MOVLW       1
	MOVWF       R0 
L_get_direction30:
	GOTO        L_end_get_direction
L_get_direction28:
;Controller.c,148 :: 		if (axis_y == 0)
	MOVLW       0
	MOVWF       R0 
	XORWF       Controller_axis_y+3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__get_direction98
	MOVF        R0, 0 
	XORWF       Controller_axis_y+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__get_direction98
	MOVF        R0, 0 
	XORWF       Controller_axis_y+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__get_direction98
	MOVF        Controller_axis_y+0, 0 
	XORLW       0
L__get_direction98:
	BTFSS       STATUS+0, 2 
	GOTO        L_get_direction31
;Controller.c,149 :: 		return x < 0 ? WEST : EAST;
	MOVLW       128
	XORWF       FARG_get_direction_x+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__get_direction99
	MOVLW       0
	SUBWF       FARG_get_direction_x+0, 0 
L__get_direction99:
	BTFSC       STATUS+0, 0 
	GOTO        L_get_direction32
	MOVLW       7
	MOVWF       R0 
	GOTO        L_get_direction33
L_get_direction32:
	MOVLW       3
	MOVWF       R0 
L_get_direction33:
	GOTO        L_end_get_direction
L_get_direction31:
;Controller.c,152 :: 		if (axis_x > 0 && axis_y > 0) { // first quadrant
	MOVLW       128
	MOVWF       R0 
	MOVLW       128
	XORWF       Controller_axis_x+3, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__get_direction100
	MOVF        Controller_axis_x+2, 0 
	SUBLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L__get_direction100
	MOVF        Controller_axis_x+1, 0 
	SUBLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L__get_direction100
	MOVF        Controller_axis_x+0, 0 
	SUBLW       0
L__get_direction100:
	BTFSC       STATUS+0, 0 
	GOTO        L_get_direction36
	MOVLW       128
	MOVWF       R0 
	MOVLW       128
	XORWF       Controller_axis_y+3, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__get_direction101
	MOVF        Controller_axis_y+2, 0 
	SUBLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L__get_direction101
	MOVF        Controller_axis_y+1, 0 
	SUBLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L__get_direction101
	MOVF        Controller_axis_y+0, 0 
	SUBLW       0
L__get_direction101:
	BTFSC       STATUS+0, 0 
	GOTO        L_get_direction36
L__get_direction56:
;Controller.c,153 :: 		if (axis_y * TRIG_SCALE < axis_x * TAN_22_5) // angle less than 22.5 degrees
	MOVF        Controller_axis_y+0, 0 
	MOVWF       R0 
	MOVF        Controller_axis_y+1, 0 
	MOVWF       R1 
	MOVF        Controller_axis_y+2, 0 
	MOVWF       R2 
	MOVF        Controller_axis_y+3, 0 
	MOVWF       R3 
	MOVLW       16
	MOVWF       R4 
	MOVLW       39
	MOVWF       R5 
	MOVLW       0
	MOVWF       R6 
	MOVLW       0
	MOVWF       R7 
	CALL        _Mul_32x32_U+0, 0
	MOVF        R0, 0 
	MOVWF       FLOC__get_direction+0 
	MOVF        R1, 0 
	MOVWF       FLOC__get_direction+1 
	MOVF        R2, 0 
	MOVWF       FLOC__get_direction+2 
	MOVF        R3, 0 
	MOVWF       FLOC__get_direction+3 
	MOVF        Controller_axis_x+0, 0 
	MOVWF       R0 
	MOVF        Controller_axis_x+1, 0 
	MOVWF       R1 
	MOVF        Controller_axis_x+2, 0 
	MOVWF       R2 
	MOVF        Controller_axis_x+3, 0 
	MOVWF       R3 
	MOVLW       46
	MOVWF       R4 
	MOVLW       16
	MOVWF       R5 
	MOVLW       0
	MOVWF       R6 
	MOVLW       0
	MOVWF       R7 
	CALL        _Mul_32x32_U+0, 0
	MOVLW       128
	XORWF       FLOC__get_direction+3, 0 
	MOVWF       R4 
	MOVLW       128
	XORWF       R3, 0 
	SUBWF       R4, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__get_direction102
	MOVF        R2, 0 
	SUBWF       FLOC__get_direction+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__get_direction102
	MOVF        R1, 0 
	SUBWF       FLOC__get_direction+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__get_direction102
	MOVF        R0, 0 
	SUBWF       FLOC__get_direction+0, 0 
L__get_direction102:
	BTFSC       STATUS+0, 0 
	GOTO        L_get_direction37
;Controller.c,154 :: 		return EAST;
	MOVLW       3
	MOVWF       R0 
	GOTO        L_end_get_direction
L_get_direction37:
;Controller.c,155 :: 		if (axis_x * TRIG_SCALE < axis_y * TAN_22_5) // angle more than 90 - 22.5 degrees
	MOVF        Controller_axis_x+0, 0 
	MOVWF       R0 
	MOVF        Controller_axis_x+1, 0 
	MOVWF       R1 
	MOVF        Controller_axis_x+2, 0 
	MOVWF       R2 
	MOVF        Controller_axis_x+3, 0 
	MOVWF       R3 
	MOVLW       16
	MOVWF       R4 
	MOVLW       39
	MOVWF       R5 
	MOVLW       0
	MOVWF       R6 
	MOVLW       0
	MOVWF       R7 
	CALL        _Mul_32x32_U+0, 0
	MOVF        R0, 0 
	MOVWF       FLOC__get_direction+0 
	MOVF        R1, 0 
	MOVWF       FLOC__get_direction+1 
	MOVF        R2, 0 
	MOVWF       FLOC__get_direction+2 
	MOVF        R3, 0 
	MOVWF       FLOC__get_direction+3 
	MOVF        Controller_axis_y+0, 0 
	MOVWF       R0 
	MOVF        Controller_axis_y+1, 0 
	MOVWF       R1 
	MOVF        Controller_axis_y+2, 0 
	MOVWF       R2 
	MOVF        Controller_axis_y+3, 0 
	MOVWF       R3 
	MOVLW       46
	MOVWF       R4 
	MOVLW       16
	MOVWF       R5 
	MOVLW       0
	MOVWF       R6 
	MOVLW       0
	MOVWF       R7 
	CALL        _Mul_32x32_U+0, 0
	MOVLW       128
	XORWF       FLOC__get_direction+3, 0 
	MOVWF       R4 
	MOVLW       128
	XORWF       R3, 0 
	SUBWF       R4, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__get_direction103
	MOVF        R2, 0 
	SUBWF       FLOC__get_direction+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__get_direction103
	MOVF        R1, 0 
	SUBWF       FLOC__get_direction+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__get_direction103
	MOVF        R0, 0 
	SUBWF       FLOC__get_direction+0, 0 
L__get_direction103:
	BTFSC       STATUS+0, 0 
	GOTO        L_get_direction38
;Controller.c,156 :: 		return NORTH;
	MOVLW       1
	MOVWF       R0 
	GOTO        L_end_get_direction
L_get_direction38:
;Controller.c,157 :: 		return NORTHEAST;
	MOVLW       2
	MOVWF       R0 
	GOTO        L_end_get_direction
;Controller.c,158 :: 		}
L_get_direction36:
;Controller.c,159 :: 		if (axis_x < 0 && axis_y > 0) { // second quadrant
	MOVLW       128
	XORWF       Controller_axis_x+3, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__get_direction104
	MOVLW       0
	SUBWF       Controller_axis_x+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__get_direction104
	MOVLW       0
	SUBWF       Controller_axis_x+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__get_direction104
	MOVLW       0
	SUBWF       Controller_axis_x+0, 0 
L__get_direction104:
	BTFSC       STATUS+0, 0 
	GOTO        L_get_direction41
	MOVLW       128
	MOVWF       R0 
	MOVLW       128
	XORWF       Controller_axis_y+3, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__get_direction105
	MOVF        Controller_axis_y+2, 0 
	SUBLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L__get_direction105
	MOVF        Controller_axis_y+1, 0 
	SUBLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L__get_direction105
	MOVF        Controller_axis_y+0, 0 
	SUBLW       0
L__get_direction105:
	BTFSC       STATUS+0, 0 
	GOTO        L_get_direction41
L__get_direction55:
;Controller.c,160 :: 		if (axis_y * TRIG_SCALE < -axis_x * TAN_22_5) // angle less than 90 + 22.5 degrees
	MOVF        Controller_axis_y+0, 0 
	MOVWF       R0 
	MOVF        Controller_axis_y+1, 0 
	MOVWF       R1 
	MOVF        Controller_axis_y+2, 0 
	MOVWF       R2 
	MOVF        Controller_axis_y+3, 0 
	MOVWF       R3 
	MOVLW       16
	MOVWF       R4 
	MOVLW       39
	MOVWF       R5 
	MOVLW       0
	MOVWF       R6 
	MOVLW       0
	MOVWF       R7 
	CALL        _Mul_32x32_U+0, 0
	MOVF        R0, 0 
	MOVWF       FLOC__get_direction+0 
	MOVF        R1, 0 
	MOVWF       FLOC__get_direction+1 
	MOVF        R2, 0 
	MOVWF       FLOC__get_direction+2 
	MOVF        R3, 0 
	MOVWF       FLOC__get_direction+3 
	CLRF        R0 
	CLRF        R1 
	CLRF        R2 
	CLRF        R3 
	MOVF        Controller_axis_x+0, 0 
	SUBWF       R0, 1 
	MOVF        Controller_axis_x+1, 0 
	SUBWFB      R1, 1 
	MOVF        Controller_axis_x+2, 0 
	SUBWFB      R2, 1 
	MOVF        Controller_axis_x+3, 0 
	SUBWFB      R3, 1 
	MOVLW       46
	MOVWF       R4 
	MOVLW       16
	MOVWF       R5 
	MOVLW       0
	MOVWF       R6 
	MOVLW       0
	MOVWF       R7 
	CALL        _Mul_32x32_U+0, 0
	MOVLW       128
	XORWF       FLOC__get_direction+3, 0 
	MOVWF       R4 
	MOVLW       128
	XORWF       R3, 0 
	SUBWF       R4, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__get_direction106
	MOVF        R2, 0 
	SUBWF       FLOC__get_direction+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__get_direction106
	MOVF        R1, 0 
	SUBWF       FLOC__get_direction+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__get_direction106
	MOVF        R0, 0 
	SUBWF       FLOC__get_direction+0, 0 
L__get_direction106:
	BTFSC       STATUS+0, 0 
	GOTO        L_get_direction42
;Controller.c,161 :: 		return WEST;
	MOVLW       7
	MOVWF       R0 
	GOTO        L_end_get_direction
L_get_direction42:
;Controller.c,162 :: 		if (-axis_x * TRIG_SCALE < axis_y * TAN_22_5) // angle more than 180 - 22.5 degrees
	CLRF        R0 
	CLRF        R1 
	CLRF        R2 
	CLRF        R3 
	MOVF        Controller_axis_x+0, 0 
	SUBWF       R0, 1 
	MOVF        Controller_axis_x+1, 0 
	SUBWFB      R1, 1 
	MOVF        Controller_axis_x+2, 0 
	SUBWFB      R2, 1 
	MOVF        Controller_axis_x+3, 0 
	SUBWFB      R3, 1 
	MOVLW       16
	MOVWF       R4 
	MOVLW       39
	MOVWF       R5 
	MOVLW       0
	MOVWF       R6 
	MOVLW       0
	MOVWF       R7 
	CALL        _Mul_32x32_U+0, 0
	MOVF        R0, 0 
	MOVWF       FLOC__get_direction+0 
	MOVF        R1, 0 
	MOVWF       FLOC__get_direction+1 
	MOVF        R2, 0 
	MOVWF       FLOC__get_direction+2 
	MOVF        R3, 0 
	MOVWF       FLOC__get_direction+3 
	MOVF        Controller_axis_y+0, 0 
	MOVWF       R0 
	MOVF        Controller_axis_y+1, 0 
	MOVWF       R1 
	MOVF        Controller_axis_y+2, 0 
	MOVWF       R2 
	MOVF        Controller_axis_y+3, 0 
	MOVWF       R3 
	MOVLW       46
	MOVWF       R4 
	MOVLW       16
	MOVWF       R5 
	MOVLW       0
	MOVWF       R6 
	MOVLW       0
	MOVWF       R7 
	CALL        _Mul_32x32_U+0, 0
	MOVLW       128
	XORWF       FLOC__get_direction+3, 0 
	MOVWF       R4 
	MOVLW       128
	XORWF       R3, 0 
	SUBWF       R4, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__get_direction107
	MOVF        R2, 0 
	SUBWF       FLOC__get_direction+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__get_direction107
	MOVF        R1, 0 
	SUBWF       FLOC__get_direction+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__get_direction107
	MOVF        R0, 0 
	SUBWF       FLOC__get_direction+0, 0 
L__get_direction107:
	BTFSC       STATUS+0, 0 
	GOTO        L_get_direction43
;Controller.c,163 :: 		return NORTH;
	MOVLW       1
	MOVWF       R0 
	GOTO        L_end_get_direction
L_get_direction43:
;Controller.c,164 :: 		return NORTHWEST;
	MOVLW       8
	MOVWF       R0 
	GOTO        L_end_get_direction
;Controller.c,165 :: 		}
L_get_direction41:
;Controller.c,166 :: 		if (axis_x < 0 && axis_y < 0) { // third quadrant
	MOVLW       128
	XORWF       Controller_axis_x+3, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__get_direction108
	MOVLW       0
	SUBWF       Controller_axis_x+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__get_direction108
	MOVLW       0
	SUBWF       Controller_axis_x+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__get_direction108
	MOVLW       0
	SUBWF       Controller_axis_x+0, 0 
L__get_direction108:
	BTFSC       STATUS+0, 0 
	GOTO        L_get_direction46
	MOVLW       128
	XORWF       Controller_axis_y+3, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__get_direction109
	MOVLW       0
	SUBWF       Controller_axis_y+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__get_direction109
	MOVLW       0
	SUBWF       Controller_axis_y+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__get_direction109
	MOVLW       0
	SUBWF       Controller_axis_y+0, 0 
L__get_direction109:
	BTFSC       STATUS+0, 0 
	GOTO        L_get_direction46
L__get_direction54:
;Controller.c,167 :: 		if (-axis_y * TRIG_SCALE < -axis_x * TAN_22_5) // angle less than 180 + 22.5 degrees
	CLRF        R0 
	CLRF        R1 
	CLRF        R2 
	CLRF        R3 
	MOVF        Controller_axis_y+0, 0 
	SUBWF       R0, 1 
	MOVF        Controller_axis_y+1, 0 
	SUBWFB      R1, 1 
	MOVF        Controller_axis_y+2, 0 
	SUBWFB      R2, 1 
	MOVF        Controller_axis_y+3, 0 
	SUBWFB      R3, 1 
	MOVLW       16
	MOVWF       R4 
	MOVLW       39
	MOVWF       R5 
	MOVLW       0
	MOVWF       R6 
	MOVLW       0
	MOVWF       R7 
	CALL        _Mul_32x32_U+0, 0
	MOVF        R0, 0 
	MOVWF       FLOC__get_direction+0 
	MOVF        R1, 0 
	MOVWF       FLOC__get_direction+1 
	MOVF        R2, 0 
	MOVWF       FLOC__get_direction+2 
	MOVF        R3, 0 
	MOVWF       FLOC__get_direction+3 
	CLRF        R0 
	CLRF        R1 
	CLRF        R2 
	CLRF        R3 
	MOVF        Controller_axis_x+0, 0 
	SUBWF       R0, 1 
	MOVF        Controller_axis_x+1, 0 
	SUBWFB      R1, 1 
	MOVF        Controller_axis_x+2, 0 
	SUBWFB      R2, 1 
	MOVF        Controller_axis_x+3, 0 
	SUBWFB      R3, 1 
	MOVLW       46
	MOVWF       R4 
	MOVLW       16
	MOVWF       R5 
	MOVLW       0
	MOVWF       R6 
	MOVLW       0
	MOVWF       R7 
	CALL        _Mul_32x32_U+0, 0
	MOVLW       128
	XORWF       FLOC__get_direction+3, 0 
	MOVWF       R4 
	MOVLW       128
	XORWF       R3, 0 
	SUBWF       R4, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__get_direction110
	MOVF        R2, 0 
	SUBWF       FLOC__get_direction+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__get_direction110
	MOVF        R1, 0 
	SUBWF       FLOC__get_direction+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__get_direction110
	MOVF        R0, 0 
	SUBWF       FLOC__get_direction+0, 0 
L__get_direction110:
	BTFSC       STATUS+0, 0 
	GOTO        L_get_direction47
;Controller.c,168 :: 		return WEST;
	MOVLW       7
	MOVWF       R0 
	GOTO        L_end_get_direction
L_get_direction47:
;Controller.c,169 :: 		if (-axis_x * TRIG_SCALE < -axis_y * TAN_22_5) // angle more than 270 - 22.5 degrees
	CLRF        R0 
	CLRF        R1 
	CLRF        R2 
	CLRF        R3 
	MOVF        Controller_axis_x+0, 0 
	SUBWF       R0, 1 
	MOVF        Controller_axis_x+1, 0 
	SUBWFB      R1, 1 
	MOVF        Controller_axis_x+2, 0 
	SUBWFB      R2, 1 
	MOVF        Controller_axis_x+3, 0 
	SUBWFB      R3, 1 
	MOVLW       16
	MOVWF       R4 
	MOVLW       39
	MOVWF       R5 
	MOVLW       0
	MOVWF       R6 
	MOVLW       0
	MOVWF       R7 
	CALL        _Mul_32x32_U+0, 0
	MOVF        R0, 0 
	MOVWF       FLOC__get_direction+0 
	MOVF        R1, 0 
	MOVWF       FLOC__get_direction+1 
	MOVF        R2, 0 
	MOVWF       FLOC__get_direction+2 
	MOVF        R3, 0 
	MOVWF       FLOC__get_direction+3 
	CLRF        R0 
	CLRF        R1 
	CLRF        R2 
	CLRF        R3 
	MOVF        Controller_axis_y+0, 0 
	SUBWF       R0, 1 
	MOVF        Controller_axis_y+1, 0 
	SUBWFB      R1, 1 
	MOVF        Controller_axis_y+2, 0 
	SUBWFB      R2, 1 
	MOVF        Controller_axis_y+3, 0 
	SUBWFB      R3, 1 
	MOVLW       46
	MOVWF       R4 
	MOVLW       16
	MOVWF       R5 
	MOVLW       0
	MOVWF       R6 
	MOVLW       0
	MOVWF       R7 
	CALL        _Mul_32x32_U+0, 0
	MOVLW       128
	XORWF       FLOC__get_direction+3, 0 
	MOVWF       R4 
	MOVLW       128
	XORWF       R3, 0 
	SUBWF       R4, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__get_direction111
	MOVF        R2, 0 
	SUBWF       FLOC__get_direction+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__get_direction111
	MOVF        R1, 0 
	SUBWF       FLOC__get_direction+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__get_direction111
	MOVF        R0, 0 
	SUBWF       FLOC__get_direction+0, 0 
L__get_direction111:
	BTFSC       STATUS+0, 0 
	GOTO        L_get_direction48
;Controller.c,170 :: 		return SOUTH;
	MOVLW       5
	MOVWF       R0 
	GOTO        L_end_get_direction
L_get_direction48:
;Controller.c,171 :: 		return SOUTHWEST;
	MOVLW       6
	MOVWF       R0 
	GOTO        L_end_get_direction
;Controller.c,172 :: 		}
L_get_direction46:
;Controller.c,174 :: 		if (-axis_y * TRIG_SCALE < axis_x * TAN_22_5) // angle less than 270 + 22.5 degrees
	CLRF        R0 
	CLRF        R1 
	CLRF        R2 
	CLRF        R3 
	MOVF        Controller_axis_y+0, 0 
	SUBWF       R0, 1 
	MOVF        Controller_axis_y+1, 0 
	SUBWFB      R1, 1 
	MOVF        Controller_axis_y+2, 0 
	SUBWFB      R2, 1 
	MOVF        Controller_axis_y+3, 0 
	SUBWFB      R3, 1 
	MOVLW       16
	MOVWF       R4 
	MOVLW       39
	MOVWF       R5 
	MOVLW       0
	MOVWF       R6 
	MOVLW       0
	MOVWF       R7 
	CALL        _Mul_32x32_U+0, 0
	MOVF        R0, 0 
	MOVWF       FLOC__get_direction+0 
	MOVF        R1, 0 
	MOVWF       FLOC__get_direction+1 
	MOVF        R2, 0 
	MOVWF       FLOC__get_direction+2 
	MOVF        R3, 0 
	MOVWF       FLOC__get_direction+3 
	MOVF        Controller_axis_x+0, 0 
	MOVWF       R0 
	MOVF        Controller_axis_x+1, 0 
	MOVWF       R1 
	MOVF        Controller_axis_x+2, 0 
	MOVWF       R2 
	MOVF        Controller_axis_x+3, 0 
	MOVWF       R3 
	MOVLW       46
	MOVWF       R4 
	MOVLW       16
	MOVWF       R5 
	MOVLW       0
	MOVWF       R6 
	MOVLW       0
	MOVWF       R7 
	CALL        _Mul_32x32_U+0, 0
	MOVLW       128
	XORWF       FLOC__get_direction+3, 0 
	MOVWF       R4 
	MOVLW       128
	XORWF       R3, 0 
	SUBWF       R4, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__get_direction112
	MOVF        R2, 0 
	SUBWF       FLOC__get_direction+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__get_direction112
	MOVF        R1, 0 
	SUBWF       FLOC__get_direction+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__get_direction112
	MOVF        R0, 0 
	SUBWF       FLOC__get_direction+0, 0 
L__get_direction112:
	BTFSC       STATUS+0, 0 
	GOTO        L_get_direction49
;Controller.c,175 :: 		return EAST;
	MOVLW       3
	MOVWF       R0 
	GOTO        L_end_get_direction
L_get_direction49:
;Controller.c,176 :: 		if (axis_x * TRIG_SCALE < -axis_y * TAN_22_5) // angle more than 360 - 22.5 degrees
	MOVF        Controller_axis_x+0, 0 
	MOVWF       R0 
	MOVF        Controller_axis_x+1, 0 
	MOVWF       R1 
	MOVF        Controller_axis_x+2, 0 
	MOVWF       R2 
	MOVF        Controller_axis_x+3, 0 
	MOVWF       R3 
	MOVLW       16
	MOVWF       R4 
	MOVLW       39
	MOVWF       R5 
	MOVLW       0
	MOVWF       R6 
	MOVLW       0
	MOVWF       R7 
	CALL        _Mul_32x32_U+0, 0
	MOVF        R0, 0 
	MOVWF       FLOC__get_direction+0 
	MOVF        R1, 0 
	MOVWF       FLOC__get_direction+1 
	MOVF        R2, 0 
	MOVWF       FLOC__get_direction+2 
	MOVF        R3, 0 
	MOVWF       FLOC__get_direction+3 
	CLRF        R0 
	CLRF        R1 
	CLRF        R2 
	CLRF        R3 
	MOVF        Controller_axis_y+0, 0 
	SUBWF       R0, 1 
	MOVF        Controller_axis_y+1, 0 
	SUBWFB      R1, 1 
	MOVF        Controller_axis_y+2, 0 
	SUBWFB      R2, 1 
	MOVF        Controller_axis_y+3, 0 
	SUBWFB      R3, 1 
	MOVLW       46
	MOVWF       R4 
	MOVLW       16
	MOVWF       R5 
	MOVLW       0
	MOVWF       R6 
	MOVLW       0
	MOVWF       R7 
	CALL        _Mul_32x32_U+0, 0
	MOVLW       128
	XORWF       FLOC__get_direction+3, 0 
	MOVWF       R4 
	MOVLW       128
	XORWF       R3, 0 
	SUBWF       R4, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__get_direction113
	MOVF        R2, 0 
	SUBWF       FLOC__get_direction+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__get_direction113
	MOVF        R1, 0 
	SUBWF       FLOC__get_direction+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__get_direction113
	MOVF        R0, 0 
	SUBWF       FLOC__get_direction+0, 0 
L__get_direction113:
	BTFSC       STATUS+0, 0 
	GOTO        L_get_direction50
;Controller.c,177 :: 		return SOUTH;
	MOVLW       5
	MOVWF       R0 
	GOTO        L_end_get_direction
L_get_direction50:
;Controller.c,178 :: 		return SOUTHEAST;
	MOVLW       4
	MOVWF       R0 
;Controller.c,179 :: 		}
L_end_get_direction:
	RETURN      0
; end of _get_direction

_interrupt:

;Controller.c,182 :: 		void interrupt(){
;Controller.c,183 :: 		if (TMR1IF_bit){
	BTFSS       TMR1IF_bit+0, BitPos(TMR1IF_bit+0) 
	GOTO        L_interrupt51
;Controller.c,185 :: 		TMR1IF_bit = 0;
	BCF         TMR1IF_bit+0, BitPos(TMR1IF_bit+0) 
;Controller.c,186 :: 		TMR1H = 0x48;
	MOVLW       72
	MOVWF       TMR1H+0 
;Controller.c,187 :: 		TMR1L = 0xE5;
	MOVLW       229
	MOVWF       TMR1L+0 
;Controller.c,189 :: 		if (magnetometer_uninitialized) {
	MOVF        Controller_magnetometer_uninitialized+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_interrupt52
;Controller.c,190 :: 		init_magnetometer(); // configure magnetometer to take readings every second
	CALL        _init_magnetometer+0, 0
;Controller.c,191 :: 		magnetometer_uninitialized = 0;
	CLRF        Controller_magnetometer_uninitialized+0 
;Controller.c,192 :: 		}
	GOTO        L_interrupt53
L_interrupt52:
;Controller.c,194 :: 		get_magnetometer(&magnetic_x, &magnetic_y, &magnetic_z);
	MOVLW       _magnetic_x+0
	MOVWF       FARG_get_magnetometer_x+0 
	MOVLW       hi_addr(_magnetic_x+0)
	MOVWF       FARG_get_magnetometer_x+1 
	MOVLW       _magnetic_y+0
	MOVWF       FARG_get_magnetometer_y+0 
	MOVLW       hi_addr(_magnetic_y+0)
	MOVWF       FARG_get_magnetometer_y+1 
	MOVLW       _magnetic_z+0
	MOVWF       FARG_get_magnetometer_z+0 
	MOVLW       hi_addr(_magnetic_z+0)
	MOVWF       FARG_get_magnetometer_z+1 
	CALL        _get_magnetometer+0, 0
;Controller.c,195 :: 		notify(get_direction(magnetic_x, magnetic_y, magnetic_z));
	MOVF        _magnetic_x+0, 0 
	MOVWF       FARG_get_direction_x+0 
	MOVF        _magnetic_x+1, 0 
	MOVWF       FARG_get_direction_x+1 
	MOVF        _magnetic_y+0, 0 
	MOVWF       FARG_get_direction_y+0 
	MOVF        _magnetic_y+1, 0 
	MOVWF       FARG_get_direction_y+1 
	MOVF        _magnetic_z+0, 0 
	MOVWF       FARG_get_direction_z+0 
	MOVF        _magnetic_z+1, 0 
	MOVWF       FARG_get_direction_z+1 
	CALL        _get_direction+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_notify_index+0 
	MOVLW       0
	MOVWF       FARG_notify_index+1 
	CALL        _notify+0, 0
;Controller.c,196 :: 		}
L_interrupt53:
;Controller.c,197 :: 		}
L_interrupt51:
;Controller.c,198 :: 		}
L_end_interrupt:
L__interrupt115:
	RETFIE      1
; end of _interrupt
