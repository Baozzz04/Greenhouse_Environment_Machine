void border()
{
    glcd_line(60,0, 60, 15);
    glcd_line(0, 15, 60, 15);
    glcd_line(0,0,84,0);
    glcd_line(84,0, 84, 48);
    glcd_line(0, 48, 84, 48);
    glcd_line(0, 0, 0, 48);
    glcd_moveto(3,3);
    glcd_outtext("Station:");
   // glcd_moveto(53, 3);
  //  glcd_outtext("3");
                    
    glcd_moveto(4, 18);
    glcd_outtext("pH  : ");
    glcd_moveto(4, 28);
    glcd_outtext("Sal : ");
    glcd_moveto(4, 37);
    glcd_outtext("Temp: ");
   // glcd_moveto(68, 18);
   // glcd_outtext("!C");    
    glcd_moveto(62, 28);
   // glcd_putchar(37);
    glcd_outtext("PPt"); 
    glcd_moveto(60, 37);
    glcd_outtext("!C");    
}
void display()
{
itoa(station_receive.flag, buff);
glcd_outtextxy(53,3,buff);                             
sprintf(buff, "%d ", station_receive.ph);
glcd_outtextxy(38,18,buff);
sprintf(buff, "%d ", station_receive.tds);
glcd_outtextxy(38,28,buff);
sprintf(buff, "%d ", station_receive.temp);
glcd_outtextxy(38,37,buff);  
delay_ms(1000);
}