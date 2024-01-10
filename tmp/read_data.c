  RF_Mode_RX();                       
            if(IRQ == 0){ 
                RF_Read_RX_3(); 
                if(station_receive.flag == count){
                    
                    if(station_receive.sm < 10){
                        PORTB.3 = 0;
                        delay_ms(3500);
                    }               
                    else{
                        PORTB.3 = 1;
                    }
                    delay_ms(800);
                    count++;   
                    if(count == 5)
                        count = 1; 
                }   
            }
        } 
}
//--------------------------
void node_info_examine(station_info station_receive) {
if ((station_receive.light < 70)&&(station_receive.sm < 20)) {
		switch (station_receive.flag) {
			case 1:
	            relay_1                 =   ON;
	            node[1].status          =   ON;
	            node[1].alarm_time_m    =   1;
        	break;
	        case 2:
	            relay_2                 =   ON;
	            node[2].status          =   ON;
	            node[2].alarm_time_m    =   1;
	        break;
	        case 3:
	            relay_3                 =   ON;
	            node[3].status          =   ON;
	            node[3].alarm_time_m    =   1;
	        break;
	        case 4:
	            relay_4                 =   ON;
	            node[4].status          =   ON;
	            node[4].alarm_time_m    =   1;
	        break;
	        case 5:
	            relay_5                 =   ON;
	            node[5].status          =   ON;
	            node[5].alarm_time_m    =   1;
	        break; 
		}
	}
}
