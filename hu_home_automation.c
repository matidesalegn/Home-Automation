/*
Automatic controll 0f home applience
*/
sbit LCD_RS at RD4_bit;
sbit LCD_EN at RD5_bit;
sbit LCD_D4 at RD0_bit;
sbit LCD_D5 at RD1_bit;
sbit LCD_D6 at RD2_bit;
sbit LCD_D7 at RD3_bit;
sbit LCD_RS_Direction at TRISD4_bit;
sbit LCD_EN_Direction at TRISD5_bit;
sbit LCD_D4_Direction at TRISD0_bit;
sbit LCD_D5_Direction at TRISD1_bit;
sbit LCD_D6_Direction at TRISD2_bit;
sbit LCD_D7_Direction at TRISD3_bit;
int count = 0;
int enter_exit_sensor()
{
    if(PORTB.F0 == 1)         // person enters
        {
            count++;
            while(PORTB.F0 == 1);
        }

        if(PORTB.F1 == 1)              //if person exits
        {
            if(count > 0)            // If there is a person inside the home
            {
                count--;
                while(PORTB.F1 == 1);
            }
        }
        return count;

}
int read_light()
{
    float adc_value;
    float light;
    
    adc_value = ADC_Read(1);        //read the light intensity from channel 1
    light = 100-adc_value/10.24;    // Format the value
    return light;
}
unsigned read_temprature()
{
    unsigned int unformated_temp_value, formated_temprature;

    unformated_temp_value = ADC_read(0);      //read the temprature from channel 0
    formated_temprature = (5 * unformated_temp_value * 100 / 1024);   // Format the value
    return (formated_temprature);
}
void LIGHT_ON_OFF(int light)    //Function to on and off based onthe light intensity
{

    if(light <= 80)
        PORTD.f6=1;
    else
        PORTD.f6 = 0;
}

void FAN_ON_OFF(int temprature)                   //Function on on of the Fan or the heater
{                                   //based on the temprature
    if (temprature < 20)   //If temprature value is less than 20 On the heater
        PORTD.f7 = 1;
    else
        PORTD.F7 = 0;
    if (temprature > 25 && temprature <30)  //If the temprature is between 25 and 30
        pwm1_set_duty(100);
    else
    {
        if (temprature > 30 && temprature < 35 )
            pwm1_set_duty(192);
        else
        {
            if(temprature > 35)
                pwm1_set_duty(255);
            else
                pwm1_set_duty(0);                //Off the Fun
        }
    }
}
void main()
{
    unsigned char tot[5];
    int temp_str[5];
    int temprature, light, no_people;
    unsigned long light_str[5];
    TRISA = 0XFF;         //configure port A Input
    TRISD = 0x00;         //configure port D output
    TRISC = 0x00;         //configure port C output
    TRISB = 0XFF;         //configure port B Input
    
    PORTD.B6 = 0;
    PORTD.B7 = 0;

   //Initialize LCD, Analog to digital converter, and PWM1 module
    Lcd_Init();
    ADC_Init();             // Initialize ADC module with default settings
    PWM1_Init(5000);
    PWM1_Start();
    
    Lcd_Cmd(_LCD_CURSOR_OFF);
    Lcd_Out(1, 2,"HOME AUTOMATION");
    Lcd_Out(2, 1,"No of pepl: ");
    Lcd_out(3, 1, "Temprature: ");
    Lcd_out(4, 1, "Light Intes:");

    for(;;)                 //endless loop
    {
        
        light = read_light();
        IntToStr(light, light_Str);      //covert into string to print in LCD display
        Lcd_Out(4, 12, light_str) ;
        
        temprature = read_temprature();
        IntToStr(temprature, temp_Str);      //covert into string to print in LCD display
        Lcd_Out(3, 14, temp_str) ;
        
        no_people = enter_exit_sensor();
        IntToStr(no_people, tot);
        Lcd_Out(2, 12, tot);
        if(no_people > 0)                //if there is a person inside the room
        {
            LIGHT_ON_OFF(light);         // call light on of function
            FAN_ON_OFF(temprature);           // call fan on off function
        }
        else                      // if there is no person off all systems
        {
            PORTD.f7=0;
            PORTD.f6=0;
            PORTC.f3=0;
        }
    }
}