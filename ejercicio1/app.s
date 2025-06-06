.equ SCREEN_WIDTH,     640
    .equ SCREEN_HEIGHT,    480
    .equ BITS_PER_PIXEL,   32

    .equ GPIO_BASE,        0x3f200000
    .equ GPIO_GPFSEL0,     0x00
    .equ GPIO_GPLEV0,      0x34

    .equ DELAY1, 0xFFFFFFFF
    .equ DELAY2, 0X00066666

    .globl main

main:
    // Guardar puntero base del framebuffer
    mov     x20, x0                // x20 = base del framebuffer

    // ------------------------------
    // bucle para pintar el FONDO del mar
    // ------------------------------
    movz    x10, 0x0042, lsl 16    // x10 = 0x00420000
    movk    x10, 0x6BAF, lsl 0     // x10 = 0x00426BAF  (color = 0x426BAF)

    mov     x0, x20                // x0 = framebuffer
    mov     x2, SCREEN_HEIGHT      // filas restantes

fondo_loop_y:
    mov     x1, SCREEN_WIDTH       // columnas restantes
fondo_loop_x:
    stur    w10, [x0]              // escribir color
    add     x0, x0, #4             // avanzar 1 píxel (4 bytes)
    subs    x1, x1, #1
    b.ne    fondo_loop_x
    subs    x2, x2, #1
    b.ne    fondo_loop_y

    mov x1, #0
    mov x2, #400

    bl pintar_arena
    bl detalles_arena
    bl letras_odc
    bl serie_algas

    // TIBURON ANIMADO

    mov x0, x20
    mov x1, #240
    mov x2, #200
 
    bl dibujar_cola1
    bl dibujar_cuerpo
    bl dibujar_ojo1
    bl dibujar_aletas2

    //dibujar calamar y declarar el color
    mov x0, x20
    mov x1, #50
    mov x2, #20
    movz    x26, 0x00FC, lsl 16    // x10 = 0x00D10000
    movk    x26, 0x53A0, lsl 0     // x10 = 0x00D1C986
    bl dibujar_cuerpo_calamar
    bl dibujar_tentaculos_calamar

//dibujar otro calamar y declarar el color
    mov x0, x20
    mov x1, #520
    mov x2, #220
    movz    x26, 0x0097, lsl 16    // x10 = 0x00D10000
    movk    x26, 0x05f9, lsl 0     // x10 = 0x00D1C986
    bl dibujar_cuerpo_calamar
    bl dibujar_tentaculos_calamar_MOVIENDOSE

    mov x1, #420
    mov x2, #420
    bl dibujar_cangrejo_cuerpo

    //colores y pos del pez 1


    movz    x25, 0x0090, lsl 16    //color del cuepo del pez
    movk    x25, 0x0C3F, lsl 0     //


    movz    x21, 0x00FF, lsl 16    // color aletas
    movk    x21, 0x5733, lsl 0     // 

    movz    x22, 0x00FF, lsl 16    //pico
    movk    x22, 0x3500, lsl 0     //


    movz    x23, 0x0000, lsl 16    // OJO
    movk    x23, 0x0000, lsl 0     //

    movz    x24, 0x0058, lsl 16    // COLA
    movk    x24, 0x1845, lsl 0     //  

    mov x1, #500
    mov x2, #20

    bl dibujar_pez

   //colores y pos del pez 1




    movz    x21, 0x004a, lsl 16    // color cuerpo
    movk    x21, 0x05f9, lsl 0     // 

    movz    x22, 0x00ff, lsl 16    //aleta
    movk    x22, 0xfe1f, lsl 0     //


    movz    x23, 0x0000, lsl 16    // pupilas ojo
    movk    x23, 0x0000, lsl 0     // 

    movz    x24, 0x00ff, lsl 16    // COLA
    movk    x24, 0xca13, lsl 0     //  

    mov x1, #100
    mov x2, #200

    bl dibujar_pez_2

//dibujar mas peces

    movz    x21, 0x00d1, lsl 16    // color cuerpo
    movk    x21, 0x05f9, lsl 0     // 

    movz    x22, 0x00ff, lsl 16    //aleta
    movk    x22, 0xfe1f, lsl 0     //


    movz    x23, 0x0000, lsl 16    // pupilas ojo
    movk    x23, 0x0000, lsl 0     // 

    movz    x24, 0x00ff, lsl 16    // COLA
    movk    x24, 0xca13, lsl 0     //  

    mov x1, #400
    mov x2, #300

    bl dibujar_pez_2

    movz    x21, 0x00f9, lsl 16    // color cuerpo
    movk    x21, 0x0590, lsl 0     // 

    movz    x22, 0x00ff, lsl 16    //aleta
    movk    x22, 0xfe1f, lsl 0     //


    movz    x23, 0x0000, lsl 16    // pupilas ojo
    movk    x23, 0x0000, lsl 0     // 

    movz    x24, 0x00ff, lsl 16    // COLA
    movk    x24, 0xca13, lsl 0     //  

    mov x1, #420
    mov x2, #100

    bl dibujar_pez_2


    movz    x21, 0x0005, lsl 16    // color cuerpo
    movk    x21, 0x0566, lsl 0     // 

    movz    x22, 0x00ff, lsl 16    //aleta
    movk    x22, 0xfe1f, lsl 0     //


    movz    x23, 0x0000, lsl 16    // pupilas ojo
    movk    x23, 0x0000, lsl 0     // 

    movz    x24, 0x00ff, lsl 16    // COLA
    movk    x24, 0xca13, lsl 0     //  

    mov x1, #420
    mov x2, #340

    bl dibujar_pez_2

    movz    x21, 0x00f9, lsl 16    // color cuerpo
    movk    x21, 0x0590, lsl 0     // 

    movz    x22, 0x00ff, lsl 16    //aleta
    movk    x22, 0xfe1f, lsl 0     //


    movz    x23, 0x0000, lsl 16    // pupilas ojo
    movk    x23, 0x0000, lsl 0     // 

    movz    x24, 0x00ff, lsl 16    // COLA
    movk    x24, 0xca13, lsl 0     //  

    mov x1, #420
    mov x2, #100

    bl dibujar_pez_2

    //dibujas carunemes de peces
    
    movz    x21, 0x0005, lsl 16    // color cuerpo
    movk    x21, 0xf966, lsl 0     // 

    movz    x22, 0x00ff, lsl 16    //aleta
    movk    x22, 0xfe1f, lsl 0     //


    movz    x23, 0x0000, lsl 16    // pupilas ojo
    movk    x23, 0x0000, lsl 0     // 

    movz    x24, 0x00ff, lsl 16    // COLA
    movk    x24, 0xca13, lsl 0     //  

    mov x1, #420
    mov x2, #80

    bl dibujar_pez_2

    movz    x21, 0x00e8, lsl 16    // color cuerpo
    movk    x21, 0xf905, lsl 0     // 

    movz    x22, 0x00ff, lsl 16    //aleta
    movk    x22, 0xfe1f, lsl 0     //


    movz    x23, 0x0000, lsl 16    // pupilas ojo
    movk    x23, 0x0000, lsl 0     // 

    movz    x24, 0x00ff, lsl 16    // COLA
    movk    x24, 0xca13, lsl 0     //  

    mov x1, #370
    mov x2, #85

    bl dibujar_pez_2


    movz    x21, 0x00e8, lsl 16    // color cuerpo
    movk    x21, 0xf905, lsl 0     // 

    movz    x22, 0x00ff, lsl 16    //aleta
    movk    x22, 0xfe1f, lsl 0     //


    movz    x23, 0x0000, lsl 16    // pupilas ojo
    movk    x23, 0x0000, lsl 0     // 

    movz    x24, 0x00ff, lsl 16    // COLA
    movk    x24, 0xca13, lsl 0     //  

    mov x1, #370
    mov x2, #85

    bl dibujar_pez_2



    //burbuajas del mago
    mov x1,#330
    mov x2,#100
    mov x3,#6
    bl dibujar_burbujas

    mov x1,#200
    mov x2,#200
    mov x3,#8
    bl dibujar_burbujas

    mov x1,#150
    mov x2,#150
    mov x3,#10
    bl dibujar_burbujas


    mov x1,#250
    mov x2,#130
    mov x3,#10
    bl dibujar_burbujas



    mov x1,#390
    mov x2,#200
    mov x3,#10
    bl dibujar_burbujas

    mov x1,#480
    mov x2,#100
    mov x3,#10
    bl dibujar_burbujas

    // GPIOs


    mov     x9, GPIO_BASE         // x9 = base de GPIO
    str     wzr, [x9, GPIO_GPFSEL0]
    ldr     w10, [x9, GPIO_GPLEV0]
    and     w11, w10, #0b10
    lsr     w11, w11, #1

    // ------------------------------
    // Infinite Loop

