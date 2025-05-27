	.equ SCREEN_WIDTH, 		640
	.equ SCREEN_HEIGH, 		480
	.equ BITS_PER_PIXEL,  	32

	.equ GPIO_BASE,      0x3f200000
	.equ GPIO_GPFSEL0,   0x00
	.equ GPIO_GPLEV0,    0x34

	.globl main

main:
	// x0 contiene la direccion base del framebuffer
 	mov x20, x0	// Guarda la dirección base del framebuffer en x20
	//---------------- CODE HERE ------------------------------------

	movz x10, 0x0042, lsl 16
	movk x10, 0x6BAF, lsl 00

	mov x2, SCREEN_HEIGH         // Y Size
loop1:
	mov x1, SCREEN_WIDTH         // X Size
loop0:
	stur w10,[x0]  // Colorear el pixel N
	add x0,x0,4	   // Siguiente pixel
	sub x1,x1,1	   // Decrementar contador X
	cbnz x1,loop0  // Si no terminó la fila, salto
	sub x2,x2,1	   // Decrementar contador Y
	cbnz x2,loop1  // Si no es la última fila, salto

	movz x10, 0x00D1, lsl 16
	movk x10, 0xc986, lsl 00

	//quiero pintar de la fila 400 para bajo de un color distinto que represente la arena

	//contador

	mov x1, SCREEN_WIDTH

	//iniciando en la posicion de memoria correspondiendte multiplico por 640 y por 4
	mov x12,#400
	lsl x13,x12,#9
	lsl x14,x12,#7
	add x12,x13,x14
	lsl x12,x12,#2

	mov x0,x20
	add x0,x0,x12
	//contador
	mov x2,#80      //ochenta pixeles de altura q falta para rellenar con arena [contador]
loop1s:
	mov x1, SCREEN_WIDTH//reinciandoe el contador para q pinte otra fila

loop0s:
	stur w10,[x0]  // Colorear el pixel N
	add x0,x0,4	   // Siguiente pixel
	sub x1,x1,1	   // Decrementar contador X
	cbnz x1,loop0s  // Si no terminó la fila, salto
	sub x2,x2,1
	cbnz x2,loop1s

//ahora quiero pontar algas una fila vertical de pixeles continuos por debajo para luego multipliaxrlos a lo ancho
//quiero pintar la primera alga desde x=100 Y=200
//color del alga 
	movz x10, 0x2f, lsl 16
	movk x10, 0x7e41, lsl 00
//busco la dirrecion de memoria (100,200)

	mov x0,x20
	mov x1,#100
	lsl x1,x1,#2
	mov x3,#200
	lsl x4,x3,#9
	lsl x5,x3,#7
	add x3,x4,x5//200*640=> y*640 para bajar en la matriz 200 filas
	lsl x3,X3,#2//200*640*4
	add x6,x0,x1
	add x6,x6,x3//direccion del pixel (100,200)

//dibujar un alga de un pixel de ancho
	mov x7,#300
	mov x0,x6
dibujaralga:
	stur w10,[x0]
	add x0,x0,#(640*4)
	sub x7,x7,#1
	cbnz x7, dibujaralga





	// Ejemplo de uso de gpios
	mov x9, GPIO_BASE

	// Atención: se utilizan registros w porque la documentación de broadcom
	// indica que los registros que estamos leyendo y escribiendo son de 32 bits

	// Setea gpios 0 - 9 como lectura
	str wzr, [x9, GPIO_GPFSEL0]

	// Lee el estado de los GPIO 0 - 31
	ldr w10, [x9, GPIO_GPLEV0]

	// And bit a bit mantiene el resultado del bit 2 en w10
	and w11, w10, 0b10

	// w11 será 1 si había un 1 en la posición 2 de w10, si no será 0
	// efectivamente, su valor representará si GPIO 2 está activo
	lsr w11, w11, 1

	//---------------------------------------------------------------
	// Infinite Loop

InfLoop:
	b InfLoop
