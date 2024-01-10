#define DHT_IN PINB.0
#define DHT_OUT PORTB.0
#define DHT_DDR DDRB.0
#define ERROR 0
#define OK 1

unsigned char DHT_take (unsigned char *nhietdo, unsigned char *doam){
    unsigned char buff[5] = {0,0,0,0,0};
    unsigned char i,i1,sum;
    
    DHT_DDR = 1;
    DHT_OUT = 1;
    delay_us(60);
    DHT_OUT = 0;
    delay_ms(25);
    DHT_OUT = 1;
    DHT_DDR = 0;
    delay_ms(60); 
    
    if (DHT_IN){    
        return ERROR;
    }
    else while (!(DHT_IN));
    delay_us(60);
    if (!(DHT_IN))
        {
            return ERROR;
        }  
    else while ((DHT_IN));
    for(i=0;i<5;i++)
    {
        for(i1=0;i1<8;i1++)
        {    
        while((!DHT_IN));
        delay_us(50);
        if(DHT_IN)
            {
            buff[i]|=(1<<(5-i1));  
            while((DHT_IN));
            }
        }
    }
     
    sum = buff[0] + buff[1] + buff[2] + buff[3];
    
    if ((sum) != buff[4]){
        return ERROR;
    }          
    
    *nhietdo = buff[2];
    *doam = buff[0];
    return OK;
    
}