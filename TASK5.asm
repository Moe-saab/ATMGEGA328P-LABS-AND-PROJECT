; task5_saab.asm // Sound the buzzer at a fixed frequency of 440Hz when the joystick is pressed.
;Author : mohamad saab
.INCLUDE "m328pdef.inc" 
.ORG 0x0000
	RJMP init
.ORG 0X0020 ; page 65 shows that 0x0020 is the program address of timer0 overflow
	RJMP saab_interrupt
init:
SBI DDRB,1 ; PORTB 1 IS OUTPUT
CBI PORTB,1 ;TURN OFF INITIALLY

SEI ; global interrupt enable 

LDI R16,0X04
OUT TCCR0B,R16 ;SET UP THE TIMER0 PRESCALAR TO 256 , pages 107_108

LDI R17,0X01
STS TIMSK0,R17 ; set the first bit of this register so that we enable timer0 overflow interrupt
;OUT TIMSK0,R17 did not work NEITHER DID MOV TIMSK0,R17

LDI R18,0xB9 ; TCNTinit = 185 with a prescalar 256 for a frequency of 880hz (440hz buzzer frequency)
OUT TCNT0,R18


main:
rjmp main

saab_interrupt :
OUT TCNT0,R18
SBI PINB,1
RETI  
