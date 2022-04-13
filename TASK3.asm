; task 3 is to blink a led using nested loops to create a delay instead of using timer which is later explained
;Author : mohamad saab
.INCLUDE "m328pdef.inc" 
.ORG 0x0000
	RJMP init 
init:
SBI DDRC,3 ; PORTC 3 IS OUTPUT
CBI PORTC,3 

main:
SBI PINC,3

LDI R16,0XBB
LOOP1:
LDI R17,0XBB
LOOP2:
LDI R18,0XBB
LOOP3:
DEC R18
BRNE LOOP3
DEC R17
BRNE LOOP2
DEC R16
BRNE LOOP1
RJMP main