InfLoop:

	b InfLoop
    b       InfLoop



//
//  FUNCIONES
//  FUNCIONES
//


// ------------------------------------------------------------
// Función: obtener_direccion_pixel
// Entradas: x0 = framebuffer_base, x1 = X, x2 = Y
// Salida  : x0 = &pixel(X,Y)
// ------------------------------------------------------------
obtener_direccion_pixel:
    lsl     x3, x1, #2            // x3 = X * 4
    lsl     x4, x2, #9            // x4 = Y * 512
    lsl     x5, x2, #7            // x5 = Y * 128
    add     x6, x4, x5            // x6 = Y * (512 + 128) = Y * 640
    lsl     x6, x6, #2            // x6 = Y * 640 * 4 bytes
    add     x0, x0, x3            // x0 = framebuffer + X*4
    add     x0, x0, x6            // x0 = framebuffer + Y*640*4 + X*4
    ret

// ------------------------------------------------------------
// Función: pintar_rectangulo
// Entradas:
//   x0 = framebuffer_base
//   x1 = X0 (columna inicial)
//   x2 = Y0 (fila inicial)
//   x3 = ancho en píxeles
//   x4 = alto en píxeles
//   x10 = color (0xRRGGBB)
// ------------------------------------------------------------
pintar_rectangulo:
    // x1 = X0, x2 = Y0
    // x3 = ancho, x4 = alto
    // x10 = color, x20 = framebuffer

    // Calcular dirección inicial
    lsl     x5, x2, #9       // Y0 * 512
    lsl     x6, x2, #7       // Y0 * 128
    add     x5, x5, x6       // Y0 * 640
    add     x5, x5, x1       // + X0
    lsl     x5, x5, #2       // * 4
    add     x5, x20, x5      // x5 = puntero inicial

    mov     x6, x4           // x6 = alto (filas restantes)

pintar_filas:
    mov     x7, x3           // x7 = ancho (columnas restantes)
    mov     x8, x5           // x8 = puntero actual en fila

pintar_columnas:
    stur    w10, [x8]
    add     x8, x8, #4
    subs    x7, x7, #1
    b.ne    pintar_columnas

    // siguiente fila: avanzar 640*4 bytes
    add     x5, x5, #(640*4)
    subs    x6, x6, #1
    b.ne    pintar_filas
    ret



// ------------------------------------------------------------
// Función: pintar_circulo
//   Dibuja un círculo sólido completo.
// Entradas:
//   x0 = framebuffer_base
//   x1 = X_centro
//   x2 = Y_centro
//   x3 = radio
//   x10 = color
// ------------------------------------------------------------
pintar_circulo:
    // x0 = framebuffer
    // x1 = X_centro
    // x2 = Y_centro
    // x3 = radio
    // x10 = color

    // radio^2
    mul     x11, x3, x3         // x11 = r^2

    // deltaY = -radio
    neg     x4, x3              // x4 = deltaY inicial

ciclo_filas:
    cmp     x4, x3
    b.gt    fin_circulo         // deltaY > radio → salir

    mul     x5, x4, x4          // dy^2

    // deltaX = -radio
    neg     x6, x3

ciclo_columnas:
    cmp     x6, x3
    b.gt    siguiente_fila

    mul     x7, x6, x6          // dx^2
    add     x8, x5, x7          // dx^2 + dy^2
    cmp     x8, x11
    b.gt    continuar_columna

    // X = X_centro + deltaX
    add     x7, x1, x6
    cmp     x7, #0
    blt     continuar_columna
    cmp     x7, #639
    b.gt    continuar_columna

    // Y = Y_centro + deltaY
    add     x8, x2, x4
    cmp     x8, #0
    blt     continuar_columna
    cmp     x8, #479
    b.gt    continuar_columna

    // offset = ((Y * 640) + X) * 4
    lsl     x9, x8, #9        // Y * 512
    lsl     x12, x8, #7       // Y * 128
    add     x9, x9, x12       // Y * 640
    add     x9, x9, x7        // + X
    lsl     x9, x9, #2        // * 4
    add     x9, x0, x9        // dirección final
    stur    w10, [x9]

continuar_columna:
    add     x6, x6, #1
    b       ciclo_columnas

siguiente_fila:
    add     x4, x4, #1
    b       ciclo_filas

fin_circulo:
    ret


// Dibujo TIBURON

