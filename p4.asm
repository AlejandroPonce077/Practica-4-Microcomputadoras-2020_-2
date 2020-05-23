processor 16f877
include<p16f877.inc>

MOTOR_IZQUIERDO_PARO		equ B'00000000'		;configuracion de ejemplo
MOTOR_DERECHO_PARO		equ B'00000000'		;es diferente para cada una
MOTOR_IZQUIERDO_HORARIO		equ B'00001100'		;conexi?n que se realice en
MOTOR_IZQUIERDO_ANTIHORARIO	equ B'00001000'		;el sistema fisico
MOTOR_DERECHO_HORARIO		equ B'00000011'
MOTOR_DERECHO_ANTIHORARIO	equ B'00000010'

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
	CLRW		;limpia el registro de trabajo w
	SUBWF PORTA,0	;w <--(PORTA)-0
	BTFSC STATUS,Z	;?(PORTA)=0?
	GOTO PARO	;si, ve a PARO
	MOVLW B'00000010'	;no, w <-- 0X02
	SUBWF PORTA,0	;w <--(PORTA)-0X02
	BTFSC STATUS,Z	;?(PORTA)=0X02?
	GOTO HORARIO_IZQ 
	MOVLW B'00000100'
	SUBWF PORTA,0
	BTFSC STATUS,Z
	GOTO ANTIHORARIO_IZQ
	MOVLW B'00001000'
	SUBWF PORTA,0
	BTFSC STATUS,Z
	GOTO HORARIO_DER
	MOVLW B'00010000'
	SUBWF PORTA,0
	BTFSC STATUS,Z
	GOTO ANTIHORARIO_DER
	CLRF PORTB
	GOTO PRINCIPAL
	
PARO:
       MOVLW MOTOR_IZQUIERDO_PARO | MOTOR_DERECHO_PARO
       GOTO ENVIA

HORARIO_IZQ:

       MOVLW MOTOR_IZQUIERDO_PARO | MOTOR_DERECHO_HORARIO
       GOTO ENVIA

ANTIHORARIO_IZQ:

       MOVLW MOTOR_IZQUIERDO_PARO | MOTOR_DERECHO_ANTIHORARIO
       GOTO ENVIA

HORARIO_DER

       MOVLW MOTOR_IZQUIERDO_HORARIO | MOTOR_DERECHO_PARO
       GOTO ENVIA

ANTIHORARIO_DER

       MOVLW MOTOR_IZQUIERDO_ANTIHORARIO | MOTOR_DERECHO_PARO

ENVIA
      MOVWF PORTB
      GOTO PRINCIPAL
      END