processor 16f877
include<p16f877.inc>

MOTOR_1_PARO		equ B'00000000'		;configuracion de ejemplo
MOTOR_2_PARO		equ B'00000000'		;es diferente para cada una
MOTOR_1_DER		equ B'00001100'		;conexi?n que se realice en
MOTOR_1_IZQ	equ B'00001000'		;el sistema fisico
MOTOR_2_DER		equ B'00000011'
MOTOR_2_IZQ	equ B'00000010'

  org 0h
  goto INICIO
  org 05h

INICIO:
       clrf PORTA	;limpia el puerto A
       bsf STATUS,RP0    
       bcf STATUS,RP1 	;cambia al banco 1 de RAM
       movlw 06h
       movwf ADCON1	;deshabilitamos el CAD y los pines de los puertos A y E ser?n digitales
       movlw 3fh
       movwf TRISA	;los pines del puerto a configurados como entradas
       clrf TRISB       ;pines de puerto B como salida
       bcf STATUS,RP0    ;regresa al banco 0
PRINCIPAL
	MOVF  PORTA,,W
	ANDLW B"00000111"
	ADDWF PCL,F
	GOTO MI_PARO_M2_PARO
	GOTO MI_DER_M2_DER
	GOTO MI_IZQ_M2_IZQ
	GOTO MI_DER_M2_IZQ
	GOTO MI_IZQ_M2_DER

MI_PARO_M2_PARO
	MOVLW MOTOR_1_PARO | MOTOR_2_PARO
	GOTO ENVIA

MI_DER_M2_DER
	MOVLW MOTOR_1_DER | MOTOR_2_DER
	GOTO ENVIA

MI_IZQ_M2_IZQ
	MOVLW MOTOR_1_IZQ | MOTOR_2_IZQ
	GOTO ENVIA

MI_DER_M2_IZQ
	MOVLW MOTOR_1_DER | MOTOR_2_IZQ
	GOTO ENVIA

MI_IZQ_M2_DER
	MOVLW MOTOR_1_IZQ | MOTOR_2_DER
	GOTO ENVIA

NADA
	CLRW

ENVIA
      MOVWF PORTB
      GOTO PRINCIPAL
      END