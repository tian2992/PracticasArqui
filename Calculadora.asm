org 100h
use16
start:
;limpiar la pantalla
mov	ah,00h
mov	al,03h
int	10h
;Mensaje de bienvenida
mov	ah,9h
mov	dx,msg
int 	21h
;esperar numeros
Esperar:
mov	ah,00h
int	16h
;echo
mov	ah, 0eh
int	10h
;operar conforme se presionan las teclas
cmp	al,27   	;salir con q
je	SalirEsc
cmp	al,'+'		;detectar suma
je	Suma
cmp	al,'-'		;detectar resta
je	Resta
cmp	al,'*'		;detectar multiplicacion
je	Mult
cmp	al,'/'		;detectar division
je	Divi
cmp	al,13		;operar
je	Operar
;ver si es numero
mov	cl,al
push	cx		;guardar el numero a la pila
sub	al, 40h		;ver si es numero
cmp	al, 0
jge	Error

jmp	Esperar		;esperar siguiente numero o tecla



Suma:
;acciones para sumar cosas
pop 	cx
add	al,cl
int	21h
jmp	Esperar

Resta:
;acciones para restar cosas
pop	cx
sub	al,cl
jmp	 Esperar

Mult:
;acciones para multiplicar cosas
pop	cx
;mul   	al,cl 
jmp	Esperar

Divi:
;acciones para dividir cosas
pop	cx
;div	al,cl
jmp 	Esperar

Operar:
;acciones para operar
pop	cx
mov	ah,09h
mov	dx,opact
int	21h
jmp	Esperar

Error:
mov	ah,09h
mov	dx,error
int 	21h
jmp	Esperar

SalirEsc:
mov	ah,09h
mov	dx,adios
int 	21h
ret

num	db ?  
opact	db "operacion realizada:",13,10,"$"
msg	db "Bienvenido a la calculadora",13,10,"$"
adios	db 13,10,"Adios :)",13,10,"$"
error	db 13,13,"esto no es un numero",13,10,"$"

