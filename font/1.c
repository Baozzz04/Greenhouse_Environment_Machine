#define CE          PORTD.7
#define CSN         PORTD.6
#define SCK         PORTD.5
#define MOSI        PORTD.4
#define MISO        PIND.3
#define IRQ         PIND.2
//------------------------
#define LED         PORTB.4
#define button      PIND.0
unsigned char P_Add=0xB1, Code_tay_cam1 = 0xA4, Code_tay_cam2, Code_tay_cam3, Code_tay_cam4;
#include <io.h>
#include <stdio.h>
#include <delay.h>
#include <glcd.h>
#include <glcd_types.h>
#include "light_10.c"
#include "light_50.c"
#include "light_90.c"
#include "general.c"
#include "humid_85.c"
#include "soil_dry.c"
#include "soil_wet.c"
#include "air_70.c"
#include "temp.c"




#include <font5x7.h>
#include <rf.c>
#include <stdio.h>
#include <stdlib.h>
#include <big_letter_10x14.c>
#include <tiny_letter.c>
unsigned char buff[80];
long dem;
station_info data_send;
#include <gui.c>
interrupt [TIM0_OVF] void timer0_ovf(){
    TCNT0 = 0x9C;
    dem++;
}
void main(void)
{
GLCDINIT_t glcd_init_data;
DDRB.4=1;
PORTB.4=0;
DDRA.6=1;
PORTA.6=1;
DDRD = 0b11110000;
PORTD = 0b11111111;
TCCR0=(0<<CS02) | (1<<CS01) | (0<<CS00);
TCNT0=0x9C;
TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (1<<TOIE0);
glcd_init_data.font=font5x7;
glcd_init_data.temp_coef=90;
glcd_init_data.bias=3;   //rom 1 3 3-4

glcd_init_data.vlcd=60;   //rom 1-58; 
glcd_init(&glcd_init_data);

#asm("sei")

RF_Init_RX();
config();
RF_Config_RX_2();
while (1)
   {
    glcd_putimagef(0,0,temp,0);  
   
   }
  
} 
