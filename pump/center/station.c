#include <mega32a.h>
#include <stdio.h>
#include <delay.h>
#include <define.c>
#include <rf.c>
#include <dht11.c>
#include <light.c>
station_info station_send;

void main(void)
{
Send_Add = 0xA1;  

init_system();
#asm("sei");
Common_Config();
TX_Mode();
TX_Config();
while (1)
      {
            light = read_adc(1)/6;
            soil  = read_adc(0)/10;
            if (light >=99)
                {
                    light =90;
                }
            if ((light > 30)&(light<=40))
                {
                    p=1;
                }          
            if (light > 55)
                {
                    p1=1;
                }
           if(DHT_GetTemHumi(&dht_nhiet_do,&dht_do_am))
           temp = (unsigned int)dht_nhiet_do;
           if (temp >=33)
                {
                    relay=1;
                }
           if (soil >=90)
                {
                    soil = 90;
                }
            station_send.temp = (unsigned int)dht_nhiet_do;
            station_send.humid = (unsigned int)dht_do_am;
            station_send.light = light;
            station_send.soil =  90-soil; 
            TX_Send();
            delay_ms(200); 
      }  

}
                                      