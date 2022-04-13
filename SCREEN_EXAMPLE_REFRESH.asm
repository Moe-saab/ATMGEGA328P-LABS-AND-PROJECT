;Author : mohamad saab
;In this code I turn on all the leds in the screen but I do that with different refreshment rates that you can change
;in lines 41 and 155 for register R25
;The refreshing is important since to print certain character it will have different column patterns for each row so can't turn on all 
;rows at same time . Solution is to send the column pattern for each row alone and then jump to next row and put the next column patter and
;so on but at a speed enough for the eye to see a still screen.

.INCLUDE "m328pdef.inc"
.ORG 0X0000
	RJMP init
.ORG 0x0020
	RJMP saab_interrupt
init:
;pins b3,4,and 5 are used by the shift registers to latch data
SBI DDRB,3        ;;pin pb3 output
CBI PORTB,3       
SBI DDRB,4	      ;;pin pb4 output
CBI PORTB,4          
SBI DDRB,5        ;;pin pb5 output
CBI PORTB,5  

SEI				 ;global interrupt enable

LDI R22,0X05
OUT TCCR0B,R22 ;SET UP THE TIMER0 PRESCALAR TO 1024(I use the highest one possible to achieve lowest possible frequencies
			   ; pages 107_108

LDI R21,0X01
STS TIMSK0,R21 ; set the first bit of this register so that we enable timer0 overflow interrupt

LDI R20,0xCF    ; TCNTinit = 0XCF = 207 with a prescalar 1024 for a frequency of 318 Hz but this is not enough to see
OUT TCNT0,R20	; the refreshing with human eye and at same time it is almost the minimum frequency I can
				; let the timer have so will add a counter inside the interrupt that each 60 loops will let the
				; function in the interrupt be executed once, this way I will have almost 5.3 Hz refresh rate.
				;NOTE THAT THE VALUES I TOOK ARE RANDOM JUST WITH THE CONDITION TO HAVE ONE OF THE LOWEST FREQUENCIES
				;POSSIBLE, ALSO CAN USE TCNTinit = 0x01 FOR MINIMUM FREQUENCY (61.3 Hz) BUT I DIDN'T USE IT FOR SOME REASONS LATER


;Now here test several values for R25 which each time will increase refreshment speed by decreasing the 
;counter used in the interrupt ===> i.e it will let the function in interrupt execute sooner (after less ins and outs of the interrupt)
LDI R25,0X3C ;TRY 60 in hex 0X3C, this is the counter will be used in the interrupt as I just explained
			 ;TRY 30 IN HEX 1E
			 ;TRY 15 IN HEX 0X0F
			 ;TRY 5 IN HEX 0X05
			 ;TRY 1 IN HEX 0X01 AT THIS SPEED YOU STOP SEEING WITH THE NAKED EYE THE REFRESHING
			
			 ; DON'T FORGET ALSO TO CHANGE R25 IN LINE 155 ALSO !!!!!!!!!!!!!


LDI R27,0X07 ; will be used later in the interrupt to go through all the rows one at a time



main:
RJMP main ;infinite loop waiting for timer0 overflow to enter saab_interrupt







saab_interrupt:

DEC R25
BRNE exit ;so every 60 times I enter the interrupt only 1 time the function below is executed


;here I start sending the data for shift registers first the 80 columns bit then the 8(7+"1") rows bits
LDI R16,0x50 ;;80 IN HEXA IS 0X50
LOOP1:
SBI PORTB,3 ;;WANT TO TURN ON ALL LEDS SO EACH TIME SET THE PB3 IN LOOP
CBI PORTB,5
SBI PORTB,5
DEC R16
BRNE LOOP1


;now instead of sending  activation to all rows which will turn all leds I want to turn each row alone
;since later on when one wants to prints certain shape the column pattern for each row will be different
;but we should do this fast enough so we won't see flickering. I will make it slow just to see it first refreshing.


;put a counter R27 = 7 = number of rows and each time fill R18 ((which contains the data that will be sent the row shift register))
;according the counter value

CPI R27,0X07 ;COMPARING TO SEE AT THIS TIME WHAT IS THE VALUE OF R27
BREQ ROW7

CPI R27,0X06
BREQ ROW6

CPI R27,0X05
BREQ ROW5

CPI R27,0X04
BREQ ROW4

CPI R27,0X03
BREQ ROW3

CPI R27,0X02
BREQ ROW2

CPI R27,0X01
BREQ ROW1

ROW1:LDI R18,0b00000001
LDI R27,0X07
RJMP LOOP2

ROW2:LDI R18,0b00000010
DEC R27
RJMP LOOP2

ROW3:LDI R18,0b00000100
DEC R27
RJMP LOOP2

ROW4:LDI R18,0b00001000
DEC R27
RJMP LOOP2

ROW5:LDI R18,0b00010000
DEC R27
RJMP LOOP2

ROW6:LDI R18,0b00100000
DEC R27
RJMP LOOP2

ROW7:LDI R18,0b01000000
DEC R27


;IN THIS BLOCK I ENTER THE DATA TO TURN ON SOME ROW ACCRODING TO METHOD EXPLAINED IN PDF 'SCREEN TIPS AND TRICKS'
LOOP2:
LDI R17,0x08
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


LDI R25,0X3C

exit:
OUT TCNT0,R20
RETI
