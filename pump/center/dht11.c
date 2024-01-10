//config DHT11
#define         DHT_DATA_IN     PIND.2   
#define         DHT_DATA_OUT    PORTD.2            
#define         DHT_DDR_DATA    DDRD.2 
#define DHT_ER       0
#define DHT_OK       1 
unsigned char dht_nhiet_do,dht_do_am; 

unsigned char DHT_GetTemHumi (unsigned char *tem, unsigned char *humi){
    unsigned char buffer[5]={0,0,0,0,0};
    unsigned char ii,i,checksum;
    
    DHT_DDR_DATA=1;   // set la cong ra
    DHT_DATA_OUT=1;   // Dua chan DATA len 1 thiet lap la chan dau vao
    delay_us(60);
    DHT_DATA_OUT=0;   // Dua chan DATA xuong 0, do gia tri nhiet do do am
    delay_ms(25);
    DHT_DATA_OUT=1;   // Dua chan DATA len 1 thiet lap la chan dau vao
    DHT_DDR_DATA=0;   //set la loi vao
    delay_us(60);
    if(DHT_DATA_IN){  // Chan chua duoc keo xuong --> Loi
        return DHT_ER ;
    }
    else while(!(DHT_DATA_IN));    //Doi DaTa len 1
    delay_us(60);
    if(!DHT_DATA_IN){ // Keo xuong roi --> Loi
        return DHT_ER;
    }
    else while((DHT_DATA_IN));     //Doi Data ve 0
    //Bat dau doc du lieu
    for(i=0;i<5;i++)
    {
        for(ii=0;ii<8;ii++)
        {    
        while((!DHT_DATA_IN));//Doi Data len 1
        delay_us(50);
        if(DHT_DATA_IN)
            {
            buffer[i]|=(1<<(7-ii));  //lay 7bit du lieu gui ve
            while((DHT_DATA_IN));//Doi Data xuong 0
            }
        }
    }
    //Tinh toan check sum
    checksum=buffer[0]+buffer[1]+buffer[2]+buffer[3];
    //Kiem tra check sum
    if((checksum)!=buffer[4]){ //Neu tong cac bit != bit4 --> Loi
        return DHT_ER;
    }
    //Lay du lieu
    *tem  =   buffer[2];//Phan nguyen cua nhiet do
    *humi =   buffer[0];//Phan nguyen cua do am
    return DHT_OK;  
}