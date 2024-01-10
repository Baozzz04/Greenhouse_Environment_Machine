/****************************************************************************
Font created by the LCD Vision V1.05 font & image editor/converter
(C) Copyright 2011-2013 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Font name: New font
Fixed font width: 6 pixels
Font height: 10 pixels
First character: 0x4C
Last character: 0x4D

Exported font data size:
24 bytes for displays organized as horizontal rows of bytes
28 bytes for displays organized as rows of vertical bytes.
****************************************************************************/

flash unsigned char new_font[]=
{
0x06, /* Fixed font width */
0x0A, /* Font height */
0x4C, /* First character */
0x02, /* Number of characters in font */

#ifndef _GLCD_DATA_BYTEY_
/* Font data for displays organized as
   horizontal rows of bytes */

/* Code: 0x4C, ASCII Character: 'L' */
0x03, 0x03, 0x03, 0x03, 0x03, 0x03, 0x03, 0x03, 
0x3F, 0x3F, 

/* Code: 0x4D, ASCII Character: 'M' */
0x33, 0x33, 0x33, 0x33, 0x3F, 0x3F, 0x33, 0x33, 
0x33, 0x33, 

#else
/* Font data for displays organized as
   rows of vertical bytes */

/* Code: 0x4C, ASCII Character: 'L' */
0xFF, 0xFF, 0x00, 0x00, 0x00, 0x00, 0x03, 0x03, 
0x03, 0x03, 0x03, 0x03, 

/* Code: 0x4D, ASCII Character: 'M' */
0xFF, 0xFF, 0x30, 0x30, 0xFF, 0xFF, 0x03, 0x03, 
0x00, 0x00, 0x03, 0x03, 

#endif
};

