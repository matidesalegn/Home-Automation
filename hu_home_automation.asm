
_enter_exit_sensor:

;hu_home_automation.c,17 :: 		int enter_exit_sensor()
;hu_home_automation.c,19 :: 		if(PORTB.F0 == 1)         // person enters
	BTFSS       PORTB+0, 0 
	GOTO        L_enter_exit_sensor0
;hu_home_automation.c,21 :: 		count++;
	INFSNZ      _count+0, 1 
	INCF        _count+1, 1 
;hu_home_automation.c,22 :: 		while(PORTB.F0 == 1);
L_enter_exit_sensor1:
	BTFSS       PORTB+0, 0 
	GOTO        L_enter_exit_sensor2
	GOTO        L_enter_exit_sensor1
L_enter_exit_sensor2:
;hu_home_automation.c,23 :: 		}
L_enter_exit_sensor0:
;hu_home_automation.c,25 :: 		if(PORTB.F1 == 1)              //if person exits
	BTFSS       PORTB+0, 1 
	GOTO        L_enter_exit_sensor3
;hu_home_automation.c,27 :: 		if(count > 0)            // If there is a person inside the home
	MOVLW       128
	MOVWF       R0 
	MOVLW       128
	XORWF       _count+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__enter_exit_sensor29
	MOVF        _count+0, 0 
	SUBLW       0
L__enter_exit_sensor29:
	BTFSC       STATUS+0, 0 
	GOTO        L_enter_exit_sensor4
;hu_home_automation.c,29 :: 		count--;
	MOVLW       1
	SUBWF       _count+0, 1 
	MOVLW       0
	SUBWFB      _count+1, 1 
;hu_home_automation.c,30 :: 		while(PORTB.F1 == 1);
L_enter_exit_sensor5:
	BTFSS       PORTB+0, 1 
	GOTO        L_enter_exit_sensor6
	GOTO        L_enter_exit_sensor5
L_enter_exit_sensor6:
;hu_home_automation.c,31 :: 		}
L_enter_exit_sensor4:
;hu_home_automation.c,32 :: 		}
L_enter_exit_sensor3:
;hu_home_automation.c,33 :: 		return count;
	MOVF        _count+0, 0 
	MOVWF       R0 
	MOVF        _count+1, 0 
	MOVWF       R1 
;hu_home_automation.c,35 :: 		}
L_end_enter_exit_sensor:
	RETURN      0
; end of _enter_exit_sensor

_read_light:

;hu_home_automation.c,36 :: 		int read_light()
;hu_home_automation.c,41 :: 		adc_value = ADC_Read(1);        //read the light intensity from channel 1
	MOVLW       1
	MOVWF       FARG_ADC_Read_channel+0 
	CALL        _ADC_Read+0, 0
	CALL        _word2double+0, 0
;hu_home_automation.c,42 :: 		light = 100-adc_value/10.24;    // Format the value
	MOVLW       10
	MOVWF       R4 
	MOVLW       215
	MOVWF       R5 
	MOVLW       35
	MOVWF       R6 
	MOVLW       130
	MOVWF       R7 
	CALL        _Div_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       R4 
	MOVF        R1, 0 
	MOVWF       R5 
	MOVF        R2, 0 
	MOVWF       R6 
	MOVF        R3, 0 
	MOVWF       R7 
	MOVLW       0
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVLW       72
	MOVWF       R2 
	MOVLW       133
	MOVWF       R3 
	CALL        _Sub_32x32_FP+0, 0
;hu_home_automation.c,43 :: 		return light;
	CALL        _double2int+0, 0
;hu_home_automation.c,44 :: 		}
L_end_read_light:
	RETURN      0
; end of _read_light

_read_temprature:

;hu_home_automation.c,45 :: 		unsigned read_temprature()
;hu_home_automation.c,49 :: 		unformated_temp_value = ADC_read(0);      //read the temprature from channel 0
	CLRF        FARG_ADC_Read_channel+0 
	CALL        _ADC_Read+0, 0
