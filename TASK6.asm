;task 6 Sound the buzzer at a frequency of 440Hz or 880Hz depending on the state of the switch
;Author : mohamad saab
.INCLUDE "m328pdef.inc"
.ORG 0X0000
	RJMP INIT
.ORG 0X0020
	RJMP MYTIMER0_INTERRUPT
INIT:
SBI DDRB,1
SBI PORTB,1
CBI DDRB,0
SBI PORTB,0 ;PULLUP RESISTOR

SEI ; ENABLE GLOBAL INTERRUPT

LDI R16,0X04
OUT TCCR0B,R16 ;SET THE PRESCALAR

LDI R17,0X01
STS TIMSK0,R17 ;ENABLE TIMER0 OVERFLOW INTERRUPT

LDI R18,0XB9
OUT TCNT0,R18 ;TCNT0 initial

MAIN:
IN R19,PINB
BST R19,0
BRTC SWITCHOFF

SWITCHON:
LDI R18,0XB9
RJMP MAIN

SWITCHOFF:
LDI R18,0XDC
RJMP MAIN


MYTIMER0_INTERRUPT:
OUT TCNT0,R18
SBI PINB,1
RETI

