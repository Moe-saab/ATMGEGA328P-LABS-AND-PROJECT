;;task 8 ===> in this program I just test how to light up the leds with random pattern 
;Author : mohamad saab
.INCLUDE "m328pdef.inc"
.ORG 0X0000
	RJMP init

init:
SBI DDRB,3        ;;pin pb3 output
CBI PORTB,3       
SBI DDRB,4     ;;pin pb4 output
CBI PORTB,4          
SBI DDRB,5         ;;pin pb5 output
CBI PORTB,5  

main:
LDI R16,0x50 ;;80 times loop, 80 IN HEXA IS 0X50
LOOP1:
SBI PORTB,3 ;;WANT TO TURN ON ALL LEDS SO EACH TIME SET THE PB3 IN LOOP
CBI PORTB,5
SBI PORTB,5
DEC R16
BRNE LOOP1

LOOP2:
LDI R17,0x08
LDI R18,0b00011101
ROL_LOOP:
CBI PORTB,3
ROL R18
BRCC ZEROCARRY
SBI PORTB,3 ;;CARRY NOT ZERO
ZEROCARRY: CBI PORTB,5
		   SBI PORTB,5
DEC R17
BRNE ROL_LOOP


CBI PORTB,4
SBI PORTB,4
CBI PORTB,4



RJMP main