;hu_home_automation.c,50 :: 		formated_temprature = (5 * unformated_temp_value * 100 / 1024);   // Format the value
	MOVLW       5
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       100
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       10
	MOVWF       R4 
	MOVF        R0, 0 
	MOVWF       R2 
	MOVF        R1, 0 
	MOVWF       R3 
	MOVF        R4, 0 
L__read_temprature32:
	BZ          L__read_temprature33
	RRCF        R3, 1 
	RRCF        R2, 1 
	BCF         R3, 7 
	ADDLW       255
	GOTO        L__read_temprature32
L__read_temprature33:
;hu_home_automation.c,51 :: 		return (formated_temprature);
	MOVF        R2, 0 
	MOVWF       R0 
	MOVF        R3, 0 
	MOVWF       R1 
;hu_home_automation.c,52 :: 		}
L_end_read_temprature:
	RETURN      0
; end of _read_temprature

_LIGHT_ON_OFF:

;hu_home_automation.c,53 :: 		void LIGHT_ON_OFF(int light)    //Function to on and off based onthe light intensity
;hu_home_automation.c,56 :: 		if(light <= 80)
	MOVLW       128
	MOVWF       R0 
	MOVLW       128
	XORWF       FARG_LIGHT_ON_OFF_light+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__LIGHT_ON_OFF35
	MOVF        FARG_LIGHT_ON_OFF_light+0, 0 
	SUBLW       80
L__LIGHT_ON_OFF35:
	BTFSS       STATUS+0, 0 
	GOTO        L_LIGHT_ON_OFF7
;hu_home_automation.c,57 :: 		PORTD.f6=1;
	BSF         PORTD+0, 6 
	GOTO        L_LIGHT_ON_OFF8
L_LIGHT_ON_OFF7:
;hu_home_automation.c,59 :: 		PORTD.f6 = 0;
	BCF         PORTD+0, 6 
L_LIGHT_ON_OFF8:
;hu_home_automation.c,60 :: 		}
L_end_LIGHT_ON_OFF:
	RETURN      0
; end of _LIGHT_ON_OFF

_FAN_ON_OFF:

;hu_home_automation.c,62 :: 		void FAN_ON_OFF(int temprature)                   //Function on on of the Fan or the heater
;hu_home_automation.c,64 :: 		if (temprature < 20)   //If temprature value is less than 20 On the heater
	MOVLW       128
	XORWF       FARG_FAN_ON_OFF_temprature+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__FAN_ON_OFF37
	MOVLW       20
	SUBWF       FARG_FAN_ON_OFF_temprature+0, 0 
L__FAN_ON_OFF37:
	BTFSC       STATUS+0, 0 
	GOTO        L_FAN_ON_OFF9
;hu_home_automation.c,65 :: 		PORTD.f7 = 1;
	BSF         PORTD+0, 7 
	GOTO        L_FAN_ON_OFF10
L_FAN_ON_OFF9:
;hu_home_automation.c,67 :: 		PORTD.F7 = 0;
	BCF         PORTD+0, 7 
L_FAN_ON_OFF10:
;hu_home_automation.c,68 :: 		if (temprature > 25 && temprature <30)  //If the temprature is between 25 and 30
	MOVLW       128
	MOVWF       R0 
	MOVLW       128
	XORWF       FARG_FAN_ON_OFF_temprature+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__FAN_ON_OFF38
	MOVF        FARG_FAN_ON_OFF_temprature+0, 0 
	SUBLW       25
L__FAN_ON_OFF38:
	BTFSC       STATUS+0, 0 
	GOTO        L_FAN_ON_OFF13
	MOVLW       128
	XORWF       FARG_FAN_ON_OFF_temprature+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__FAN_ON_OFF39
	MOVLW       30
	SUBWF       FARG_FAN_ON_OFF_temprature+0, 0 
L__FAN_ON_OFF39:
	BTFSC       STATUS+0, 0 
	GOTO        L_FAN_ON_OFF13
L__FAN_ON_OFF27:
;hu_home_automation.c,69 :: 		pwm1_set_duty(100);
	MOVLW       100
	MOVWF       FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
	GOTO        L_FAN_ON_OFF14
