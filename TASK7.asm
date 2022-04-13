;TASK 7 BY MOHAMAD SAAB
.INCLUDE "m328pdef.inc"
.ORG 0X0000
	RJMP init
.ORG 0X0020
	RJMP mytimer_interrupt  ;0x0020 is the program address of timer0 overflow
init:
;;first is initialization related to keyboard
;rows are output sbi and columns are inputs cbi
SBI	DDRD,7 ;OUTPUTS 7--->4
SBI	DDRD,6
SBI	DDRD,5
SBI	DDRD,4
CBI DDRD,3 ;INPUTS 3--->0
CBI DDRD,2
CBI DDRD,1
CBI DDRD,0
;activate pull up resistors for inputs 3--->0 
SBI	PORTD,3
SBI	PORTD,2
SBI	PORTD,1
SBI	PORTD,0

;;Now initialization for everything other than the keyboard
init2:
;HERE INITIALIZING LEDS PC2 AND PC3 TO OUTPUTS AND OFF.
SBI	DDRC,2
SBI	PORTC,2
SBI	DDRC,3
SBI PORTC,3
;HERE INITIALIZING THE BUZZER AT PB1 TO OUTPUT AND OFF.
SBI DDRB,1 ; PORTB 1 IS OUTPUT
CBI PORTB,1 ;TURN OFF INITIALLY
CLI ; global interrupt DISABLE ---> CLI , IF WANT TO ENABLE ----> SEI
LDI R16,0X04
OUT TCCR0B,R16 ;SET UP THE TIMER0 PRESCALAR TO 256
LDI R17,0X01
STS TIMSK0,R17 ; set the first bit of this register so that we enable timer0 overflow interrupt
;OUT TIMSK0,R17 did not work NEITHER DID MOV TIMSK0,R17
LDI R18,0xB9 ; TCNTinit = 185 with a prescalar 256 for a frequency of 880hz (440hz buzzer frequency)
OUT TCNT0,R18

;;;;;;;;;;;;;;;;;;;;;;;;;;;Here I start scanning the keyboard


;start step1 iterate over columns 3 to 0 while grounding output 7.
step1:
nop
CBI	PORTD,7
SBI	PORTD,6 
SBI	PORTD,5 
SBI	PORTD,4  
SBIS PIND,3
RJMP SW1_BUTTON7
SBIS PIND,2
RJMP SW2_BUTTON8
SBIS PIND,1
RJMP SW3_BUTTON9
SBIS PIND,0
RJMP SW4_BUTTONF
;start step2 iterate over columns 3 to 0 while grounding output 6.
step2:
nop
SBI	PORTD,7
CBI	PORTD,6 
SBI	PORTD,5 
SBI	PORTD,4
SBIS PIND,3
RJMP SW5_BUTTON4
SBIS PIND,2
RJMP SW6_BUTTON5
SBIS PIND,1
RJMP SW7_BUTTON6
SBIS PIND,0
RJMP SW8_BUTTONE
;start step3 iterate over columns 3 to 0 while grounding output 5.
step3:
nop
SBI	PORTD,7
SBI	PORTD,6 
CBI	PORTD,5 
SBI	PORTD,4
SBIS PIND,3
RJMP SW9_BUTTON1
SBIS PIND,2
RJMP SW10_BUTTON2
SBIS PIND,1
RJMP SW11_BUTTON3
SBIS PIND,0
RJMP SW12_BUTTOND
;start step4 iterate over columns 3 to 0 while grounding output 4.
step4:
nop
SBI	PORTD,7
SBI	PORTD,6 
SBI	PORTD,5 
CBI	PORTD,4
SBIS PIND,3
RJMP SW13_BUTTONA
SBIS PIND,2
RJMP SW14_BUTTON0
SBIS PIND,1
RJMP SW15_BUTTONB
SBIS PIND,0
RJMP SW16_BUTTONC
RJMP init2


;;;;;;;;;;;;;;;;;;;;;;;;;;;Here finished scanning keyboard.
;;Button 7: Two leds on
;;Button 8: Bottom led on
;;Button 4: Top Led on
;;All other buttons: Buzzer on
;;No buttons pressed: Leds and buzzer off
;;;;;;;;;;;;;;;;;;;;;;;;;;;

SW1_BUTTON7:
CBI	PORTC,2
CBI PORTC,3
RJMP init2

SW2_BUTTON8:
CBI	PORTC,3
RJMP init2

SW5_BUTTON4:
CBI PORTC,2
RJMP init2

SW3_BUTTON9:
SW4_BUTTONF:
SW6_BUTTON5:
SW7_BUTTON6:
SW8_BUTTONE:
SW9_BUTTON1:
SW10_BUTTON2:
SW11_BUTTON3:
SW12_BUTTOND:
SW13_BUTTONA:
SW14_BUTTON0:
SW15_BUTTONB:
SW16_BUTTONC:
TURNON_BUZZER:
SEI
RJMP step1

mytimer_interrupt :
OUT TCNT0,R18
SBI PINB,1
RETI  