dibujar_cuerpo:

    stp x29, x30, [sp, #-16]!  // Guarda x30 (LR) y x29 (FP)

    add x1, x1, #16
    mov x4, #4
    mov x10, x26
    bl pintar_rectangulo

    add x1, x1, #8
    mov x3, #24
    mov x10, x27
    bl pintar_rectangulo

    add x2, x2, #4
    mov x4, #8
    mov x3, #8
    mov x10, x25
    bl pintar_rectangulo

    sub x2, x2, #12
    mov x3, #16
    mov x10, x23
    bl pintar_rectangulo

    sub x2, x2, #16
    mov x3, #8
    mov x4, #16
    mov x10, x24
    bl pintar_rectangulo

    add x1, x1, #8
    add x2, x2, #4
    mov x3, #136
    mov x4, #4
    mov x10, x23
    bl pintar_rectangulo

    add x2, x2, #4
    mov x3, #8
    mov x4, #8
    bl pintar_rectangulo

    add x1, x1, #8
    mov x10, x26
    bl pintar_rectangulo

    add x2, x2, #8
    mov x10, x27
    mov x4, #4
    mov x3, #16
    bl pintar_rectangulo

    mov x3, #8
    mov x4, #8
    bl pintar_rectangulo

    add x1, x1, #4
    add x2, x2, #8
    mov x3, #20
    mov x4, #6
    mov x10, x16
    bl pintar_rectangulo

    add x2, x2, #6
    mov x10, x27
    mov x4, #4
    bl pintar_rectangulo

    sub x2, x2, #10
    add x1, x1, #4
    mov x3, #44
    mov x10, x17
    bl pintar_rectangulo

    sub x2, x2, #4
    mov x3, #8
    mov x4, #4
    mov x10, x27
    bl pintar_rectangulo

    sub x2, x2, #8
    mov x3, #104
    mov x4, #8
    bl pintar_rectangulo

    sub x2, x2, #8
    mov x4, #4
    mov x3, #104
    mov x10, x23
    bl pintar_rectangulo

    add x1, x1, #40
    sub x2, x2, #4
    mov x3, #48
    bl pintar_rectangulo

    sub x1, x1, #32
    add x2, x2, #20
    mov x3, #36
    mov x4, #8
    mov x10, x17
    bl pintar_rectangulo

    mov x4, #4
    mov x3, #60
    bl pintar_rectangulo

    add x1, x1, #36
    add x2, x2, #4
    mov x3, #44
    mov x4, #12
    mov x10, x16
    bl pintar_rectangulo

    
    sub x2, x2, #8
    mov x3, #4
    mov x10, x25
    bl pintar_rectangulo

    add x1, x1, #8
    bl pintar_rectangulo

    sub x1, x1, #12
    add x2, x2, #12
    mov x4, #4
    mov x10, x16
    bl pintar_rectangulo

    add x2, x2, #4
    mov x10, x17
    bl pintar_rectangulo

    add x2, x2, #4
    mov x3, #48
    bl pintar_rectangulo
    
    add x1, x1, #28
    sub x2, x2, #16
    mov x10, x16
    mov x4, #6
    mov x3, #36
    bl pintar_rectangulo

    add x1, x1, #36
    mov x3, #8
    mov x4, #6
    mov x10, x17
    bl pintar_rectangulo

    sub x1, x1, #24
    add x2, x2, #6
    mov x10, x25
    mov x3, #8
    mov x4, #4
    bl pintar_rectangulo

    add x1, x1, #8
    mov x10, x17
    mov x4, #4
    bl pintar_rectangulo

    add x2, x2, #4
    mov x10, x23
    bl pintar_rectangulo
    
    add x1, x1, #8
    sub x2, x2, #12
    mov x4, #2
    mov x3, #24
    mov x10, x22
    bl pintar_rectangulo

    add x1, x1, #8
    sub x2, x2, #2
    mov x3, #16
    bl pintar_rectangulo

    add x1, x1, #8
    sub x2, x2, #4
    mov x4, #4
    mov x3, #8
    bl pintar_rectangulo

    sub x1, x1, #8
    mov x10, x23
    bl pintar_rectangulo

    ldp x29, x30, [sp], #16     // Restaura x30

    ret

dibujar_aletas1:

    stp x29, x30, [sp, #-16]!  // Guarda x30 (LR) y x29 (FP)

    sub x1, x1, #62
    add x2, x2, #16
    mov x10, x25
    mov x3, #8
    mov x4, #10
    bl pintar_rectangulo

    add x1, x1, #8
    mov x3, #16
    mov x10, x22
    bl pintar_rectangulo

    sub x1, x1, #12
    add x2, x2, #10
    mov x3, #20
    bl pintar_rectangulo
    
    sub x1, x1, #4
    add x2, x2, #8
    mov x3, #16
    mov x4, #8
    mov x10, x25
    bl pintar_rectangulo

    add x1, x1, #24
    sub x2, x2, #8
    mov x3, #4
    mov x4, #4
    bl pintar_rectangulo

    add x1, x1, #8
    add x2, x2, #2
    mov x3, #22
    mov x10, x22
    bl pintar_rectangulo

    add x1, x1, #4
    add x2, x2, #4
    mov x10, x25
    mov x4, #6
    mov x3, #6
    bl pintar_rectangulo

    add x1, x1, #4
    mov x10, x22
    mov x3, #8
    bl pintar_rectangulo
    
    add x2, x2, #6
    mov x10, x25
    mov x4, #2
    bl pintar_rectangulo

    add x1, x1, #8
    sub x2, x2, #6
    mov x10, x24
    mov x3, #4
    mov x4, #8
    bl pintar_rectangulo

    sub x1, x1, #40
    sub x2, x2, #42
    mov x3, #24
    mov x4, #2
    mov x10, x22
    bl pintar_rectangulo

    sub x2, x2, #2
    mov x3, #20
    bl pintar_rectangulo

    sub x2, x2, #4
    mov x3, #16
    mov x4, #4
    bl pintar_rectangulo

    sub x2, x2, #4
    mov x3, #8
    bl pintar_rectangulo

    sub x2, x2, #4
    mov x3, #4
    bl pintar_rectangulo

    sub x2, x2, #8
    mov x3, #8
    mov x4, #8
    mov x10, x23
    bl pintar_rectangulo

    add x1, x1, #4
    mov x3, #4
    mov x4, #2
    mov x10, x27
    bl pintar_rectangulo

    add x2, x2, #8
    mov x10, x23
    mov x3, #12
    mov x4, #4
    bl pintar_rectangulo

    add x1, x1, #4
    add x2, x2, #4
    bl pintar_rectangulo

    add x1, x1, #8
    add x2, x2, #4
    mov x3, #8
    mov x4, #4
    bl pintar_rectangulo

    add x1, x1, #4
    add x2, x2, #2
    mov x3, #4
    mov x4, #4
    bl pintar_rectangulo


    ldp x29, x30, [sp], #16     // Restaura x30

    ret

dibujar_aletas2:

    stp x29, x30, [sp, #-16]!  // Guarda x30 (LR) y x29 (FP)

    sub x1, x1, #62
    add x2, x2, #16
    mov x10, x25
    mov x3, #8
    mov x4, #10
    bl pintar_rectangulo

    add x1, x1, #8
    mov x3, #16
    mov x10, x22
    bl pintar_rectangulo

    sub x1, x1, #12
    add x2, x2, #10
    mov x3, #20
    bl pintar_rectangulo
    
    sub x1, x1, #4
    add x2, x2, #8
    mov x3, #16
    mov x4, #8
    mov x10, x25
    bl pintar_rectangulo

    add x1, x1, #24
    sub x2, x2, #8
    mov x3, #4
    mov x4, #4
    bl pintar_rectangulo

    add x1, x1, #8
    add x2, x2, #2
    mov x3, #22
    mov x10, x22
    bl pintar_rectangulo

    add x1, x1, #4
    add x2, x2, #4
    mov x10, x25
    mov x4, #6
    mov x3, #6
    bl pintar_rectangulo

    add x1, x1, #4
    mov x10, x22
    mov x3, #8
    bl pintar_rectangulo
    
    add x2, x2, #6
    mov x10, x25
    mov x4, #2
    bl pintar_rectangulo

    add x1, x1, #8
    sub x2, x2, #6
    mov x10, x24
    mov x3, #4
    mov x4, #8
    bl pintar_rectangulo

    sub x1, x1, #40
    sub x2, x2, #42
    mov x3, #24
    mov x4, #2
    mov x10, x22
    bl pintar_rectangulo

    sub x2, x2, #2
    mov x3, #20
    bl pintar_rectangulo

    sub x2, x2, #3
    mov x3, #16
    mov x4, #3
    bl pintar_rectangulo

    sub x2, x2, #3
    mov x3, #8
    bl pintar_rectangulo

    sub x2, x2, #3
    mov x3, #4
    bl pintar_rectangulo

    sub x2, x2, #7
    mov x3, #8
    mov x4, #7
    mov x10, x23
    bl pintar_rectangulo

    add x1, x1, #4
    mov x3, #4
    mov x4, #1
    mov x10, x27
    bl pintar_rectangulo

    add x2, x2, #7
    mov x10, x23
    mov x3, #12
    mov x4, #3
    bl pintar_rectangulo

    add x1, x1, #4
    add x2, x2, #3
    bl pintar_rectangulo

    add x1, x1, #8
    add x2, x2, #3
    mov x3, #8
    mov x4, #3
    bl pintar_rectangulo

    add x1, x1, #4
    add x2, x2, #1
    mov x3, #4
    mov x4, #4
    bl pintar_rectangulo


    ldp x29, x30, [sp], #16     // Restaura x30

    ret

dibujar_cola2:

    stp x29, x30, [sp, #-16]!  // Guarda x30 (LR) y x29 (FP)


    // ------ COLORES PARA EL TIBURON

    movz x16, #0xffff, lsl #16
    movk x16, #0xffff            // BLANCO 
    movz x17, #0x00d3, lsl #16
    movk x17, #0xdbde            // GRIS +++CLARO
    movz x21, #0x003b, lsl #16
    movk x21, #0x414a            // GRIS 
    movz x22, #0x002c, lsl #16
    movk x22, #0x3136            // GRIS OSCURO
    movz x23, #0x0056, lsl #16   
    movk x23, #0x5f68            // GRIS CLARO
    movz x24, #0x0033, lsl #16
    movk x24, #0x3a42            // GRIS +OSCURO
    movz x25, #0x0012, lsl #16   
    movk x25, #0x1315            // GRIS ++OSCURO
    movz x26, #0x009b, lsl #16   
    movk x26, #0xa3a6            // GRIS +CLARO
    movz x27, #0x00bf, lsl #16
    movk x27, #0xc8ca            // GRIS ++CLARO

    ldp x29, x30, [sp], #16     // Restaura x30


    ret

dibujar_cola1:
    stp x29, x30, [sp, #-16]!  // Guarda x30 (LR) y x29 (FP)

    // ------ COLORES PARA EL TIBURON

    movz x16, #0xffff, lsl #16
    movk x16, #0xffff            // BLANCO 
    movz x17, #0x00d3, lsl #16
    movk x17, #0xdbde            // GRIS +++CLARO
    movz x21, #0x003b, lsl #16
    movk x21, #0x414a            // GRIS 
    movz x22, #0x002c, lsl #16
    movk x22, #0x3136            // GRIS OSCURO
    movz x23, #0x0056, lsl #16   
    movk x23, #0x5f68            // GRIS CLARO
    movz x24, #0x0033, lsl #16
    movk x24, #0x3a42            // GRIS +OSCURO
    movz x25, #0x0012, lsl #16   
    movk x25, #0x1315            // GRIS ++OSCURO
    movz x26, #0x009b, lsl #16   
    movk x26, #0xa3a6            // GRIS +CLARO
    movz x27, #0x00bf, lsl #16
    movk x27, #0xc8ca            // GRIS ++CLARO

    mov x10, x21
    mov x3, #8
    mov x4, #8
    bl pintar_rectangulo

    add x2, x2, #8
    mov x10, x22
    bl pintar_rectangulo

    add x1, x1,#8
    mov x10, x23
    bl pintar_rectangulo

    add x2, x2, #8
    mov x10, x22
    mov x3, #4
    bl pintar_rectangulo

    add x1, x1, #4
    mov x10, x23
    mov x3, #12
    bl pintar_rectangulo

    add x2, x2, #8
    mov x10, x22
    mov x3, #4
    bl pintar_rectangulo

    add x1, x1, #4
    mov x10, x21
    mov x3, #8
    bl pintar_rectangulo

    add x1, x1, #8
    mov x10, x23
    bl pintar_rectangulo

    sub x1, x1, #8
    add x2, x2, #8
    mov x4, #24
    mov x10, x24
    bl pintar_rectangulo

    add x2, x2, #24
    mov x4, #8
    mov x10, x25
    bl pintar_rectangulo

    add x1, x1, #8
    sub x2, x2, #24
    mov x3, #24
    mov x10, x21
    bl pintar_rectangulo

    add x2, x2, #8
    mov x3, #8
    bl pintar_rectangulo

    add x1, x1, #8
    mov x3, #16
    mov x4, #4
    mov x10, x23
    bl pintar_rectangulo

    add x2, x2, #4
    mov x10, x21
    bl pintar_rectangulo

    sub x1, x1, #8
    add x2, x2, #4
    mov x3, #8
    mov x4, #8
    mov x10, x25
    bl pintar_rectangulo

    ldp x29, x30, [sp], #16     // Restaura x30
    ret

dibujar_ojo1:

    stp x29, x30, [sp, #-16]!  // Guarda x30 (LR) y x29 (FP)

    sub x1, x1, #24
    mov x10, x25
    mov x3, #8
    mov x4, #6
    bl pintar_rectangulo

    sub x1, x1, #2
    mov x3, #2
    mov x4, #2
    bl pintar_rectangulo

    ldp x29, x30, [sp], #16     // Restaura x30

    ret

dibujar_ojo2:

    stp x29, x30, [sp, #-16]!  // Guarda x30 (LR) y x29 (FP)


    sub x1, x1, #24
    mov x10, x25
    mov x3, #8
    mov x4, #6
    bl pintar_rectangulo

    add x1, x1, #8
    mov x3, #2
    mov x4, #2
    bl pintar_rectangulo

    ldp x29, x30, [sp], #16     // Restaura x30

    ret


hacer_tiempo:
    ldr x0, =0x3FFFFFF  // Valor empírico para QEMU (probado en RPi 4)
1:
    subs x0, x0, #1
    b.ne 1b
    ret

letras_odc:

    movz x23, #0x00BC, lsl #16 // color arena para las letras "ODC 2025"
    movk x23, #0x9845, lsl #0

    stp  x29, x30, [sp, #-16]!  

    // letras hechas con la arena
    sub x2,x2,#30
    mov x3, #5  //tamaño de los granos de arena
    mov x4, #5
    mov x10, x23  // color de las letras
    bl pintar_rectangulo

    add x1, x1, #5
    add x2, x2, #0
    bl pintar_rectangulo

    add x1, x1, #5
    add x2, x2, #1
    bl pintar_rectangulo

    add x1, x1, #3
    add x2, x2, #3
    bl pintar_rectangulo

    add x1, x1, #1
    add x2, x2, #5
    bl pintar_rectangulo

    add x1, x1, #0
    add x2, x2, #5
    bl pintar_rectangulo

    add x1, x1, #0
    add x2, x2, #5
    bl pintar_rectangulo

    sub x1, x1, #1
    add x2, x2, #5
    bl pintar_rectangulo

    sub x1, x1, #3
    add x2, x2, #3
    bl pintar_rectangulo

    sub x1, x1, #5
    add x2, x2, #1
    bl pintar_rectangulo

    sub x1, x1, #5
    add x2, x2, #0
    bl pintar_rectangulo

    sub x1, x1, #3
    sub x2, x2, #1
    bl pintar_rectangulo

    sub x1, x1, #3
    sub x2, x2, #3
    bl pintar_rectangulo

    sub x1, x1, #1
    sub x2, x2, #5
    bl pintar_rectangulo

    add x1, x1, #0
    sub x2, x2, #5
    bl pintar_rectangulo

    add x1, x1, #0
    sub x2, x2, #5
    bl pintar_rectangulo

    add x1, x1, #1
    sub x2, x2, #5
    bl pintar_rectangulo

    add x1, x1, #3
    sub x2, x2, #3
    bl pintar_rectangulo

    add x1, x1, #47
    sub x2, x2, #1
    bl pintar_rectangulo

    add x1, x1, #0
    add x2, x2, #5
    bl pintar_rectangulo

    add x1, x1, #0
    add x2, x2, #5
    bl pintar_rectangulo

    add x1, x1, #0
    add x2, x2, #5
    bl pintar_rectangulo

    add x1, x1, #0
    add x2, x2, #5
    bl pintar_rectangulo

    add x1, x1, #0
    add x2, x2, #5
    bl pintar_rectangulo

    add x1, x1, #0
    add x2, x2, #2
    bl pintar_rectangulo

    sub x1, x1, #2
    sub x2, x2, #3
    bl pintar_rectangulo

    sub x1, x1, #2
    add x2, x2, #1
    bl pintar_rectangulo

    sub x1, x1, #2
    add x2, x2, #1
    bl pintar_rectangulo

    sub x1, x1, #2
    add x2, x2, #1
    bl pintar_rectangulo

    sub x1, x1, #2
    add x2, x2, #0
    bl pintar_rectangulo

    sub x1, x1, #2
    add x2, x2, #0
    bl pintar_rectangulo

    sub x1, x1, #2
    sub x2, x2, #1
    bl pintar_rectangulo

    sub x1, x1, #2
    sub x2, x2, #1
    bl pintar_rectangulo

    sub x1, x1, #2
    sub x2, x2, #1
    bl pintar_rectangulo

    sub x1, x1, #0
    sub x2, x2, #1
    bl pintar_rectangulo

    sub x1, x1, #0
    sub x2, x2, #2
    bl pintar_rectangulo

    sub x1, x1, #0
    sub x2, x2, #2
    bl pintar_rectangulo

    add x1, x1, #1
    sub x2, x2, #1
    bl pintar_rectangulo

    add x1, x1, #1
    sub x2, x2, #2
    bl pintar_rectangulo

    add x1, x1, #2
    sub x2, x2, #2
    bl pintar_rectangulo

    add x1, x1, #1
    sub x2, x2, #1
    bl pintar_rectangulo

    add x1, x1, #2
    add x2, x2, #0
    bl pintar_rectangulo

    add x1, x1, #1
    add x2, x2, #0
    bl pintar_rectangulo

    add x1, x1, #2
    add x2, x2, #0
    bl pintar_rectangulo

    add x1, x1, #2
    add x2, x2, #1
    bl pintar_rectangulo

    add x1, x1, #2
    add x2, x2, #1
    bl pintar_rectangulo



    ////////Numero 2 ----------- /////
    add x1, x1, #33
    sub x2, x2, #13
    bl pintar_rectangulo

    sub x1, x1, #3
    sub x2, x2, #2
    bl pintar_rectangulo

    sub x1, x1, #3
    add x2, x2, #0
    bl pintar_rectangulo

    sub x1, x1, #3
    add x2, x2, #2
    bl pintar_rectangulo

    sub x1, x1, #3
    add x2, x2, #2
    bl pintar_rectangulo

    sub x1, x1, #3
    add x2, x2, #2
    bl pintar_rectangulo

    sub x1, x1, #1
    add x2, x2, #5
    bl pintar_rectangulo

    sub x1, x1, #0
    add x2, x2, #5
    bl pintar_rectangulo

    sub x1, x1, #0
    add x2, x2, #4
    bl pintar_rectangulo

    add x1, x1, #3
    add x2, x2, #2
    bl pintar_rectangulo

    add x1, x1, #3
    add x2, x2, #2
    bl pintar_rectangulo

    add x1, x1, #3
    add x2, x2, #2
    bl pintar_rectangulo

    add x1, x1, #3
    add x2, x2, #0
    bl pintar_rectangulo

    add x1, x1, #3
    sub x2, x2, #2
    bl pintar_rectangulo

    add x1, x1, #2
    sub x2, x2, #2
    bl pintar_rectangulo

    add x1, x1, #25
    sub x2, x2, #15
    bl pintar_rectangulo

    add x1, x1, #3
    add x2, x2, #0
    bl pintar_rectangulo

    add x1, x1, #0
    sub x2, x2, #3
    bl pintar_rectangulo

    add x1, x1, #3
    add x2, x2, #0
    bl pintar_rectangulo

    add x1, x1, #3
    add x2, x2, #0
    bl pintar_rectangulo

    add x1, x1, #3
    add x2, x2, #0
    bl pintar_rectangulo

    add x1, x1, #0
    add x2, x2, #3
    bl pintar_rectangulo

    add x1, x1, #3
    add x2, x2, #0
    bl pintar_rectangulo

    add x1, x1, #0
    add x2, x2, #3
    bl pintar_rectangulo

    sub x1, x1, #3
    add x2, x2, #0
    bl pintar_rectangulo

    add x1, x1, #3
    add x2, x2, #3
    bl pintar_rectangulo

    sub x1, x1, #3
    add x2, x2, #0
    bl pintar_rectangulo

    add x1, x1, #0
    add x2, x2, #3
    bl pintar_rectangulo

    sub x1, x1, #3
    add x2, x2, #0
    bl pintar_rectangulo

    add x1, x1, #0
    add x2, x2, #3
    bl pintar_rectangulo

    sub x1, x1, #3
    add x2, x2, #0
    bl pintar_rectangulo

    add x1, x1, #0
    add x2, x2, #3
    bl pintar_rectangulo

    sub x1, x1, #3
    add x2, x2, #0
    bl pintar_rectangulo

    add x1, x1, #0
    add x2, x2, #3
    bl pintar_rectangulo

    sub x1, x1, #3
    add x2, x2, #0
    bl pintar_rectangulo

    add x1, x1, #0
    add x2, x2, #2
    bl pintar_rectangulo

    add x1, x1, #3
    add x2, x2, #0
    bl pintar_rectangulo


    sub x1, x1, #3
    add x2, x2, #0
    bl pintar_rectangulo

    add x1, x1, #3
    add x2, x2, #0
    bl pintar_rectangulo

    add x1, x1, #3
    add x2, x2, #0
    bl pintar_rectangulo

    add x1, x1, #3
    add x2, x2, #0
    bl pintar_rectangulo

    add x1, x1, #3
    add x2, x2, #0
    bl pintar_rectangulo

    add x1, x1, #3
    add x2, x2, #0
    bl pintar_rectangulo

    add x1, x1, #0
    sub x2, x2, #2
    bl pintar_rectangulo


    //// Numero 0 --------------- /////////

    add x1, x1, #15
    add x2, x2, #2
    bl pintar_rectangulo

    add x1, x1, #3
    add x2, x2, #0
    bl pintar_rectangulo

    add x1, x1, #3
    add x2, x2, #0
    bl pintar_rectangulo


    add x1, x1, #3
    add x2, x2, #0
    bl pintar_rectangulo

    add x1, x1, #2
    sub x2, x2, #3
    bl pintar_rectangulo

    add x1, x1, #0
    sub x2, x2, #3
    bl pintar_rectangulo

    add x1, x1, #0
    sub x2, x2, #3
    bl pintar_rectangulo

    add x1, x1, #0
    sub x2, x2, #3
    bl pintar_rectangulo

    add x1, x1, #0
    sub x2, x2, #3
    bl pintar_rectangulo

    add x1, x1, #0
    sub x2, x2, #3
    bl pintar_rectangulo

    add x1, x1, #0
    sub x2, x2, #3
    bl pintar_rectangulo

    sub x1, x1, #3
    sub x2, x2, #2
    bl pintar_rectangulo

    sub x1, x1, #3
    sub x2, x2, #0
    bl pintar_rectangulo

    sub x1, x1, #3
    sub x2, x2, #0
    bl pintar_rectangulo

    sub x1, x1, #1
    sub x2, x2, #0
    bl pintar_rectangulo

    sub x1, x1, #3
    add x2, x2, #3
    bl pintar_rectangulo

    sub x1, x1, #0
    add x2, x2, #3
    bl pintar_rectangulo

    sub x1, x1, #0
    add x2, x2, #3
    bl pintar_rectangulo

    sub x1, x1, #0
    add x2, x2, #3
    bl pintar_rectangulo

    sub x1, x1, #0
    add x2, x2, #3
    bl pintar_rectangulo

    sub x1, x1, #0
    add x2, x2, #3
    bl pintar_rectangulo

    sub x1, x1, #0
    add x2, x2, #3
    bl pintar_rectangulo



    //// ------- numero 2 ----- ////////
    add x1, x1, #25
    sub x2, x2, #18
    bl pintar_rectangulo

    add x1, x1, #3
    add x2, x2, #0
    bl pintar_rectangulo

    add x1, x1, #0
    sub x2, x2, #3
    bl pintar_rectangulo

    add x1, x1, #3
    add x2, x2, #0
    bl pintar_rectangulo

    add x1, x1, #3
    add x2, x2, #0
    bl pintar_rectangulo

    add x1, x1, #3
    add x2, x2, #0
    bl pintar_rectangulo

    add x1, x1, #0
    add x2, x2, #3
    bl pintar_rectangulo

    add x1, x1, #3
    add x2, x2, #0
    bl pintar_rectangulo

    add x1, x1, #0
    add x2, x2, #3
    bl pintar_rectangulo

    sub x1, x1, #3
    add x2, x2, #0
    bl pintar_rectangulo

    add x1, x1, #3
    add x2, x2, #3
    bl pintar_rectangulo

    sub x1, x1, #3
    add x2, x2, #0
    bl pintar_rectangulo

    add x1, x1, #0
    add x2, x2, #3
    bl pintar_rectangulo

    sub x1, x1, #3
    add x2, x2, #0
    bl pintar_rectangulo

    add x1, x1, #0
    add x2, x2, #3
    bl pintar_rectangulo

    sub x1, x1, #3
    add x2, x2, #0
    bl pintar_rectangulo

    add x1, x1, #0
    add x2, x2, #3
    bl pintar_rectangulo

    sub x1, x1, #3
    add x2, x2, #0
    bl pintar_rectangulo

    add x1, x1, #0
    add x2, x2, #3
    bl pintar_rectangulo

    sub x1, x1, #3
    add x2, x2, #0
    bl pintar_rectangulo

    add x1, x1, #0
    add x2, x2, #2
    bl pintar_rectangulo

    add x1, x1, #3
    add x2, x2, #0
    bl pintar_rectangulo


    sub x1, x1, #3
    add x2, x2, #0
    bl pintar_rectangulo

    add x1, x1, #3
    add x2, x2, #0
    bl pintar_rectangulo

    add x1, x1, #3
    add x2, x2, #0
    bl pintar_rectangulo

    add x1, x1, #3
    add x2, x2, #0
    bl pintar_rectangulo

    add x1, x1, #3
    add x2, x2, #0
    bl pintar_rectangulo

    add x1, x1, #3
    add x2, x2, #0
    bl pintar_rectangulo

    add x1, x1, #0
    sub x2, x2, #2
    bl pintar_rectangulo



    /// Numero 5 --------- ////

    add x1, x1, #28
    sub x2, x2, #21
    bl pintar_rectangulo

    sub x1, x1, #3
    add x2, x2, #0
    bl pintar_rectangulo

    sub x1, x1, #3
    add x2, x2, #0
    bl pintar_rectangulo

    sub x1, x1, #3
    add x2, x2, #0
    bl pintar_rectangulo

    sub x1, x1, #3
    add x2, x2, #0
    bl pintar_rectangulo

    sub x1, x1, #3
    add x2, x2, #0
    bl pintar_rectangulo

    add x1, x1, #0
    add x2, x2, #3
    bl pintar_rectangulo

    add x1, x1, #3
    add x2, x2, #0
    bl pintar_rectangulo

    add x1, x1, #0
    add x2, x2, #3
    bl pintar_rectangulo

    sub x1, x1, #3
    add x2, x2, #0
    bl pintar_rectangulo

    add x1, x1, #0
    add x2, x2, #3
    bl pintar_rectangulo

    add x1, x1, #3
    add x2, x2, #0
    bl pintar_rectangulo

    add x1, x1, #3
    add x2, x2, #0
    bl pintar_rectangulo

    add x1, x1, #3
    add x2, x2, #0
    bl pintar_rectangulo

    add x1, x1, #3
    add x2, x2, #0
    bl pintar_rectangulo

    sub x1, x1, #6
    add x2, x2, #3
    bl pintar_rectangulo

    add x1, x1, #3
    add x2, x2, #0
    bl pintar_rectangulo

    add x1, x1, #3
    add x2, x2, #0
    bl pintar_rectangulo

    add x1, x1, #3
    add x2, x2, #0
    bl pintar_rectangulo

    add x1, x1, #0
    add x2, x2, #3
    bl pintar_rectangulo


    sub x1, x1, #3
    add x2, x2, #0
    bl pintar_rectangulo

    add x1, x1, #0
    add x2, x2, #3
    bl pintar_rectangulo

    add x1, x1, #3
    add x2, x2, #0
    bl pintar_rectangulo


    add x1, x1, #0
    add x2, x2, #3
    bl pintar_rectangulo

    sub x1, x1, #3
    add x2, x2, #0
    bl pintar_rectangulo

    add x1, x1, #0
    add x2, x2, #3
    bl pintar_rectangulo

    sub x1, x1, #3
    add x2, x2, #0
    bl pintar_rectangulo

    sub x1, x1, #3
    add x2, x2, #0
    bl pintar_rectangulo

    sub x1, x1, #3
    add x2, x2, #0
    bl pintar_rectangulo

    add x1, x1, #0
    sub x2, x2, #3
    bl pintar_rectangulo

    sub x1, x1, #3
    sub x2, x2, #0
    bl pintar_rectangulo

    add x1, x1, #0
    sub x2, x2, #3
    bl pintar_rectangulo

    /// finalizacion de las siglas "OdC 2025" --------------- //////

    ldp  x29, x30, [sp], #16

    ret


// ------------------------------------------------------------
// Función: dibujar_cangrejo_cuerpo
//   Dibuja un cangrejo.
// Entradas:
//   x0 = framebuffer_base
//   x1 = X_centro
//   x2 = Y_centro
//   x3 = radio
//   x10 = color
// ------------------------------------------------------------

dibujar_cangrejo_cuerpo:
    stp x29, x30, [sp, #-16]!  // Guarda x30 (LR) y x29 (FP)
// ------------------------------------------------------------
// Pos x1,x2
// ------------------------------------------------------------
    add x1, x1, #0
    mov x4, #4
    mov x3,#8
    // Cuerpo: naranja
    movz   x10, #0x5500
    movk   x10, #0x00FF, lsl #16
    bl pintar_rectangulo

    sub x1,x1,#8
    add x2,x2,#4
    mov x3,#24
    mov x4,#4
    bl pintar_rectangulo

    sub x1,x1,#4
    add x2,x2,#4

    mov x3,#32
    mov x4,#4
    bl pintar_rectangulo

    sub x1,x1,#4
    add x2,x2,#4
    mov x3,#40
    mov x4,#4
    bl pintar_rectangulo

    sub x1,x1,#4
    add x2,x2,#4
    mov x3,#48
    mov x4,#4
    bl pintar_rectangulo

    //2da mitad de la parte del cagrejo + detalle
    add x2,x2,#4
    mov x3,#48
    mov x4,#4
    movz   x10, #0xC2A7
    movk   x10, #0x00FF, lsl #16
    bl pintar_rectangulo

    mov x22,x1
    add x1,x1,#8
    //gurado esta pos ya q m intersa para los ojos q voy a poner luego y las pinzas
    mov x25,x1
    mov x26,x2
    mov x3,#32
    movz   x10, #0x5500
    movk   x10, #0x00FF, lsl #16
    bl pintar_rectangulo

    //recuperamos x1 y el color
    movz   x10, #0xC2A7
    movk   x10, #0x00FF, lsl #16
    mov x1,x22
    add x1,x1,#4
    add x2,x2,#4
    mov x3,#40
    mov x4,#4
    bl pintar_rectangulo

    add x1,x1,#4
    add x2,x2,#4
    mov x3,#32
    mov x4,#4
    bl pintar_rectangulo

    add x1,x1,#4
    add x2,x2,#4
    mov x3,#24
    mov x4,#4
    bl pintar_rectangulo

    //guardar el puntero x1 x2 importantes para dsp
    //vamos a dibular una de sus patas

    add x2,x2,#4
    mov x22,x1
    mov x23,x2
    mov x3,#8
    mov x4,#5
    movz   x10, #0x5500
    movk   x10, #0x00FF, lsl #16
    bl pintar_rectangulo

    add x2,x2,#4
    sub x1,x1,#8
    bl pintar_rectangulo

    add x2,x2,#3
    sub x1,x1,#4
    bl pintar_rectangulo

    //ahora la otra recuperamos x1 x2 inicial
    mov x1,x22
    mov x2,x23
    add x1,x1,#20
        mov x3,#8
    mov x4,#5
    bl pintar_rectangulo

    add x2,x2,#4
    add x1,x1,#8
    bl pintar_rectangulo

    add x2,x2,#3
    add x1,x1,#4
    bl pintar_rectangulo
    //nuevamente recuperamos x1 x2
    mov x1,x22
    mov x2,x23
    //pos el puntero para dibuar las otras patas mas arriba
    sub x1,x1,#8
    sub x2,x2,#8
    //guardamos este putnero ahora importante
    mov x22,x1
    mov x23,x2
    sub x1,x1,#4
    mov x3,#4
    mov x4,#4
    bl pintar_rectangulo

    sub x1,x1,#4
    add x2,x2,#4
    bl pintar_rectangulo
    //recuperamos el puntero
    mov x1,x22
    mov x2,x23
    add x1,x1,#40
    bl pintar_rectangulo
    add x1,x1,#4
    add x2,x2,#4
    bl pintar_rectangulo

    //ojos recupero el puntero q m interesaba parte negra
    mov x1,x25
    mov x2,x26
    add x1,x1,#4
    sub x2,x2,#8
    mov x3,#8
    mov x4,#8
    movz   x10, #0x0000
    movk   x10, #0x0000, lsl #16
    bl pintar_rectangulo
    //puilas parte blanca
    add x1,x1,#4
    mov x3,#4
    mov x4,#4
    movz   x10, #0xffff
    movk   x10, #0xffff, lsl #16
    bl pintar_rectangulo

    add x1,x1,#12
    mov x3,#8
    mov x4,#8
    movz   x10, #0x0000
    movk   x10, #0x0000, lsl #16
    bl pintar_rectangulo

    mov x3,#4
    mov x4,#4
    movz   x10, #0xffff
    movk   x10, #0xffff, lsl #16
    bl pintar_rectangulo

    //para hacer las pinzas recupero x25 x26
    mov x1,x25
    mov x2,x26
    sub x1,x1,#14
    sub x2,x2,#0
    mov x3,#4
    mov x4,#4
    movz   x10, #0x5500
    movk   x10, #0x00FF, lsl #16
    bl pintar_rectangulo

    sub x1,x1,#4
    sub x2,x2,#4
    mov x3,#4
    mov x4,#4
    bl pintar_rectangulo

    sub x1,x1,#6
    sub x2,x2,#5
    mov x3,#15
    mov x4,#4
    bl pintar_rectangulo

    sub x2,x2,#15
    mov x3,#8
    mov x4,#15
    bl pintar_rectangulo

    add x1,x1,#12
    mov x4,#18
    mov x3,#4
    bl pintar_rectangulo

    //dibujar las otras pinzas recupero x25 x26
    mov x1,x25
    mov x2,x26
    add x1,x1,#42
    mov x3,#4
    mov x4,#4
    bl pintar_rectangulo

    add x1,x1,#4
    sub x2,x2,#4
    bl pintar_rectangulo

    sub x1,x1,#4
    sub x2,x2,#5
    mov x3,#17
    mov x4,#4
    bl pintar_rectangulo

    sub x2,x2,#15
    mov x3,#8
    mov x4,#15
    bl pintar_rectangulo

    add x1,x1,#12
    mov x3,#6
    mov x4,#18
    bl pintar_rectangulo

    ldp x29, x30, [sp], #16     // Restaura x30

    ret

// ------------------------------------------------------------
// Función: dibujar_cuerpo_calamr
//   Dibuja el cuerpo del calamar en la posición base (x1, x2).
// Entradas:
//   x1 = x-base del calamar
//   x2 = y-base del calamar
//   x26 = color del calamar
// ------------------------------------------------------------

dibujar_cuerpo_calamar:

    stp x29, x30, [sp, #-16]!  // Guarda x30 (LR) y x29 (FP)
// ------------------------------------------------------------
// Pos: x1,x2
// ------------------------------------------------------------
    add x1, x1, #0
    mov x4, #4
    mov x3,#8
    mov x10, x26

    bl pintar_rectangulo
    //modificamos el puntero mismo alto
    sub x1, x1, #4
    add x2, x2, #4
    mov x3,#16

    bl pintar_rectangulo
//desde donde estamos no movemos el puntero de vuelta las mismas medidas
    sub x1, x1, #4
    add x2, x2, #4
    mov x3,#24

    bl pintar_rectangulo

//desde donde estamos no movemos el puntero de vuelta las mismas medidas
//modificamos el alto
    sub x1, x1, #4
    add x2, x2, #4
    mov x3,#32
    mov x4,#8

    bl pintar_rectangulo

//desde donde estamos no movemos el puntero de vuelta las mismas medidas
//tener en cuenta q a mod distinto la altura anterior
//modificamos el alto
    sub x1, x1, #4
    add x2, x2, #8
    mov x3,#40
    mov x4,#10

    bl pintar_rectangulo
//mod el puntero le damos forma
    add x1,x1,#8
    add x2,x2,#10
    mov x3,#24
    mov x4,#10

    bl pintar_rectangulo

    sub x1,x1,#4
    add x2,x2,#10
    mov x3,#32
    mov x4,#45

    bl pintar_rectangulo
//dibujarle la cintura al calamar + ojo
    mov x22,x1
    mov x23,x2
    add x1,x1,#16
    add x2,x2,#20
    movz x10, #0xffff, lsl #16
    movk x10, #0xffff            // BLANCO
    mov x3,#6
    bl pintar_circulo
    movz x10, #0x0000, lsl #16
    movk x10, #0x0000            // negro pupila 
    mov x3,#3
    bl pintar_circulo
    //recuperamos los xi correspondinetes
    mov x1,x22
    mov x2,x23
    mov x10,x26

    add x1,x1,#5
    add x2,x2,#45
    mov x3,#22
    mov x4,#4

    bl pintar_rectangulo
    add x1,x1,#2
    add x2,x2,#4
    mov x3,#18
    mov x4,#4

    bl pintar_rectangulo
    sub x1,x1,#4
    add x2,x2,#4
    mov x3,#26
    mov x4,#4

    bl pintar_rectangulo

    sub x1,x1,#4
    add x2,x2,#4
    mov x3,#36
    mov x4,#4

    bl pintar_rectangulo

    ldp x29, x30, [sp], #16     // Restaura x30

    ret

dibujar_tentaculos_calamar:

    stp x29, x30, [sp, #-16]!  // Guarda x30 (LR) y x29 (FP)
//tentaculos
    add x2,x2,#4
    mov x3,#4
    mov x4,#75
    bl pintar_rectangulo

//otro tentaculo mas un pco mas adelante

    add x1,x1,#8
    bl pintar_rectangulo
//otro tentaculo mas un pco mas adelante

    add x1,x1,#8
    bl pintar_rectangulo
//otro tentaculo mas un pco mas adelante

    add x1,x1,#8
    bl pintar_rectangulo
//otro tentaculo mas un pco mas adelante

    add x1,x1,#8
    bl pintar_rectangulo


ldp x29, x30, [sp], #16     // Restaura x30

    ret

dibujar_tentaculos_calamar_MOVIENDOSE:

    stp x29, x30, [sp, #-16]!  // Guarda x30 (LR) y x29 (FP)
//tentaculos
//creamos var aux para no perder este 'puntero importante'
    add x2,x2,#4

    mov x22,x1
    mov x23,x2
    mov x3,#4
    mov x4,#30
    bl pintar_rectangulo
//EFECTO DE ARRAQUE
    add x2,x2,#30
    sub x1,x1,#6
    mov x3,#10
    mov x4,#4
    bl pintar_rectangulo
    mov x3,#4
    mov x4,#32
    bl pintar_rectangulo

//otro tentaculo mas un pco mas adelante
//del puntero guardado
    mov x1,x22
    mov x2,x23

    add x1,x1,#8

    mov x22,x1 //puntero importante
    mov x3,#4
    mov x4,#40
    bl pintar_rectangulo

//EFECTO DE ARRAQUE
    add x2,x2,#40
    sub x1,x1,#6
    mov x3,#10
    mov x4,#4
    bl pintar_rectangulo
    mov x3,#4
    mov x4,#22
    bl pintar_rectangulo

//otro tentaculo mas un pco mas adelante efecto visual este queda como esta en reposo

    mov x1,x22
    mov x2,x23
    mov x4,#75
    add x1,x1,#8
    bl pintar_rectangulo
//otro tentaculo mas un pco mas adelante

    add x1,x1,#8
    mov x22,x1
    mov x23,x2
    mov x3,#4
    mov x4,#40
    bl pintar_rectangulo
//EFECTO DE ARRAQUE
    add x2,x2,#40
//    sub x1,x1,#6
    mov x3,#10
    mov x4,#4
    bl pintar_rectangulo
    add x1,x1,#6
    mov x3,#4
    mov x4,#22
    bl pintar_rectangulo


//otro tentaculo mas un pco mas adelante
    //recuperamos el puntero
    mov x1,x22
    mov x2,x23
    add x1,x1,#8
    mov x3,#4
    mov x4,#30
    bl pintar_rectangulo
//EFECTO DE ARRAQUE
    add x2,x2,#30
    mov x3,#10
    mov x4,#4
    bl pintar_rectangulo
    add x1,x1,#6
    mov x3,#4
    mov x4,#32
    bl pintar_rectangulo

ldp x29, x30, [sp], #16     // Restaura x30

    ret


// ------------------------------------------------------------
// Función: dibujar_pez
//   Dibuja un pez con cuerpo, dos aletas, cabeza, ojo y cola.
// Entradas:
//   x1  = xbase
//   x2  = ybase
//   x20 = framebuffer (debe estar previamente cargado)
//   x21 = color del cuerpo
//   x22 = color de las aletas
//   x23 = color del ojo
//   x24 = color de la cola
// ------------------------------------------------------------
dibujar_pez:
    stp   x29, x30, [sp, #-16]!    // guardar FP/LR
    mov   x29, sp

    // Parte 1: Cuerpo principal (rectángulo 40×20) centrado en (x1, x2)
    // Lo dibujamos desplazado (-20, -10) para centrar
    sub   x1, x1, #20       // x1 = x1 - 20
    sub   x2, x2, #10       // x2 = x2 - 10
    mov   x0, x20           // framebuffer (deberías cargarlo antes en x20 y pasarlo en x0)
    mov   x3, #40           // ancho = 40
    mov   x4, #20           // alto  = 20
    mov   x10, x25          // color cuerpo (ya cargado en w20)
    bl    pintar_rectangulo

    // Parte 2: Aleta superior (8×8), un poco arriba a la izquierda
    add   x1, x1, #4        // x1 = (x1_prev + 4)
    mov   x2, x2, lsl #0    // x2 queda con la misma fila de arriba
    sub   x2, x2, #8        // y2 = y2 - 8
    mov   x3, #8
    mov   x4, #8
    mov   x10, x21          // color aletas
    bl    pintar_rectangulo

    // Parte 3: Aleta inferior (8×8), un poco abajo a la izquierda
    add   x1, x1, #0        // x1 no cambia
    add   x2, x2, #28       // y2 = (y2_prev + 28), para quedar 8px debajo del cuerpo
    mov   x3, #8
    mov   x4, #8
    mov   x10, x21          // color aletas
    bl    pintar_rectangulo

    // Restauramos x1, x2 para la cabeza
    sub   x1, x1, #4        // regresamos x1 a posición de cuerpo + 0
    sub   x2, x2, #20       // regresamos x2 al centro original

    // Parte 4: Cabeza (rectángulo 12×12) a la derecha del cuerpo
    add   x1, x1, #40       // x1 = posición original + 20 
    mov   x2, x2            // x2 = centro original
    mov   x3, #12
    mov   x4, #12
    mov   x10, x22          // color ojo
    bl    pintar_rectangulo

    // Parte 5: Ojo (rectángulo 4×4) dentro de la cabeza, arriba a la izquierda
    sub x1, x1, #4        // x1 = (cabezaX + 2)
    sub x2, x2, #2        // y2 = (cabezaY - 2)
    mov x3, #4
    mov x4, #4
    mov x10, x23          // ojo y pupila (carga en w23)
    bl pintar_rectangulo

    // Restaurar x1, x2 a centro para la cola
    add x1, x1, #8        // x1 = cabezaX + 4
    add x2, x2, #2        // y2 = cabezaY

    // Parte 6: Cola dos rectángulos
    // Rectángulo superior de la cola (10×10)
    sub x1, x1, #52       // x1 = (cuerpoX - 32)
    mov x2, x2            // y2 = centro original
    mov x3, #10
    mov x4, #10
    mov x10, x24          // color cola (carga en w24)
    bl pintar_rectangulo

    // Rectángulo inferior de la cola (10×10), justo abajo del anterior
    add x2, x2, #10       // y2 = (colaY + 10)
    mov x3, #10
    mov x4, #10
    mov x10, x24          // color cola
    bl pintar_rectangulo

    ldp x29, x30, [sp], #16  // restaurar FP/LR
    ret


// ------------------------------------------------------------
// Función: dibujar_pez_2
//   Dibuja un pez compuesto por cuerpo, aleta, ojo y cola.
// Entradas:
//   x1  = xbase
//   x2  = ybase
//   x21 = color del cuerpo
//   x22 = color de la aleta
//   x23 = color del ojo
//   x24 = color de la cola
// ------------------------------------------------------------
dibujar_pez_2:
    stp   x29, x30, [sp, #-16]!    // guardar FP/LR
    mov   x29, sp

    //CUERPO rectángulo 30×10 en (x1, x2)
    mov x3, #30           // ancho = 30
    mov x4, #10           // alto  = 10
    mov x10, x21          // w10 = color_body
    bl pintar_rectangulo

    //Aleta
    add x1, x1, #8        // x1' = original x1 + 8
    sub x2, x2, #4        // x2' = original y2 - 4
    mov x3, #6
    mov x4, #4
    mov x10, x22          // w10 = color_fin
    bl pintar_rectangulo

    //Restaurar x2 a cuerpo: (y2 = original y2)
    add x2, x2, #4        // x2 vuelve a valor de torso

    //Ojo (4×4) en (x1+20, x2+3)
    add x1, x1, #12       // x1' = (original x1 + 8) + 12 = original x1 + 20
    add x2, x2, #3        // y2' = original y2 + 3
    mov x3, #4
    mov x4, #4
    mov x10, x23          // w10 = color_eye
    bl    pintar_rectangulo

    //Restaurar x1,x2 a cuerpo para la cola:
    sub   x1, x1, #20       // x1 = original x1
    sub   x2, x2, #3        // y2 = original y2

    //Cola (dos rectángulos 10×6 en (x1−10,x2+2) y (x1−10,x2+2+4))
    sub   x1, x1, #10       // x1' = original x1 - 10
    add   x2, x2, #2        // y2' = original y2 + 2
    mov   x3, #10
    mov   x4, #6
    mov   x10, x24          // w10 = color_tail
    bl    pintar_rectangulo

    // Parte inferior de cola
    add x2, x2, #4        // y2 = (original y2+2) + 4 = original y2 + 6
    mov x3, #10
    mov x4, #6
    mov x10, x24          // w10 = color_tail
    bl pintar_rectangulo

    ldp   x29, x30, [sp], #16   // restaurar FP/LR
    ret

pintar_arena:

    stp  x29, x30, [sp, #-16]!  

    movz x16, 0x00D1, lsl 16    // x10 = 0x00D10000
    movk x16, 0xC986, lsl 0     // x10 = 0x00D1C986  (color = 0xD1C986)

    mov x11, x1
    mov x12, x2
    mov x1, #0
    mov x2, #400
    mov x4, #80
    mov x3, SCREEN_WIDTH           // 80 filas de arena
    mov x10, x16
    bl pintar_rectangulo
    mov x1, x11
    mov x2, x12

    ldp  x29, x30, [sp], #16

    ret

// ------------------------------------------------------------
// Función: dibujar_algas
//   Dibuja un conjunto de rectángulos simulando una alga marina.
// Entradas:
//   x0 = framebuffer_base
//   x1 = X_centro
//   x2 = Y_centro
//   x10 = color (sobrescrito en esta función)
// ------------------------------------------------------------
dibujar_algas:
       
        stp x29, x30, [sp, #-16]!
        mov x29, sp


        // Establecer color verde (0x00158233)
        movk x10, #0x0015 , lsl #16
        movk x10, #0x8233

        // Primer rectángulo pequeño en la base
        mov x3, #10              // ancho
        mov x4, #10              // alto
        bl pintar_rectangulo

        // Rectángulo largo vertical, desplazado arriba y a la derecha
        mov x4, #60              
        add x1, x1, #10          // mover a la derecha
        sub x2, x2, #50          // subir
        bl pintar_rectangulo

        // Rectángulo más corto, movido arriba y a la derecha
        add x1, x1, #10
        mov x4, #40
        add x2, x2 ,#20          // bajar un poco
        bl pintar_rectangulo

        // Rectángulo delgado, hacia la derecha
        add x1, x1, #10
        add x2, x2, #10
        mov x4, #20
        bl pintar_rectangulo

        // Rectángulo mediano, arriba a la derecha
        add x1, x1, #10
        sub x2, x2, #20
        mov x4, #30
        bl pintar_rectangulo

        // Rectángulo central, bajando
        sub x1, x1, #10
        sub x2, x2, #40
        mov x4, #40
        bl pintar_rectangulo

        // Rectángulo superior derecho
        add x1, x1, #10
        sub x2, x2, #20
        bl pintar_rectangulo

        // Rectángulo pequeño, arriba a la derecha
        add x1, x1, #10
        add x2, x2, #10
        mov x4, #10
        bl pintar_rectangulo

        // Rectángulo superior izquierdo
        mov x4, #30
        sub x2, x2, #30
        bl pintar_rectangulo

        // Rama izquierda inferior
        sub x1, x1, #50
        add x2, x2, #30
        mov x4, #60
        bl pintar_rectangulo

        // Rama izquierda media
        sub x1, x1, #10
        mov x4, #40
        add x2, x2, #10
        bl pintar_rectangulo

        // Rama derecha superior
        add x1, x1, #20
        mov x4,#70
        sub x2, x2, #60
        bl pintar_rectangulo

        // Rama derecha media
        add x1, x1, #10
        add x2, x2, #10
        mov x4, #40
        bl pintar_rectangulo

        // Rama central final
        sub x1, x1, #20
        sub x2, x2, #30
        mov x4, #30
        bl pintar_rectangulo

    // Restaurar registros de frame y volver
    ldp  x29, x30, [sp], #16
    ret


// ------------------------------------------------------------
// Función: dibujar_burbujas
//   Dibuja una burbuja con efectos visuales de profundidad y brillo
// Entradas:
//   x0  = framebuffer_base (desde x20)
//   x1  = X centro
//   x2  = Y centro
//   x3  = radio
// ------------------------------------------------------------
dibujar_burbujas:

    mov x0, x20                 // Cargar framebuffer base desde x20
    stp x29, x30, [sp, #-16]!

    // Dibujar el círculo exterior con color celeste claro (0x6aa0ab)
    movz x10, #0x006a , lsl #16
    movk x10, #0xa0ab
    bl pintar_circulo          // Llamar para dibujar la burbuja principal

    // Reducir radio para dibujar un círculo interior (efecto de profundidad)
    sub x3, x3, #2            

    // Dibujar el círculo interior más oscuro (color 0x2fa4b9)
    movz x10, #0x002f , lsl #16
    movk x10, #0xa4b9
    bl pintar_circulo

    // Guardar coordenadas originales del centro
    mov x11, x1                // x11 = centro x
    mov x12, x2                // x12 = centro y

    // Calcular desplazamiento para el reflejo brillante
    lsr x4, x3, #1             // x4 = radio / 2

    // Posicionar punto brillante arriba a la izquierda
    sub x1, x1, x4             // x_bright = centro_x - radio / 2
    sub x2, x2, x4             // y_bright = centro_y - radio / 2

    // Establecer color blanco (0x00ffff, para el reflejo)
    movz x10, #0x00ff , lsl #16
    movk x10, #0xffff

    // Dibujar un pequeño rectángulo blanco simulando reflejo
    mov x4, #4                 // altura = 4
    mov x3, #4                 // ancho = 4
    bl pintar_rectangulo

    // Dibujar un segundo reflejo más abajo a la derecha
    add x1, x1, #4             // desplazar a la derecha
    sub x2, x2, #4             // desplazar arriba
    bl pintar_rectangulo

    // Restaurar registros de frame y volver
    ldp x29, x30, [sp], #16
    ret

// ------------------------------------------------------------
// Función: serie_algas
//   Dibuja una serie de 6 algas distribuidas horizontalmente.
// Entradas esperadas:
//   No recibe parámetros explícitos. Usa directamente x1, x2.
//   Asume que dibujar_algas usa x1 como xbase y x2 como ybase.
// ------------------------------------------------------------
serie_algas:

    stp  x29, x30, [sp, #-16]!  

    mov x27, #5        // Contador del ciclo
    mov x1, #40
    mov x2, #400
    bl dibujar_algas
ciclo_mover_x1:
    add x1, x1, #100       // Mover x1 40 píxeles a la derecha
    mov x2, #400
    bl dibujar_algas

    subs x27, x27, #1       // Decrementar contador y actualizar flags
    b.ne ciclo_mover_x1   // Si x5 != 0, repetir ciclo


    ldp  x29, x30, [sp], #16
    ret

// ------------------------------------------------------------
// Función: detalles_arena
//   Dibuja 4 filas de detalles decorativos en la arena, alternando
//   dos colores en pares de rectángulos pequeños.
// Entradas:
//   x1 = posición horizontal inicial (modificada dentro)
//   x2 = posición vertical inicial (modificada dentro)
// ------------------------------------------------------------
detalles_arena:
    stp  x29, x30, [sp, #-16]!

    movz x21, #0x00B9, lsl #16    // Color arena 1
    movk x21, #0xAF77, lsl #0

    movz x22, #0x00D1, lsl #16    // Color arena 2
    movk x22, #0xB886, lsl #0

    mov x9, #0                    // contador de filas

loop_detalles:
    cmp x9, #4                    // cantidad de filas
    b.ge fin_detalles

    bl dibujar_fila_detalles      // dibuja una fila de detalles

    sub x1, x1, #448              // volver a inicio horizontal (x1 original - 448)
    add x2, x2, #20               // avanzar a siguiente fila

    add x9, x9, #1
    b loop_detalles

fin_detalles:
    ldp x29, x30, [sp], #16
    ret

dibujar_fila_detalles:
    stp  x29, x30, [sp, #-16]!

    mov x11, #0                   // contador horizontal
    mov x12, x1                   // guardar X inicial

loop_pares_rectangulos:
    cmp x11, #24                  // 24 pares
    b.ge fin_fila_detalles

    mov x3, #12                   // ancho
    mov x4, #12                   // alto
    mov x10, x21                  // color 1
    bl pintar_rectangulo

    add x1, x1, #10
    mov x10, x22                  // color 2
    bl pintar_rectangulo

    add x1, x1, #28               // avanzar horizontalmente
    add x11, x11, #1
    b loop_pares_rectangulos

fin_fila_detalles:
    mov x1, x12                   // restaurar x1 original
    ldp x29, x30, [sp], #16
    ret




// DEJAR ESTA LINEA AL ULTIMO