L_FAN_ON_OFF13:
;hu_home_automation.c,72 :: 		if (temprature > 30 && temprature < 35 )
	MOVLW       128
	MOVWF       R0 
	MOVLW       128
	XORWF       FARG_FAN_ON_OFF_temprature+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__FAN_ON_OFF40
	MOVF        FARG_FAN_ON_OFF_temprature+0, 0 
	SUBLW       30
L__FAN_ON_OFF40:
	BTFSC       STATUS+0, 0 
	GOTO        L_FAN_ON_OFF17
	MOVLW       128
	XORWF       FARG_FAN_ON_OFF_temprature+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__FAN_ON_OFF41
	MOVLW       35
	SUBWF       FARG_FAN_ON_OFF_temprature+0, 0 
L__FAN_ON_OFF41:
	BTFSC       STATUS+0, 0 
	GOTO        L_FAN_ON_OFF17
L__FAN_ON_OFF26:
;hu_home_automation.c,73 :: 		pwm1_set_duty(192);
	MOVLW       192
	MOVWF       FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
	GOTO        L_FAN_ON_OFF18
L_FAN_ON_OFF17:
;hu_home_automation.c,76 :: 		if(temprature > 35)
	MOVLW       128
	MOVWF       R0 
	MOVLW       128
	XORWF       FARG_FAN_ON_OFF_temprature+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__FAN_ON_OFF42
	MOVF        FARG_FAN_ON_OFF_temprature+0, 0 
	SUBLW       35
L__FAN_ON_OFF42:
	BTFSC       STATUS+0, 0 
	GOTO        L_FAN_ON_OFF19
;hu_home_automation.c,77 :: 		pwm1_set_duty(255);
	MOVLW       255
	MOVWF       FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
	GOTO        L_FAN_ON_OFF20
L_FAN_ON_OFF19:
;hu_home_automation.c,79 :: 		pwm1_set_duty(0);                //Off the Fun
	CLRF        FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
L_FAN_ON_OFF20:
;hu_home_automation.c,80 :: 		}
L_FAN_ON_OFF18:
;hu_home_automation.c,81 :: 		}
L_FAN_ON_OFF14:
;hu_home_automation.c,82 :: 		}
L_end_FAN_ON_OFF:
	RETURN      0
; end of _FAN_ON_OFF

_main:

;hu_home_automation.c,83 :: 		void main()
;hu_home_automation.c,89 :: 		TRISA = 0XFF;         //configure port A Input
	MOVLW       255
	MOVWF       TRISA+0 
;hu_home_automation.c,90 :: 		TRISD = 0x00;         //configure port D output
	CLRF        TRISD+0 
;hu_home_automation.c,91 :: 		TRISC = 0x00;         //configure port C output
	CLRF        TRISC+0 
;hu_home_automation.c,92 :: 		TRISB = 0XFF;         //configure port B Input
	MOVLW       255
	MOVWF       TRISB+0 
;hu_home_automation.c,94 :: 		PORTD.B6 = 0;
	BCF         PORTD+0, 6 
;hu_home_automation.c,95 :: 		PORTD.B7 = 0;
	BCF         PORTD+0, 7 
;hu_home_automation.c,98 :: 		Lcd_Init();
	CALL        _Lcd_Init+0, 0
;hu_home_automation.c,99 :: 		ADC_Init();             // Initialize ADC module with default settings
	CALL        _ADC_Init+0, 0
;hu_home_automation.c,100 :: 		PWM1_Init(5000);
	BSF         T2CON+0, 0, 0
	BCF         T2CON+0, 1, 0
	MOVLW       99
	MOVWF       PR2+0, 0
	CALL        _PWM1_Init+0, 0
;hu_home_automation.c,101 :: 		PWM1_Start();
	CALL        _PWM1_Start+0, 0
