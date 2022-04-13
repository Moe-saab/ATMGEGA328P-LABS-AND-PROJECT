; smartmicrocontroller.asm
; Created: 18/02/2022 11:34:34
; Author : mohamad saab , rayan makhoul
; This program turns on led PC2 when PB2 is pressed
;The LED is connected to pin PC2, which is bit 2 of  the 8-bit register PORTC.
;The Joystick switch is connected to pin PB2, which is bit 2 of the 8-bit register PORTB
.INCLUDE "m328pdef.inc" 
.ORG 0x0000
	RJMP init 

init:
CBI DDRB,2 ; Pin PB2 is an input // Clear Bit in I/O register DDRB is register that decides if bits of portb are input or output
SBI PORTB,2 ; Enable the pull-up resistor to avoid floating //Set Bit in I/O register
SBI DDRC,2 ; Pin PC2 is an output // Set Bit in I/O register DDRC is register that decides if bits of portc are input or output
SBI PORTC,2 ; Output Vcc => LED1 is turned off!


main:
IN R2,PINB ; Get value of PINB into register R2
BST R2,2 ; Copy PB2 (bit 2 of PINB) to the T flag // Bit Store from register to T flag

; The joystick is pressed if the T flag is cleared
BRTC JoyPressed ; Branch if the T flag is cleared


JoyNotPressed:
SBI PORTC,2 ; Turn off LED1
RJMP main ; Create an infinite loop


JoyPressed:
CBI PORTC,2 ; Turn on LED1
RJMP main ; Create an infinite loop
 
