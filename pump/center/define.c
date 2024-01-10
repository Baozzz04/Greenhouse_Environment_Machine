
#define servo_1    PORTB.1
#define servo_2    PORTB.2
#define servo_3    PORTB.4
#define servo_4    PORTD.0
#define Role    PORTD.1
#define Led_1    PORTD.3
#define Led_2    PORTD.6

#define tiemcan_1    PORTA.1
#define tiemcan_2    PORTA.0
#define tiemcan_3    PORTB.0

#define CE PORTC.2
#define CSN PORTC.6
#define SCK PORTC.1
#define MOSI PORTC.7
#define MISO PINC.0
#define IRQ PINA.7

unsigned char p=0, p1=0, relay=0;

unsigned int dem=0, dem_1=0, dem_2=0;
unsigned int light, soil, temp;


interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
TCNT0=0xB2; //10ms
if(p==1)
        {   
            Led_1=1; 
            dem++; 
        }  
if(dem==500)  
        {
            Led_1=0; 
            dem=0;  
            p=0; 
        }
if (p1==1)
    {
        p=1;
        Led_1=1;
        Led_2=1;
        dem_1++;
    }
if (dem_1==500)
    {
        Led_2=0;
        Led_1=0;
        dem_1=0;
        p1=0;
        p=0;
    }
if (relay==1)
    {
        Role=1;
        dem_2++;
    }           
if (dem_2==1000)
    {
        Role=0;
        dem_2=0;
        relay=0;
    }
}

#define ADC_VREF_TYPE ((0<<REFS1) | (0<<REFS0) | (0<<ADLAR))

// Read the AD conversion result
unsigned int read_adc(unsigned char adc_input)
{
ADMUX=adc_input | ADC_VREF_TYPE;
// Delay needed for the stabilization of the ADC input voltage
delay_us(10);
// Start the AD conversion
ADCSRA|=(1<<ADSC);
// Wait for the AD conversion to complete
while ((ADCSRA & (1<<ADIF))==0);
ADCSRA|=(1<<ADIF);
return ADCW;
}
void init_system()
{
DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (1<<DDA4) | (1<<DDA3) | (1<<DDA2) | (0<<DDA1) | (0<<DDA0);
PORTA=(1<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);

DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);

DDRC=(1<<DDC7) | (1<<DDC6) | (0<<DDC5) | (1<<DDC4) | (0<<DDC3) | (1<<DDC2) | (1<<DDC1) | (0<<DDC0);
PORTC=(1<<PORTC7) | (1<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (1<<PORTC2) | (1<<PORTC1) | (1<<PORTC0);

DDRD=(0<<DDD7) | (1<<DDD6) | (1<<DDD5) | (1<<DDD4) | (1<<DDD3) | (0<<DDD2) | (1<<DDD1) | (0<<DDD0);
PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 7.813 kHz
// Mode: Normal top=0xFF
// OC0 output: Disconnected
// Timer Period: 9.984 ms
TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (1<<CS02) | (0<<CS01) | (1<<CS00);
TCNT0=0xB2;
OCR0=0x00;

TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (1<<TOIE0);



// ADC initialization
// ADC Clock frequency: 1000.000 kHz
// ADC Voltage Reference: AREF pin
// ADC Auto Trigger Source: ADC Stopped
ADMUX=ADC_VREF_TYPE;
ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (1<<ADPS1) | (1<<ADPS0);
SFIOR=(0<<ADTS2) | (0<<ADTS1) | (0<<ADTS0);
#asm("sei")

}