;hu_home_automation.c,103 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);
	MOVLW       12
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;hu_home_automation.c,104 :: 		Lcd_Out(1, 2,"HOME AUTOMATION");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       2
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr1_hu_home_automation+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr1_hu_home_automation+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;hu_home_automation.c,105 :: 		Lcd_Out(2, 1,"No of pepl: ");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr2_hu_home_automation+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr2_hu_home_automation+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;hu_home_automation.c,106 :: 		Lcd_out(3, 1, "Temprature: ");
	MOVLW       3
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr3_hu_home_automation+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr3_hu_home_automation+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;hu_home_automation.c,107 :: 		Lcd_out(4, 1, "Light Intes:");
	MOVLW       4
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr4_hu_home_automation+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr4_hu_home_automation+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;hu_home_automation.c,109 :: 		for(;;)                 //endless loop
L_main21:
;hu_home_automation.c,112 :: 		light = read_light();
	CALL        _read_light+0, 0
	MOVF        R0, 0 
	MOVWF       main_light_L0+0 
	MOVF        R1, 0 
	MOVWF       main_light_L0+1 
;hu_home_automation.c,113 :: 		IntToStr(light, light_Str);      //covert into string to print in LCD display
	MOVF        R0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVF        R1, 0 
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       main_light_str_L0+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(main_light_str_L0+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;hu_home_automation.c,114 :: 		Lcd_Out(4, 12, light_str) ;
	MOVLW       4
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       12
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       main_light_str_L0+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(main_light_str_L0+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;hu_home_automation.c,116 :: 		temprature = read_temprature();
	CALL        _read_temprature+0, 0
	MOVF        R0, 0 
	MOVWF       main_temprature_L0+0 
	MOVF        R1, 0 
	MOVWF       main_temprature_L0+1 
;hu_home_automation.c,117 :: 		IntToStr(temprature, temp_Str);      //covert into string to print in LCD display
	MOVF        R0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVF        R1, 0 
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       main_temp_str_L0+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(main_temp_str_L0+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;hu_home_automation.c,118 :: 		Lcd_Out(3, 14, temp_str) ;
	MOVLW       3
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       14
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       main_temp_str_L0+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(main_temp_str_L0+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;hu_home_automation.c,120 :: 		no_people = enter_exit_sensor();
	CALL        _enter_exit_sensor+0, 0
	MOVF        R0, 0 
	MOVWF       main_no_people_L0+0 
	MOVF        R1, 0 
	MOVWF       main_no_people_L0+1 
;hu_home_automation.c,121 :: 		IntToStr(no_people, tot);
	MOVF        R0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVF        R1, 0 
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       main_tot_L0+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(main_tot_L0+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;hu_home_automation.c,122 :: 		Lcd_Out(2, 12, tot);
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       12
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       main_tot_L0+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(main_tot_L0+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;hu_home_automation.c,123 :: 		if(no_people > 0)                //if there is a person inside the room
	MOVLW       128
	MOVWF       R0 
	MOVLW       128
	XORWF       main_no_people_L0+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main44
	MOVF        main_no_people_L0+0, 0 
	SUBLW       0
L__main44:
	BTFSC       STATUS+0, 0 
	GOTO        L_main24
;hu_home_automation.c,125 :: 		LIGHT_ON_OFF(light);         // call light on of function
	MOVF        main_light_L0+0, 0 
	MOVWF       FARG_LIGHT_ON_OFF_light+0 
	MOVF        main_light_L0+1, 0 
	MOVWF       FARG_LIGHT_ON_OFF_light+1 
	CALL        _LIGHT_ON_OFF+0, 0
;hu_home_automation.c,126 :: 		FAN_ON_OFF(temprature);           // call fan on off function
	MOVF        main_temprature_L0+0, 0 
	MOVWF       FARG_FAN_ON_OFF_temprature+0 
	MOVF        main_temprature_L0+1, 0 
	MOVWF       FARG_FAN_ON_OFF_temprature+1 
	CALL        _FAN_ON_OFF+0, 0
;hu_home_automation.c,127 :: 		}
	GOTO        L_main25
L_main24:
;hu_home_automation.c,130 :: 		PORTD.f7=0;
	BCF         PORTD+0, 7 
;hu_home_automation.c,131 :: 		PORTD.f6=0;
	BCF         PORTD+0, 6 
;hu_home_automation.c,132 :: 		PORTC.f3=0;
	BCF         PORTC+0, 3 
;hu_home_automation.c,133 :: 		}
L_main25:
;hu_home_automation.c,134 :: 		}
	GOTO        L_main21
;hu_home_automation.c,135 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
