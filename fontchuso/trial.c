static const uint8_t Font_6x8[128-32] = {
  /* Index 32: Character ' ' */
  ...
  /* Index 48: Character '0' */
  0x0E, /* 00001110 */
  0x11, /* 00010001 */
  0x13, /* 00010011 */
  0x15, /* 00010101 */
  0x19, /* 00011001 */
  0x11, /* 00010001 */
  0x0E, /* 00001110 */
  0x00, /* 00000000 */
  ...
};
GLCD_FONT GLCD_Font_6x8 = {
  6,            /* Character width    */
  8,            /* Character height   */
  32,           /* Character offset   */
  128-32,       /* Character count    */
  Font_6x8      /* Characters bitmaps */
};


while (1)
      {     
             GLCD_SetFont(&GLCD_Font_6x8);
      }
}