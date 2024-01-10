
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega32A
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : float, width, precision
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 512 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega32A
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x085F
	.EQU __DSTACK_SIZE=0x0200
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _p=R5
	.DEF _p1=R4
	.DEF _relay=R7
	.DEF _dem=R8
	.DEF _dem_msb=R9
	.DEF _dem_1=R10
	.DEF _dem_1_msb=R11
	.DEF _dem_2=R12
	.DEF _dem_2_msb=R13
	.DEF _Send_Add=R6

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer0_ovf_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0

_0x2000000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0
_0x2080060:
	.DB  0x1
_0x2080000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x0A
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x01
	.DW  __seed_G104
	.DW  _0x2080060*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x260

	.CSEG
;#include <mega32a.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <stdio.h>
;#include <delay.h>
;#include <define.c>
;
;#define servo_1    PORTB.1
;#define servo_2    PORTB.2
;#define servo_3    PORTB.4
;#define servo_4    PORTD.0
;#define Role    PORTD.1
;#define Led_1    PORTD.3
;#define Led_2    PORTD.6
;
;#define tiemcan_1    PORTA.1
;#define tiemcan_2    PORTA.0
;#define tiemcan_3    PORTB.0
;
;#define CE PORTC.2
;#define CSN PORTC.6
;#define SCK PORTC.1
;#define MOSI PORTC.7
;#define MISO PINC.0
;#define IRQ PINA.7
;
;unsigned char p=0, p1=0, relay=0;
;
;unsigned int dem=0, dem_1=0, dem_2=0;
;unsigned int light, soil, temp;
;
;
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 0004 {

	.CSEG
_timer0_ovf_isr:
; .FSTART _timer0_ovf_isr
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
;TCNT0=0xB2; //10ms
	LDI  R30,LOW(178)
	OUT  0x32,R30
;if(p==1)
	LDI  R30,LOW(1)
	CP   R30,R5
	BRNE _0x3
;        {
;            Led_1=1;
	SBI  0x12,3
;            dem++;
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
;        }
;if(dem==500)
_0x3:
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	CP   R30,R8
	CPC  R31,R9
	BRNE _0x6
;        {
;            Led_1=0;
	CBI  0x12,3
;            dem=0;
	CLR  R8
	CLR  R9
;            p=0;
	CLR  R5
;        }
;if (p1==1)
_0x6:
	LDI  R30,LOW(1)
	CP   R30,R4
	BRNE _0x9
;    {
;        p=1;
	MOV  R5,R30
;        Led_1=1;
	SBI  0x12,3
;        Led_2=1;
	SBI  0x12,6
;        dem_1++;
	MOVW R30,R10
	ADIW R30,1
	MOVW R10,R30
;    }
;if (dem_1==500)
_0x9:
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	CP   R30,R10
	CPC  R31,R11
	BRNE _0xE
;    {
;        Led_2=0;
	CBI  0x12,6
;        Led_1=0;
	CBI  0x12,3
;        dem_1=0;
	CLR  R10
	CLR  R11
;        p1=0;
	CLR  R4
;        p=0;
	CLR  R5
;    }
;if (relay==1)
_0xE:
	LDI  R30,LOW(1)
	CP   R30,R7
	BRNE _0x13
;    {
;        Role=1;
	SBI  0x12,1
;        dem_2++;
	MOVW R30,R12
	ADIW R30,1
	MOVW R12,R30
;    }
;if (dem_2==1000)
_0x13:
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CP   R30,R12
	CPC  R31,R13
	BRNE _0x16
;    {
;        Role=0;
	CBI  0x12,1
;        dem_2=0;
	CLR  R12
	CLR  R13
;        relay=0;
	CLR  R7
;    }
;}
_0x16:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
; .FEND
;
;#define ADC_VREF_TYPE ((0<<REFS1) | (0<<REFS0) | (0<<ADLAR))
;
;// Read the AD conversion result
;unsigned int read_adc(unsigned char adc_input)
;{
_read_adc:
; .FSTART _read_adc
;ADMUX=adc_input | ADC_VREF_TYPE;
	ST   -Y,R26
;	adc_input -> Y+0
	LD   R30,Y
	OUT  0x7,R30
;// Delay needed for the stabilization of the ADC input voltage
;delay_us(10);
	__DELAY_USB 27
;// Start the AD conversion
;ADCSRA|=(1<<ADSC);
	SBI  0x6,6
;// Wait for the AD conversion to complete
;while ((ADCSRA & (1<<ADIF))==0);
_0x19:
	SBIS 0x6,4
	RJMP _0x19
;ADCSRA|=(1<<ADIF);
	SBI  0x6,4
;return ADCW;
	IN   R30,0x4
	IN   R31,0x4+1
	RJMP _0x20A0003
;}
; .FEND
;void init_system()
;{
_init_system:
; .FSTART _init_system
;DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (1<<DDA4) | (1<<DDA3) | (1<<DDA2) | (0<<DDA1) | (0<<DDA0);
	LDI  R30,LOW(28)
	OUT  0x1A,R30
;PORTA=(1<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	LDI  R30,LOW(128)
	OUT  0x1B,R30
;
;DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
	LDI  R30,LOW(0)
	OUT  0x17,R30
;PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	OUT  0x18,R30
;
;DDRC=(1<<DDC7) | (1<<DDC6) | (0<<DDC5) | (1<<DDC4) | (0<<DDC3) | (1<<DDC2) | (1<<DDC1) | (0<<DDC0);
	LDI  R30,LOW(214)
	OUT  0x14,R30
;PORTC=(1<<PORTC7) | (1<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (1<<PORTC2) | (1<<PORTC1) | (1<<PORTC0);
	LDI  R30,LOW(199)
	OUT  0x15,R30
;
;DDRD=(0<<DDD7) | (1<<DDD6) | (1<<DDD5) | (1<<DDD4) | (1<<DDD3) | (0<<DDD2) | (1<<DDD1) | (0<<DDD0);
	LDI  R30,LOW(122)
	OUT  0x11,R30
;PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	LDI  R30,LOW(0)
	OUT  0x12,R30
;
;// Timer/Counter 0 initialization
;// Clock source: System Clock
;// Clock value: 7.813 kHz
;// Mode: Normal top=0xFF
;// OC0 output: Disconnected
;// Timer Period: 9.984 ms
;TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (1<<CS02) | (0<<CS01) | (1<<CS00);
	LDI  R30,LOW(5)
	OUT  0x33,R30
;TCNT0=0xB2;
	LDI  R30,LOW(178)
	OUT  0x32,R30
;OCR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x3C,R30
;
;TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (1<<TOIE0);
	LDI  R30,LOW(1)
	OUT  0x39,R30
;
;
;
;// ADC initialization
;// ADC Clock frequency: 1000.000 kHz
;// ADC Voltage Reference: AREF pin
;// ADC Auto Trigger Source: ADC Stopped
;ADMUX=ADC_VREF_TYPE;
	LDI  R30,LOW(0)
	OUT  0x7,R30
;ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (1<<ADPS1) | (1<<ADPS0);
	LDI  R30,LOW(131)
	OUT  0x6,R30
;SFIOR=(0<<ADTS2) | (0<<ADTS1) | (0<<ADTS0);
	LDI  R30,LOW(0)
	OUT  0x30,R30
;#asm("sei")
	sei
;
;}
	RET
; .FEND
;#include <rf.c>
;//HU?NG D?N G?I-NH?N ? DU?I CÙNG
;
;// SPI(nRF24L01) commands
;#define READ_REG        0x00  // Define read command to register
;#define WRITE_REG       0x20  // Define write command to register
;#define RD_RX_PLOAD     0x61  // Define RX payload register address
;#define WR_TX_PLOAD     0xA0  // Define TX payload register address
;#define FLUSH_TX        0xE1  // Define flush TX register command
;#define FLUSH_RX        0xE2  // Define flush RX register command
;#define REUSE_TX_PL     0xE3  // Define reuse TX payload register command
;#define NOP             0xFF  // Define No Operation, might be used to read status register
;//------------------------
;#define RX_DR    0x40
;#define TX_DS    0x20
;#define MAX_RT   0x10
;//-------------------------
;
;#define CONFIG          0x00  // 'Config' register address
;#define EN_AA           0x01  // 'Enable Auto Acknowledgment' register address
;#define EN_RXADDR       0x02  // 'Enabled RX addresses' register address
;#define SETUP_AW        0x03  // 'Setup address width' register address
;#define SETUP_RETR      0x04  // 'Setup Auto. Retrans' register address
;#define RF_CH           0x05  // 'RF channel' register address
;#define RF_SETUP        0x06  // 'RF setup' register address
;#define STATUS          0x07  // 'Status' register address
;#define OBSERVE_TX      0x08  // 'Observe TX' register address
;#define RPD              0x09  // 'Carrier Detect' register address
;#define RX_ADDR_P0      0x0A  // 'RX address pipe0' register address
;#define RX_ADDR_P1      0x0B  // 'RX address pipe1' register address
;#define RX_ADDR_P2      0x0C  // 'RX address pipe2' register address
;#define RX_ADDR_P3      0x0D  // 'RX address pipe3' register address
;#define RX_ADDR_P4      0x0E  // 'RX address pipe4' register address
;#define RX_ADDR_P5      0x0F  // 'RX address pipe5' register address
;#define TX_ADDR         0x10  // 'TX address' register address
;#define RX_PW_P0        0x11  // 'RX payload width, pipe0' register address
;#define RX_PW_P1        0x12  // 'RX payload width, pipe1' register address
;#define RX_PW_P2        0x13  // 'RX payload width, pipe2' register address
;#define RX_PW_P3        0x14  // 'RX payload width, pipe3' register address
;#define RX_PW_P4        0x15  // 'RX payload width, pipe4' register address
;#define RX_PW_P5        0x16  // 'RX payload width, pipe5' register address
;#define FIFO_STATUS     0x17  // 'FIFO Status Register' register address
;#define FEATURE         0x1D  // 'FEATURE' register address
;#define DYNPD           0x1C  // 'DYNAMIC PAYLOAD' register address
;/*----------------------
;M?i d?a ch? truy?n-nh?n g?m 5byte
;Ch? d? Multireceive thì 1 PRX có th? nh?n du?c cùng lúc t? 6 PTX khác nhau
;D? li?u s? trao d?i qua các Pipe, t? Pipe_0 d?n Pipe_5
;T? Pipe_2 tr? di, d?a ch? nh?n s? có 4 byte d?u gi?ng d?a ch? c?a Pipe_1
;
;? bên G?I
;PTX_0: 5byte (Address1)
;PTX_1: 5byte (Address2)
;PTX_2: 4byte (Address2) + 1 byte (Address3)
;PTX_3: 4byte (Address2) + 1 byte (Address4)
;PTX_4: 4byte (Address2) + 1 byte (Address5)
;PTX_5: 4byte (Address2) + 1 byte (Address6)
;
;? bên NH?N do ch? có 1 con nên ta quan tâm d?n d?a ch? các pipe nh?n khác nhau
;Pipe0_RX_Add: 5byte (Address1)
;Pipe1_RX_Add: 5byte (Address2)
;Pipe2_RX_Add: 4byte (Address2) + 1 byte (Address3)
;Pipe3_RX_Add: 4byte (Address2) + 1 byte (Address4)
;Pipe4_RX_Add: 4byte (Address2) + 1 byte (Address5)
;Pipe5_RX_Add: 4byte (Address2) + 1 byte (Address6)
;
;----------------------*/
;unsigned char Send_Add, Address1, Address2, Address3, Address4;
;/*-------SPI---------*/
;void SPI_Write(unsigned char Buff);
;unsigned char SPI_Read(void);
;void RF_Command(unsigned char command);
;void RF_Write(unsigned char Reg_Add, unsigned char Value);
;void RF_Write_Add(unsigned char Reg_Add, unsigned char Value);
;void Common_Config();
;/*-------TX_Mode---------*/
;void RF_Write_Add_TX_2(unsigned char Reg_Add, unsigned char Address, unsigned char Address2);
;void TX_Address(unsigned char Address);
;void TX_Address_2(unsigned char Address, unsigned char Address2);
;void TX_Mode();
;void TX_Config();
;void TX_Config_2();
;void TX_Send();
;/*-------RX_Mode---------*/
;void RF_Write_Add_RX_2(unsigned char Reg_Add, unsigned char Address, unsigned char Address2);
;void RX_Address(unsigned char Address_Pipe, unsigned char Address);
;void RX_Address_2(unsigned char Address_Pipe, unsigned char Address, unsigned char Address2);
;void RX_Mode();
;void RX_Config();
;void RX_Config_4();
;void RX_Read();
;
;
;
;/*----------------------
;C?u trúc d? li?u d?ng typedef s? chuy?n d? li?u struct trong m?ng station_info v?i
;các thu?c tính c?a struct bên trong và gán vào station_receiver cho bên nh?n ho?c
;station_send cho bên g?i.
;----------------------*/
;typedef struct{
;    int temp;
;    int humid;
;    int light;
;    int soil;
;}station_info;
;
;station_info station_receive;
;station_info station_send;
;/*----------------------
;Ðây là hàm ghi d? li?u vào SPI
;Do không dùng modul SPI c?ng trên các chân I/O c?a AVR
;Nên s? d?ng hàm này d? ghi d? li?u vào
;Ð?ng th?i d?c giá tr? mà SPI tr? v?, tham v?ng check du?c ACK
;----------------------*/
;void SPI_Write(unsigned char Buff){
; 0000 0005 void SPI_Write(unsigned char Buff){
_SPI_Write:
; .FSTART _SPI_Write
;    unsigned char bit_ctr;
;    for(bit_ctr=0;bit_ctr<8;bit_ctr++){
	ST   -Y,R26
	ST   -Y,R17
;	Buff -> Y+1
;	bit_ctr -> R17
	LDI  R17,LOW(0)
_0x1D:
	CPI  R17,8
	BRSH _0x1E
;        MOSI = (Buff & 0x80);
	LDD  R30,Y+1
	ANDI R30,LOW(0x80)
	BRNE _0x1F
	CBI  0x15,7
	RJMP _0x20
_0x1F:
	SBI  0x15,7
_0x20:
;        delay_us(5);
	__DELAY_USB 13
;        Buff = (Buff << 1);
	LDD  R30,Y+1
	LSL  R30
	STD  Y+1,R30
;        SCK = 1;
	SBI  0x15,1
;        delay_us(5);
	__DELAY_USB 13
;        Buff |= MISO;
	LDI  R30,0
	SBIC 0x13,0
	LDI  R30,1
	LDD  R26,Y+1
	OR   R30,R26
	STD  Y+1,R30
;        SCK = 0;
	CBI  0x15,1
;    }
	SUBI R17,-1
	RJMP _0x1D
_0x1E:
;}
	LDD  R17,Y+0
	RJMP _0x20A0005
; .FEND
;/*----------------------
;Ðây là hàm d?c d? li?u ra t? SPI
;Do không dùng modul SPI c?ng trên các chân I/O c?a AVR
;Nên s? d?ng hàm này d? d?c d? li?u ra
;----------------------*/
;unsigned char SPI_Read(void){
;    unsigned char Buff=0;
;    unsigned char bit_ctr;
;    for(bit_ctr=0;bit_ctr<8;bit_ctr++){
;	Buff -> R17
;	bit_ctr -> R16
;        delay_us(5);
;        Buff = (Buff << 1);
;        SCK = 1;
;        delay_us(5);
;        Buff |= MISO;
;        SCK = 0;
;    }
;    return(Buff);
;}
;/*----------------------
;RF_Command dùng d? ghi Command tr?c ti?p vào nRF24L01
;----------------------*/
;void RF_Command(unsigned char command){
_RF_Command:
; .FSTART _RF_Command
;    CSN=0;
	ST   -Y,R26
;	command -> Y+0
	CBI  0x15,6
;    SPI_Write(command);
	CALL SUBOPT_0x0
;    CSN=1;
;    delay_us(10);
;}
	RJMP _0x20A0003
; .FEND
;/*----------------------
;RF_Write dùng d? ghi d? li?u vào thanh ghi c?a nRF24L01
;----------------------*/
;void RF_Write(unsigned char Reg_Add, unsigned char Value){
_RF_Write:
; .FSTART _RF_Write
;    CSN=0;
	ST   -Y,R26
;	Reg_Add -> Y+1
;	Value -> Y+0
	CBI  0x15,6
;    SPI_Write(0b00100000|Reg_Add);
	LDD  R30,Y+1
	ORI  R30,0x20
	MOV  R26,R30
	RJMP _0x20A0004
;    SPI_Write(Value);
;    CSN=1;
;    delay_us(10);
;}
; .FEND
;/*----------------------
;RF_Write_Add dùng d? ghi d?a ch? cho nRF24L01
;L?nh này dùng du?c ? c? PTX và PRX vì truy?n nh?n 1-1
;? dây ghi cùng lúc 5 byte d?a ch? gi?ng h?t nhau vào cùng 1 thanh ghi
;Thu?ng dùng khi truy?n-nh?n 1-1
;----------------------*/
;void RF_Write_Add(unsigned char Reg_Add, unsigned char Value){
_RF_Write_Add:
; .FSTART _RF_Write_Add
;    CSN=0;
	ST   -Y,R26
;	Reg_Add -> Y+1
;	Value -> Y+0
	CBI  0x15,6
;    SPI_Write(0b00100000|Reg_Add);
	LDD  R30,Y+1
	ORI  R30,0x20
	MOV  R26,R30
	RCALL _SPI_Write
;    SPI_Write(Value);
	LD   R26,Y
	RCALL _SPI_Write
;    SPI_Write(Value);
	LD   R26,Y
	RCALL _SPI_Write
;    SPI_Write(Value);
	LD   R26,Y
	RCALL _SPI_Write
;    SPI_Write(Value);
	LD   R26,Y
_0x20A0004:
	RCALL _SPI_Write
;    SPI_Write(Value);
	CALL SUBOPT_0x0
;    CSN=1;
;    delay_us(10);
;}
_0x20A0005:
	ADIW R28,2
	RET
; .FEND
;/*----------------------
;RF_Write_Add_TX_2 dùng d? ghi d?a ch? TRUY?N cho nRF24L01 trong ch? d? Multireceive
;Khi g?i b?t d?u t? PTX_2 tr? di thì b?t bu?c 4byte d?a ch? sau ph?i gi?ng d?a ch?
;c?a PTX_1 nên ph?i ghi 4 byte d?a ch? sau theo Address2 (là d?a ch? c?a PTX_1)
;Chú ý: Address ? dây ng?m d?nh là d?a ch? c?a PTX_2...5
;----------------------*/
;void RF_Write_Add_TX_2(unsigned char Reg_Add, unsigned char Address, unsigned char Address2){
;    CSN=0;
;	Reg_Add -> Y+2
;	Address -> Y+1
;	Address2 -> Y+0
;    SPI_Write(0b00100000|Reg_Add);
;    SPI_Write(Address);
;    SPI_Write(Address2);
;    SPI_Write(Address2);
;    SPI_Write(Address2);
;    SPI_Write(Address2);
;    CSN=1;
;    delay_us(10);
;}
;/*----------------------
;RF_Write_Add_RX_2 dùng d? ghi d?a ch? NH?N cho nRF24L01 trong ch? d? Multireceive
;Khi g?i b?t d?u t? PTX_2 tr? di thì b?t bu?c 4byte d?a ch? sau ph?i gi?ng d?a ch?
;c?a PTX_1 nên ph?i ghi 4 byte d?a ch? sau theo Address2 (là d?a ch? c?a PTX_1)
;Chú ý: Address ? dây ng?m d?nh là d?a ch? c?a PTX_2...5
;Có l? do bên PTX Address du?c ghi vào d?u tiên nên ? PRX Address ph?i du?c ghi vào
;cu?i cùng. Theo logic truy?n - nh?n n?i ti?p
;----------------------*/
;void RF_Write_Add_RX_2(unsigned char Reg_Add, unsigned char Address, unsigned char Address2){
;    CSN=0;
;	Reg_Add -> Y+2
;	Address -> Y+1
;	Address2 -> Y+0
;    SPI_Write(0b00100000|Reg_Add);
;    SPI_Write(Address2);
;    SPI_Write(Address2);
;    SPI_Write(Address2);
;    SPI_Write(Address2);
;    SPI_Write(Address);
;    CSN=1;
;    delay_us(10);
;}
;/*----------------------
;TX_Address dùng d? ghi d?a ch? vào thanh ghi d?a ch? c?a PTX ? ch? d? truy?n nh?n 1-1
;ho?c ch? d? Multireceive thì ? các PTX_0 và PTX_1
;----------------------*/
;void TX_Address(unsigned char Address){
_TX_Address:
; .FSTART _TX_Address
;    CSN=0;
	ST   -Y,R26
;	Address -> Y+0
	CBI  0x15,6
;    RF_Write(SETUP_AW,0b00000011); //ghi vào d? r?ng d?a ch? -  5byte
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R26,LOW(3)
	RCALL _RF_Write
;    CSN=1;
	CALL SUBOPT_0x1
;    delay_us(10);
;    CSN=0;
;    RF_Write_Add(TX_ADDR, Address); //thanh ghi d?a ch? truy?n
	LDI  R30,LOW(16)
	ST   -Y,R30
	LDD  R26,Y+1
	RCALL _RF_Write_Add
;}
_0x20A0003:
	ADIW R28,1
	RET
; .FEND
;/*----------------------
;TX_Address_2 dùng d? ghi d?a ch? vào thanh ghi d?a ch? c?a PTX ? ch? d? Multireceive
;L?nh này b?t d?u ghi ? các PTX_2 tr? di d?n PTX_5
;Ð? r?ng d?a ch? cung là 5byte
;----------------------*/
;void TX_Address_2(unsigned char Address, unsigned char Address2){
;    CSN=0;
;	Address -> Y+1
;	Address2 -> Y+0
;    RF_Write(SETUP_AW,0b00000011);
;    CSN=1;
;    delay_us(10);
;    CSN=0;
;    RF_Write_Add_TX_2(TX_ADDR, Address, Address2);
;}
;/*----------------------
;RX_Address dùng d? ghi d?a ch? vào thanh ghi d?a ch? c?a PRX ? ch? d? truy?n nh?n 1-1
;ho?c ch? d? Multireceive thì ? các Pipe_0 và Pipe_1
;Ð? r?ng d?a ch? là 5byte
;----------------------*/
;void RX_Address(unsigned char Address_Pipe, unsigned char Address){
;    CSN=0;
;	Address_Pipe -> Y+1
;	Address -> Y+0
;    RF_Write(SETUP_AW,0b00000011);
;    CSN=1;
;    delay_us(10);
;    CSN=0;
;    RF_Write_Add(Address_Pipe, Address);
;}
;/*----------------------
;RX_Address_2 dùng d? ghi d?a ch? vào thanh ghi d?a ch? c?a PRX ? ch? d? Multireceive
;L?nh này b?t d?u ghi ? các Pipe_2 tr? di d?n Pipe_5
;Ð? r?ng d?a ch? cung là 5byte
;Address2 ng?m hi?u là d?a ch? c?a pipe 1
;Address ng?m hi?u là d?a ch? c?a Pipe t? 2 - Pipe 5
;----------------------*/
;void RX_Address_2(unsigned char Address_Pipe, unsigned char Address, unsigned char Address2){
;    CSN=0;
;	Address_Pipe -> Y+2
;	Address -> Y+1
;	Address2 -> Y+0
;    RF_Write(SETUP_AW,0b00000011);
;    CSN=1;
;    delay_us(10);
;    CSN=0;
;    RF_Write_Add_RX_2(Address_Pipe, Address, Address2);  //ghi vao pipe number, d?a ch? và d?a ch? pipe 1
;}
;/*----------------------
;Config cho nRF24L01 ? ch? d? ho?t d?ng
;M?c d?nh là ch? d? truy?n d? li?u, thanh ghi CONFIG 0x1E
;Flush TX và RX d? xoá h?t d? li?u trong b? d?m
;----------------------*/
;void Common_Config(){
_Common_Config:
; .FSTART _Common_Config
;    CE=1;
	SBI  0x15,2
;    delay_us(700);
	__DELAY_USW 1400
;    CE=0;
	CBI  0x15,2
;    CSN=1;
	SBI  0x15,6
;    SCK=0;
	CBI  0x15,1
;    delay_us(100);
	__DELAY_USW 200
;    RF_Write(STATUS,0b01111110); //STATUS 0x7E; clear all IRQ flag
	CALL SUBOPT_0x2
;    RF_Command(0b11100010);    //0xE2; flush RX
	LDI  R26,LOW(226)
	RCALL _RF_Command
;    RF_Command(0b11100001);    //Flush TX 0xE1
	LDI  R26,LOW(225)
	RCALL _RF_Command
;    RF_Write(CONFIG,0b00011111); //0x1E; truy?n d? li?u
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(31)
	RCALL _RF_Write
;    delay_ms(2);
	LDI  R26,LOW(2)
	LDI  R27,0
	CALL _delay_ms
;    RF_Write(RF_CH,0b00000010); //RF_CH 0x05 Chanel 0 RF = 2400 + RF_CH* (1or 2 M)
	LDI  R30,LOW(5)
	ST   -Y,R30
	LDI  R26,LOW(2)
	RCALL _RF_Write
;    RF_Write(RF_SETUP,0b00000111); //RF_SETUP 0x07 = 1M, 0dBm
	LDI  R30,LOW(6)
	ST   -Y,R30
	LDI  R26,LOW(7)
	RCALL _RF_Write
;    RF_Write(FEATURE, 0b00000100); //0x1D Dynamic payload length
	LDI  R30,LOW(29)
	ST   -Y,R30
	LDI  R26,LOW(4)
	RCALL _RF_Write
;    RF_Write(EN_AA, 0b00000000); //0x1D Dynamic payload length
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RJMP _0x20A0002
;}
; .FEND
;/*----------------------
;Ðua nRF24L01 v? ch? d? truy?n d? li?u
;Lúc này c?n xoá h?t các thanh ghi trong IRQ và dua chân CE ? m?c th?p
;----------------------*/
;void TX_Mode(){
_TX_Mode:
; .FSTART _TX_Mode
;    CE=0;
	CBI  0x15,2
;    RF_Write(CONFIG,0b00011110);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(30)
	RCALL _RF_Write
;    delay_us(130);    //nrf can de khoi dong vao rx mode hoac txmode
	__DELAY_USW 260
;}
	RET
; .FEND
;/*----------------------
;Ðua nRF24L01 v? ch? d? nh?n d? li?u
;Lúc này c?n xoá h?t các thanh ghi trong IRQ và dua chân CE lên m?c cao
;----------------------*/
;void RX_Mode(){
;    RF_Write(CONFIG,0b00011111);
;    CE=1;
;    delay_us(130);    //nrf can de khoi dong vao rx mode hoac txmode
;}
;/*----------------------
;Config cho nRF24L01 ? ch? d? TRUY?N d? li?u 1-1 ho?c ch? d? Multireceive
;thì config cho các PTX_0 và PTX_1
;Xoá h?t d? li?u trong thanh ghi IRQ
;Flush h?t d? li?u ? b? d?m nh?n và truy?n.
;Cài d?t dynamic payload ? Pipe_0
;Enable Pipe_0 d? truy?n d? li?u
;----------------------*/
;void TX_Config(){
_TX_Config:
; .FSTART _TX_Config
;    RF_Write(STATUS,0b01111110); //xoá IRQ flag
	CALL SUBOPT_0x2
;    RF_Command(0b11100001); //Flush TX 0xE1
	LDI  R26,LOW(225)
	RCALL _RF_Command
;    TX_Address(Send_Add);   //Ghi d?a ch? g?i d? li?u vào nRF24L01
	MOV  R26,R6
	RCALL _TX_Address
;    RF_Write(DYNPD,0b00000001); //Ð?t ch? d? dynamic paypload ? pipe 0
	LDI  R30,LOW(28)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _RF_Write
;    RF_Write(EN_RXADDR,0b00000001); //Enable Pipe 0
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDI  R26,LOW(1)
_0x20A0002:
	RCALL _RF_Write
;}
	RET
; .FEND
;/*----------------------
;TX_Config_2()
;Config cho nRF24L01 ? ch? d? TRUY?N d? li?u Multireceive
;Dùng cho các PTX t? PTX_2 d?n PTX_5
;Xoá h?t d? li?u trong thanh ghi IRQ
;Flush h?t d? li?u ? b? d?m nh?n và truy?n.
;G?i di thì dùng Pipe_0 ? PTX nên ch? cài d?t dynamic payload ? Pipe_0
;Enable Pipe_0 d? truy?n d? li?u
;----------------------*/
;void TX_Config_2(){
;    RF_Write(STATUS,0b01111110); //xoá IRQ flag
;    RF_Command(0b11100001); //Flush TX 0xE1
;    TX_Address_2(Send_Add, Address2); //Ghi d?a ch? g?i d? li?u vào nRF24L01
;    RF_Write(DYNPD,0b00000001); //Ð?t ch? d? dynamic paypload ? pipe 0
;    RF_Write(EN_RXADDR,0b00000001); //Enable Pipe 0
;}
;/*----------------------
;RX_Config()
;Config cho nRF24L01 ? ch? d? NH?N d? li?u 1-1
;Xoá h?t d? li?u trong thanh ghi IRQ
;Flush h?t d? li?u ? b? d?m nh?n và truy?n.
;M? các Pipe t? 0 và cài d?t ch? d? dynamic payload
;? Pipe_0 d?a ch? du?c ghi vào theo 5 byte Address1
;----------------------*/
;void RX_Config(){
;    RF_Write(STATUS,0b01111110); //xoá IRQ flag
;    RF_Command(0b11100010); //Flush RX
;    RF_Write(DYNPD,0b00000001); //Ð?t ch? d? dynamic paypload ? pipe 0
;    RF_Write(EN_RXADDR,0b00000001); //Enable RX ? Pipe 0
;    RX_Address(RX_ADDR_P0, Address1);
;}
;/*----------------------
;RX_Config_4()
;Config cho nRF24L01 ? ch? d? NH?N d? li?u Multireceive (4 Pipe)
;Xoá h?t d? li?u trong thanh ghi IRQ
;Flush h?t d? li?u ? b? d?m nh?n và truy?n.
;M? các Pipe t? 0 d?n 4 và cài d?t ch? d? dynamic payload
;? Pipe_0 d?a ch? du?c ghi vào theo 5 byte Address1
;? Pipe_1 d?a ch? du?c ghi vào theo 5 byte Address2
;? Pipe_2 d?a ch? du?c ghi vào theo 4 byte Address2 và 1 byte Address3
;? Pipe_3 d?a ch? du?c ghi vào theo 4 byte Address2 và 1 byte Address4
;----------------------*/
;void RX_Config_4(){
;    RF_Write(STATUS,0b01111110); //xoá IRQ flag
;    RF_Command(0b11100010); //0xE2 = Flush RX
;    RF_Write(DYNPD,0b00001111); //Ð?t ch? d? dynamic paypload ? pipe 0-4
;    RF_Write(EN_RXADDR,0b00001111); //Enable RX ? Pipe 0 - pipe 4
;    RX_Address(RX_ADDR_P0, Address1);
;    RX_Address(RX_ADDR_P1, Address2);
;    RX_Address_2(RX_ADDR_P2, Address3, Address2);
;    RX_Address_2(RX_ADDR_P3, Address4, Address2);
;}
;/*----------------------
;RX_Config_6()
;Config cho nRF24L01 ? ch? d? NH?N d? li?u Multireceive (6 Pipe)
;Xoá h?t d? li?u trong thanh ghi IRQ
;Flush h?t d? li?u ? b? d?m nh?n và truy?n.
;M? các Pipe t? 0 d?n 4 và cài d?t ch? d? dynamic payload
;? Pipe_0 d?a ch? du?c ghi vào theo 5 byte Address1
;? Pipe_1 d?a ch? du?c ghi vào theo 5 byte Address2
;? Pipe_2 d?a ch? du?c ghi vào theo 4 byte Address2 và 1 byte Address3
;? Pipe_3 d?a ch? du?c ghi vào theo 4 byte Address2 và 1 byte Address4
;? Pipe_4 d?a ch? du?c ghi vào theo 4 byte Address2 và 1 byte Address5
;? Pipe_5 d?a ch? du?c ghi vào theo 4 byte Address2 và 1 byte Address6
;----------------------*/
;
;/*----------------------
;TX_Send()
;Config cho nRF24L01 ? ch? d? TRUY?N d? li?u ? ch? d? 1-1
;Ho?c Multireceive nhung ? các PTX_0 và PTX_1
;Xoá h?t d? li?u trong thanh ghi IRQ
;Flush h?t d? li?u ? b? d?m truy?n.
;Ghi d? li?u c?n g?i vào payload truy?n
;Sau khi truy?n di thì xoá h?t các IRQ
;Ghi d?a ch? g?i d? li?u vào nRF24L01 - KHÔNG HI?U CH? NÀY
;Sau khi g?i d? li?u di thì FLUSH h?t b? d?m G?I
;----------------------*/
;void TX_Send(){
_TX_Send:
; .FSTART _TX_Send
;    TX_Address(Send_Add); //Ghi d?a ch? g?i d? li?u vào nRF24L01
	MOV  R26,R6
	RCALL _TX_Address
;    CSN=1;
	CALL SUBOPT_0x1
;    delay_us(10);
;    CSN=0;
;    SPI_Write(0b11100001); //0xE1=Define flush TX register command
	LDI  R26,LOW(225)
	RCALL _SPI_Write
;    CSN=1;
	CALL SUBOPT_0x1
;    delay_us(10);
;    CSN=0;
;    SPI_Write(0b10100000); //0xA0 = Define TX payload register address
	LDI  R26,LOW(160)
	RCALL _SPI_Write
;    SPI_Write(station_send.temp); //ghi d? li?u vào payload
	LDS  R26,_station_send
	RCALL _SPI_Write
;    SPI_Write(station_send.humid);
	__GETB2MN _station_send,2
	RCALL _SPI_Write
;    SPI_Write(station_send.light);
	__GETB2MN _station_send,4
	RCALL _SPI_Write
;    SPI_Write(station_send.soil);
	__GETB2MN _station_send,6
	RCALL _SPI_Write
;    CSN=1;
	SBI  0x15,6
;    CE=1;
	SBI  0x15,2
;    delay_us(500);
	__DELAY_USW 1000
;    CE=0;
	CBI  0x15,2
;    RF_Write(0x07,0b01111110); //STATUS, 0x7E-clear IRQ flag (Tam test 0x70 van chay)
	CALL SUBOPT_0x2
;    TX_Address(Send_Add); //Ghi d?a ch? g?i d? li?u vào nRF24L01
	MOV  R26,R6
	RCALL _TX_Address
;    RF_Command(0b11100001);//Flush TX 0xE1
	LDI  R26,LOW(225)
	RCALL _RF_Command
;}
	RET
; .FEND
;/*----------------------
;TX_Send_2()
;Config cho nRF24L01 ? ch? d? TRUY?N d? li?u Multireceive t? PTX_2 và PTX_5
;Xoá h?t d? li?u trong thanh ghi IRQ
;Flush h?t d? li?u ? b? d?m truy?n.
;Ghi d? li?u c?n g?i vào payload truy?n
;Sau khi truy?n di thì xoá h?t các IRQ
;Ghi d?a ch? g?i d? li?u vào nRF24L01 - KHÔNG HI?U CH? NÀY
;Sau khi g?i d? li?u di thì FLUSH h?t b? d?m G?I
;----------------------*/
;
;/*----------------------
;RX_Read()
;Ð?c d? li?u t? buffer c?a b? NH?N d? li?u
;Ð?c t? b? d?m RX các giá tr? du?c luu vào khi nh?n du?c
;Sau khi d?c xong thì clear h?t các thanh ghi IRQ
;và Flush b? d?m nh?n
;----------------------*/
;void RX_Read(){
;    CE=0;
;    CSN=1;
;    delay_us(10);
;    CSN=0;
;    SPI_Write(0b01100001); //0x61 = Define RX payload register address
;    delay_us(10);
;    station_receive.temp = SPI_Read();
;    station_receive.humid = SPI_Read();
;    station_receive.light = SPI_Read();
;    station_receive.soil = SPI_Read();
;    CSN=1;
;    CE=1;
;    RF_Write(STATUS,0b01111110); // 0x7E-clear IRQ flag
;    RF_Command(0b11100010); //0xE2 = Flush RX
;}
;
;
;
;/*------------
;// Chuong trình g?i dành cho tr?m 1
;Send_Add = 0xA1;;  //Ðây chính là Send_Add lúc khai báo à ???
;Common_Config();
;TX_mode();
;TX_config();
;TX_send();
;
;// Chuong trình g?i dành cho tr?m 2
;Send_Add = 0xA2;
;Common_Config();
;TX_mode();
;TX_config();
;TX_send();
;
;// Chuong trình g?i dành cho tr?m 3
;Send_Add=0xA3;
;Address2=0xA2;
;Common_Config();
;TX_mode();
;TX_config_2();
;TX_send_2();
;
;// Chuong trình g?i dành cho tr?m 4
;Send_Add=0xA4;
;Address2=0xA2;
;Common_Config();
;TX_mode();
;TX_config_2();
;TX_send_2();
;// Chuong trình g?i dành cho tr?m 5
;Address2=0xA2;
;Address5=0xA5;
;Common_Config();
;TX_mode();
;TX_config_2();
;TX_send_2();
;// Chuong trình g?i dành cho tr?m 6
;Address2=0xA2;
;Address6=0xA6;
;Common_Config();
;TX_mode();
;TX_config_2();
;TX_send_2();
;// Chuong trình nh?n dành cho 4 tr?m
;Address1 = 0xA1;
;Address2 = 0xA2;
;Address3 = 0xA3;
;Address4 = 0xA4;
;Common_Config();
;RX_Mode();
;RX_Config_4();
;if(IRQ == 0){
;        RX_Read();
;            }
;// Chuong trình nh?n dành cho 6 tr?m
;Address1 = 0xA1;
;Address2 = 0xA2;
;Address3 = 0xA3;
;Address4 = 0xA4;
;Address5 = 0xA5;
;Address6 = 0xA6;
;Common_Config();
;RX_Mode();
;RX_Config_6();
;if(IRQ == 0){
;        RX_Read();
;            }
;--------------*/
;#include <dht11.c>
;//config DHT11
;#define         DHT_DATA_IN     PIND.2
;#define         DHT_DATA_OUT    PORTD.2
;#define         DHT_DDR_DATA    DDRD.2
;#define DHT_ER       0
;#define DHT_OK       1
;unsigned char dht_nhiet_do,dht_do_am;
;
;unsigned char DHT_GetTemHumi (unsigned char *tem, unsigned char *humi){
; 0000 0006 unsigned char DHT_GetTemHumi (unsigned char *tem, unsigned char *humi){
_DHT_GetTemHumi:
; .FSTART _DHT_GetTemHumi
;    unsigned char buffer[5]={0,0,0,0,0};
;    unsigned char ii,i,checksum;
;
;    DHT_DDR_DATA=1;   // set la cong ra
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,5
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	STD  Y+2,R30
	STD  Y+3,R30
	STD  Y+4,R30
	CALL __SAVELOCR4
;	*tem -> Y+11
;	*humi -> Y+9
;	buffer -> Y+4
;	ii -> R17
;	i -> R16
;	checksum -> R19
	SBI  0x11,2
;    DHT_DATA_OUT=1;
	SBI  0x12,2
;    delay_us(60);
	__DELAY_USB 160
;    DHT_DATA_OUT=0;
	CBI  0x12,2
;    delay_ms(25);
	LDI  R26,LOW(25)
	LDI  R27,0
	CALL _delay_ms
;    DHT_DATA_OUT=1;
	SBI  0x12,2
;    DHT_DDR_DATA=0;   //set la loi vao
	CBI  0x11,2
;    delay_us(60);
	__DELAY_USB 160
;    if(DHT_DATA_IN){
	SBIS 0x10,2
	RJMP _0x86
;        return DHT_ER ;
	LDI  R30,LOW(0)
	RJMP _0x20A0001
;    }
;    else while(!(DHT_DATA_IN));    //Doi DaTa len 1
_0x86:
_0x88:
	SBIS 0x10,2
	RJMP _0x88
;    delay_us(60);
	__DELAY_USB 160
;    if(!DHT_DATA_IN){
	SBIC 0x10,2
	RJMP _0x8B
;        return DHT_ER;
	LDI  R30,LOW(0)
	RJMP _0x20A0001
;    }
;    else while((DHT_DATA_IN));     //Doi Data ve 0
_0x8B:
_0x8D:
	SBIC 0x10,2
	RJMP _0x8D
;    //Bat dau doc du lieu
;    for(i=0;i<5;i++)
	LDI  R16,LOW(0)
_0x91:
	CPI  R16,5
	BRSH _0x92
;    {
;        for(ii=0;ii<8;ii++)
	LDI  R17,LOW(0)
_0x94:
	CPI  R17,8
	BRSH _0x95
;        {
;        while((!DHT_DATA_IN));//Doi Data len 1
_0x96:
	SBIS 0x10,2
	RJMP _0x96
;        delay_us(50);
	__DELAY_USB 133
;        if(DHT_DATA_IN)
	SBIS 0x10,2
	RJMP _0x99
;            {
;            buffer[i]|=(1<<(7-ii));  //lay 7bit du lieu gui ve
	MOV  R30,R16
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,4
	ADD  R30,R26
	ADC  R31,R27
	MOVW R22,R30
	LD   R1,Z
	LDI  R30,LOW(7)
	SUB  R30,R17
	LDI  R26,LOW(1)
	CALL __LSLB12
	OR   R30,R1
	MOVW R26,R22
	ST   X,R30
;            while((DHT_DATA_IN));//Doi Data xuong 0
_0x9A:
	SBIC 0x10,2
	RJMP _0x9A
;            }
;        }
_0x99:
	SUBI R17,-1
	RJMP _0x94
_0x95:
;    }
	SUBI R16,-1
	RJMP _0x91
_0x92:
;    //Tinh toan check sum
;    checksum=buffer[0]+buffer[1]+buffer[2]+buffer[3];
	LDD  R30,Y+5
	LDD  R26,Y+4
	ADD  R30,R26
	LDD  R26,Y+6
	ADD  R30,R26
	LDD  R26,Y+7
	ADD  R30,R26
	MOV  R19,R30
;    //Kiem tra check sum
;    if((checksum)!=buffer[4]){
	LDD  R30,Y+8
	CP   R30,R19
	BREQ _0x9D
;        return DHT_ER;
	LDI  R30,LOW(0)
	RJMP _0x20A0001
;    }
;    //Lay du lieu
;    *tem  =   buffer[2];
_0x9D:
	LDD  R30,Y+6
	LDD  R26,Y+11
	LDD  R27,Y+11+1
	ST   X,R30
;    *humi =   buffer[0];
	LDD  R30,Y+4
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ST   X,R30
;    return DHT_OK;
	LDI  R30,LOW(1)
_0x20A0001:
	CALL __LOADLOCR4
	ADIW R28,13
	RET
;}
; .FEND
;#include <light.c>
;station_info station_send;
;
;void main(void)
; 0000 000B {
_main:
; .FSTART _main
; 0000 000C Send_Add = 0xA1;
	LDI  R30,LOW(161)
	MOV  R6,R30
; 0000 000D 
; 0000 000E init_system();
	RCALL _init_system
; 0000 000F #asm("sei");
	sei
; 0000 0010 Common_Config();
	RCALL _Common_Config
; 0000 0011 TX_Mode();
	RCALL _TX_Mode
; 0000 0012 TX_Config();
	RCALL _TX_Config
; 0000 0013 while (1)
_0x9E:
; 0000 0014       {
; 0000 0015             light = read_adc(1)/6;
	LDI  R26,LOW(1)
	RCALL _read_adc
	MOVW R26,R30
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	CALL __DIVW21U
	STS  _light,R30
	STS  _light+1,R31
; 0000 0016             soil  = read_adc(0)/10;
	LDI  R26,LOW(0)
	RCALL _read_adc
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	STS  _soil,R30
	STS  _soil+1,R31
; 0000 0017             if (light >=99)
	CALL SUBOPT_0x3
	CPI  R26,LOW(0x63)
	LDI  R30,HIGH(0x63)
	CPC  R27,R30
	BRLO _0xA1
; 0000 0018                 {
; 0000 0019                     light =90;
	LDI  R30,LOW(90)
	LDI  R31,HIGH(90)
	STS  _light,R30
	STS  _light+1,R31
; 0000 001A                 }
; 0000 001B             if ((light > 30)&(light<=40))
_0xA1:
	CALL SUBOPT_0x3
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	CALL __GTW12U
	MOV  R0,R30
	CALL SUBOPT_0x3
	LDI  R30,LOW(40)
	LDI  R31,HIGH(40)
	CALL __LEW12U
	AND  R30,R0
	BREQ _0xA2
; 0000 001C                 {
; 0000 001D                     p=1;
	LDI  R30,LOW(1)
	MOV  R5,R30
; 0000 001E                 }
; 0000 001F             if (light > 55)
_0xA2:
	CALL SUBOPT_0x3
	SBIW R26,56
	BRLO _0xA3
; 0000 0020                 {
; 0000 0021                     p1=1;
	LDI  R30,LOW(1)
	MOV  R4,R30
; 0000 0022                 }
; 0000 0023            if( DHT_GetTemHumi(&dht_nhiet_do,&dht_do_am))
_0xA3:
	LDI  R30,LOW(_dht_nhiet_do)
	LDI  R31,HIGH(_dht_nhiet_do)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_dht_do_am)
	LDI  R27,HIGH(_dht_do_am)
	RCALL _DHT_GetTemHumi
	CPI  R30,0
	BREQ _0xA4
; 0000 0024            temp = (unsigned int)dht_nhiet_do;
	LDS  R30,_dht_nhiet_do
	LDI  R31,0
	STS  _temp,R30
	STS  _temp+1,R31
; 0000 0025            if (temp >=33)
_0xA4:
	LDS  R26,_temp
	LDS  R27,_temp+1
	SBIW R26,33
	BRLO _0xA5
; 0000 0026                 {
; 0000 0027                     relay=1;
	LDI  R30,LOW(1)
	MOV  R7,R30
; 0000 0028                 }
; 0000 0029            if (soil >=90)
_0xA5:
	LDS  R26,_soil
	LDS  R27,_soil+1
	CPI  R26,LOW(0x5A)
	LDI  R30,HIGH(0x5A)
	CPC  R27,R30
	BRLO _0xA6
; 0000 002A                 {
; 0000 002B                     soil = 90;
	LDI  R30,LOW(90)
	LDI  R31,HIGH(90)
	STS  _soil,R30
	STS  _soil+1,R31
; 0000 002C                 }
; 0000 002D             station_send.temp = (unsigned int)dht_nhiet_do;
_0xA6:
	LDS  R30,_dht_nhiet_do
	LDI  R31,0
	STS  _station_send,R30
	STS  _station_send+1,R31
; 0000 002E             station_send.humid = (unsigned int)dht_do_am;
	LDS  R30,_dht_do_am
	LDI  R31,0
	__PUTW1MN _station_send,2
; 0000 002F             station_send.light = light;
	LDS  R30,_light
	LDS  R31,_light+1
	__PUTW1MN _station_send,4
; 0000 0030             station_send.soil =  90-soil;
	LDS  R26,_soil
	LDS  R27,_soil+1
	LDI  R30,LOW(90)
	LDI  R31,HIGH(90)
	SUB  R30,R26
	SBC  R31,R27
	__PUTW1MN _station_send,6
; 0000 0031             TX_Send();
	RCALL _TX_Send
; 0000 0032             delay_ms(200);
	LDI  R26,LOW(200)
	LDI  R27,0
	CALL _delay_ms
; 0000 0033       }
	RJMP _0x9E
; 0000 0034 
; 0000 0035 }
_0xA7:
	RJMP _0xA7
; .FEND
;
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG

	.CSEG

	.CSEG

	.CSEG

	.CSEG

	.DSEG

	.CSEG

	.DSEG
_light:
	.BYTE 0x2
_soil:
	.BYTE 0x2
_temp:
	.BYTE 0x2
_Address1:
	.BYTE 0x1
_Address2:
	.BYTE 0x1
_Address3:
	.BYTE 0x1
_Address4:
	.BYTE 0x1
_station_receive:
	.BYTE 0x8
_station_send:
	.BYTE 0x8
_dht_nhiet_do:
	.BYTE 0x1
_dht_do_am:
	.BYTE 0x1
__seed_G104:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x0:
	LD   R26,Y
	CALL _SPI_Write
	SBI  0x15,6
	__DELAY_USB 27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1:
	SBI  0x15,6
	__DELAY_USB 27
	CBI  0x15,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2:
	LDI  R30,LOW(7)
	ST   -Y,R30
	LDI  R26,LOW(126)
	JMP  _RF_Write

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3:
	LDS  R26,_light
	LDS  R27,_light+1
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

	.equ __w1_port=0x15
	.equ __w1_bit=0x05

__LSLB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSLB12R
__LSLB12L:
	LSL  R30
	DEC  R0
	BRNE __LSLB12L
__LSLB12R:
	RET

__LEW12U:
	CP   R30,R26
	CPC  R31,R27
	LDI  R30,1
	BRSH __LEW12UT
	CLR  R30
__LEW12UT:
	RET

__GTW12U:
	CP   R30,R26
	CPC  R31,R27
	LDI  R30,1
	BRLO __GTW12UT
	CLR  R30
__GTW12UT:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
