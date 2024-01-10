/****************************************************************************
Font created by the LCD Vision V1.05 font & image editor/converter
(C) Copyright 2011-2013 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Font name: New font
Fixed font width: 6 pixels
Font height: 10 pixels
First character: 0x30
Last character: 0x3B

Exported font data size:
124 bytes for displays organized as horizontal rows of bytes
148 bytes for displays organized as rows of vertical bytes.
****************************************************************************/

flash unsigned char fontchinh[]=
{
0x06, /* Fixed font width */
0x0A, /* Font height */
0x30, /* First character */
0x0C, /* Number of characters in font */

#ifndef _GLCD_DATA_BYTEY_
/* Font data for displays organized as
   horizontal rows of bytes */

/* Code: 0x30, ASCII Character: '0' */
0x1E, 0x3F, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 
0x3F, 0x1E, 

/* Code: 0x31, ASCII Character: '1' */
0x0C, 0x0E, 0x0F, 0x0C, 0x0C, 0x0C, 0x0C, 0x0C, 
0x3F, 0x3F, 

/* Code: 0x32, ASCII Character: '2' */
0x1E, 0x3F, 0x33, 0x30, 0x38, 0x1C, 0x0E, 0x07, 
0x3F, 0x3F, 

/* Code: 0x33, ASCII Character: '3' */
0x1E, 0x3F, 0x33, 0x30, 0x3C, 0x3C, 0x30, 0x33, 
0x3F, 0x1E, 

/* Code: 0x34, ASCII Character: '4' */
0x03, 0x03, 0x33, 0x33, 0x33, 0x3F, 0x3F, 0x30, 
0x30, 0x30, 

/* Code: 0x35, ASCII Character: '5' */
0x3F, 0x3F, 0x03, 0x1F, 0x3F, 0x30, 0x30, 0x33, 
0x3F, 0x1E, 

/* Code: 0x36, ASCII Character: '6' */
0x1E, 0x3F, 0x33, 0x03, 0x1F, 0x3F, 0x33, 0x33, 
0x3F, 0x1E, 

/* Code: 0x37, ASCII Character: '7' */
0x3F, 0x3F, 0x30, 0x10, 0x18, 0x18, 0x0C, 0x0C, 
0x0C, 0x0C, 

/* Code: 0x38, ASCII Character: '8' */
0x1E, 0x3F, 0x33, 0x33, 0x3F, 0x3F, 0x33, 0x33, 
0x3F, 0x1E, 

/* Code: 0x39, ASCII Character: '9' */
0x1E, 0x3F, 0x33, 0x33, 0x3F, 0x3E, 0x30, 0x33, 
0x3F, 0x1E, 

/* Code: 0x3A, ASCII Character: ':' */
0x03, 0x03, 0x03, 0x03, 0x03, 0x03, 0x03, 0x03, 
0x3F, 0x3F, 

/* Code: 0x3B, ASCII Character: ';' */
0x33, 0x33, 0x33, 0x33, 0x3F, 0x3F, 0x33, 0x33, 
0x33, 0x33, 

#else
/* Font data for displays organized as
   rows of vertical bytes */

/* Code: 0x30, ASCII Character: '0' */
0xFE, 0xFF, 0x03, 0x03, 0xFF, 0xFE, 0x01, 0x03, 
0x03, 0x03, 0x03, 0x01, 

/* Code: 0x31, ASCII Character: '1' */
0x04, 0x06, 0xFF, 0xFF, 0x00, 0x00, 0x03, 0x03, 
0x03, 0x03, 0x03, 0x03, 

/* Code: 0x32, ASCII Character: '2' */
0x86, 0xC7, 0xE3, 0x73, 0x3F, 0x1E, 0x03, 0x03, 
0x03, 0x03, 0x03, 0x03, 

/* Code: 0x33, ASCII Character: '3' */
0x86, 0x87, 0x33, 0x33, 0xFF, 0xFE, 0x01, 0x03, 
0x03, 0x03, 0x03, 0x01, 

/* Code: 0x34, ASCII Character: '4' */
0x7F, 0x7F, 0x60, 0x60, 0xFC, 0xFC, 0x00, 0x00, 
0x00, 0x00, 0x03, 0x03, 

/* Code: 0x35, ASCII Character: '5' */
0x9F, 0x9F, 0x1B, 0x1B, 0xFB, 0xF3, 0x01, 0x03, 
0x03, 0x03, 0x03, 0x01, 

/* Code: 0x36, ASCII Character: '6' */
0xFE, 0xFF, 0x33, 0x33, 0xF7, 0xE6, 0x01, 0x03, 
0x03, 0x03, 0x03, 0x01, 

/* Code: 0x37, ASCII Character: '7' */
0x03, 0x03, 0xC3, 0xF3, 0x3F, 0x07, 0x00, 0x00, 
0x03, 0x03, 0x00, 0x00, 

/* Code: 0x38, ASCII Character: '8' */
0xFE, 0xFF, 0x33, 0x33, 0xFF, 0xFE, 0x01, 0x03, 
0x03, 0x03, 0x03, 0x01, 

/* Code: 0x39, ASCII Character: '9' */
0x9E, 0xBF, 0x33, 0x33, 0xFF, 0xFE, 0x01, 0x03, 
0x03, 0x03, 0x03, 0x01, 

/* Code: 0x3A, ASCII Character: ':' */
0xFF, 0xFF, 0x00, 0x00, 0x00, 0x00, 0x03, 0x03, 
0x03, 0x03, 0x03, 0x03, 

/* Code: 0x3B, ASCII Character: ';' */
0xFF, 0xFF, 0x30, 0x30, 0xFF, 0xFF, 0x03, 0x03, 
0x00, 0x00, 0x03, 0x03, 

#endif
};

