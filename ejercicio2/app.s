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


mov x0, x20     // framebuffer en 0
mov x28, #0     // SETEO EL CONTADOR EN 0
mov x18, #230   // POS X para el tiburon
mov x19, #180   // POS Y para el tiburon

///////////////////////////////////////
//LOOP DONDE OCURRE TODA LA ANIMACION//
///////////////////////////////////////

loop_principal:

    // BUCLE PARA PINTAR EL FONDO DEL mar

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

    
    // PRIMERA CAPA - Suelo Marino

    bl pintar_arena

        mov x11, x1
        mov x12, x2
        mov x1, x13
        mov x2, x14
        //bl detalles_arena
        mov x1, x11
        mov x2, x12
        sub x13, x13, #2


    // SEGUNDA CAPA - Peces

    and x11, x28, #0b011     // x11 = bits 2 de x28 (valores 0 o 4)
    cmp x11, #0
    beq l_tiburon1
    
    mov x11, x1
    mov x12, x2
    mov x1, x18
    mov x2, x19
    bl dibujar_pez
    add x1, x1, #100
    add x2, x2, #100
    bl dibujar_pez_2
    sub x1, x1, #100
    sub x2, x2, #100
    mov x1, x11
    mov x2, x12
    add x18, x18, #2
    
    



    // TERCERA CAPA - Tiburon

    and x11, x28, #0b100     // x11 = bits 2 de x28 (valores 0 o 4)
    cmp x11, #0
    beq l_tiburon1
    
    mov x11, x1
    mov x12, x2
    mov x1, x18
    mov x2, x19
    bl dibujar_tiburon2
    mov x1, x11
    mov x2, x12
    add x18, x18, #2
    b fin_tiburon
    
    l_tiburon1:
        mov x11, x1
        mov x12, x2
        mov x1, x18
        mov x2, x19
        bl dibujar_tiburon1
        mov x1, x11
        mov x2, x12
        sub x18, x18, #2

    fin_tiburon:
            

    // DELAY e INCREMENTO del contador

    add x28, x28, #1
    bl hacer_tiempo
    bl hacer_tiempo
    bl hacer_tiempo
    
    b loop_principal

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


dibujar_tiburon1:

    stp x29, x30, [sp, #-16]!  // Guarda x30 (LR) y x29 (FP)

    bl dibujar_cola1
    bl dibujar_cuerpo
    bl dibujar_ojo1
    bl dibujar_aletas1

    ldp x29, x30, [sp], #16     // Restaura x30

    ret

dibujar_tiburon2:

    stp x29, x30, [sp, #-16]!  // Guarda x30 (LR) y x29 (FP)

    bl dibujar_cola2
    bl dibujar_cuerpo
    bl dibujar_ojo2
    bl dibujar_aletas2

    ldp x29, x30, [sp], #16     // Restaura x30

    ret


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

    add x2, x2, #2
    add x1, x1, #10
    mov x10, x21
    mov x3, #4
    mov x4, #8
    bl pintar_rectangulo

    add x2, x2, #8
    mov x10, x22
    bl pintar_rectangulo

    add x1, x1,#4
    mov x10, x23
    bl pintar_rectangulo

    add x2, x2, #8
    mov x10, x22
    mov x3, #2
    bl pintar_rectangulo

    add x1, x1, #2
    mov x10, x23
    mov x3, #6
    bl pintar_rectangulo

    add x2, x2, #8
    mov x10, x22
    mov x3, #2
    bl pintar_rectangulo

    add x1, x1, #2
    mov x10, x21
    mov x3, #4
    bl pintar_rectangulo

    add x1, x1, #4
    mov x3, #6
    mov x10, x23
    bl pintar_rectangulo

    add x1, x1, #4
    sub x1, x1, #8
    add x2, x2, #8
    mov x4, #24
    mov x10, x24
    bl pintar_rectangulo

    add x2, x2, #24
    mov x4, #8
    mov x10, x25
    bl pintar_rectangulo

    add x1, x1, #4
    sub x2, x2, #24
    mov x3, #4
    mov x4, #12
    mov x10, x21
    bl pintar_rectangulo

    add x1, x1, #4
    mov x3, #24
    bl pintar_rectangulo

    add x2, x2, #8
    add x1, x1, #8
    mov x3, #16
    mov x4, #4
    mov x10, x23
    bl pintar_rectangulo

    add x2, x2, #4
    mov x10, x21
    bl pintar_rectangulo

    sub x1, x1, #10
    add x2, x2, #4
    mov x3, #4
    mov x4, #8
    mov x10, x25
    bl pintar_rectangulo

    sub x2, x2, #4
    mov x4, #4
    mov x3, #10
    mov x10, x21
    bl pintar_rectangulo

    add x2, x2, #4      // ajusto el valor de Y

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

    add x1, x1, #6
    sub x2, x2, #2
    mov x3, #2
    mov x4, #2
    bl pintar_rectangulo

    sub x1, x1, #2
    sub x2, x2, #2
    mov x3, #2
    mov x4, #2
    bl pintar_rectangulo


    add x1, x1, #4
    add x2, x2, #4


    ldp x29, x30, [sp], #16     // Restaura x30

    ret

dibujar_aletas2:

    stp x29, x30, [sp, #-16]!  // Guarda x30 (LR) y x29 (FP)


    sub x1, x1, #72
    add x2, x2, #16
    mov x10, x25
    mov x3, #8
    mov x4, #10
    bl pintar_rectangulo

    add x1, x1, #8
    mov x3, #16
    mov x10, x22
    bl pintar_rectangulo

    sub x1, x1, #14
    add x2, x2, #10
    mov x3, #18
    bl pintar_rectangulo
    
    sub x1, x1, #6
    add x2, x2, #6
    mov x3, #12
    mov x4, #8
    mov x10, x25
    bl pintar_rectangulo

    add x1, x1, #24
    sub x2, x2, #8
    mov x3, #4
    mov x4, #4
    bl pintar_rectangulo

    add x1, x1, #12
    add x2, x2, #4
    mov x3, #22
    mov x10, x22
    bl pintar_rectangulo

    add x1, x1, #4
    add x2, x2, #4
    mov x10, x25
    mov x4, #4
    mov x3, #6
    bl pintar_rectangulo

    add x1, x1, #4
    mov x10, x22
    mov x3, #8
    bl pintar_rectangulo
    
    add x2, x2, #2
    mov x10, x25
    mov x4, #1
    bl pintar_rectangulo

    add x1, x1, #8
    sub x2, x2, #2
    mov x10, x24
    mov x3, #4
    mov x4, #4
    bl pintar_rectangulo

    sub x1, x1, #4
    sub x2, x2, #2

    ldp x29, x30, [sp], #16     // Restaura x30

    ret

hacer_tiempo:
    ldr x13, =0x3FFFFFF  // Valor empírico para QEMU (probado en RPi 4)
1:
    subs x13, x13, #1
    b.ne 1b
    ret

// ---------------------------------------------------------
// Función: dibujar_bob
// Entrada:
//   x1  = X_base (esquina superior izquierda de Bob pequeño)
//   x2  = Y_base
//
// Dibuja un Bob Esponja de unos 20×30 píxeles, usando solo
// un par de rectángulos para cuerpo y ojos, y un pequeño
// rectángulo para la boca.
// ---------------------------------------------------------

// ---------------------------------------------------------
// Función: dibujar_casa_pina
// Entrada:
//   x20 = framebuffer_base (no se modifica jamás)
//   x1  = X_base (esquina superior izquierda de la casa de piña)
//   x2  = Y_base
//
// Dibuja una casa de piña de ~30×40 px, con cuerpo naranja,
// puerta marrón, ventanas celestes y hojas verdes. Cada rectángulo
// recarga X_base/Y_base desde x5/x6 para evitar “desfase”.
// ---------------------------------------------------------
dibujar_casa_pina:
    stp  x29, x30, [sp, #-16]!    // Guardar FP y LR
    mov  x29, sp

    // 1) Guardar X_base y Y_base en registros aparte para no perderlos
    mov  x22, x1        // x5 = X_base
    mov  x23, x2        // x6 = Y_base

    // ─── 2) Cuerpo de la piña (30×40) ───
    mov  x3, #30       // ancho  = 30
    mov  x4, #40       // alto   = 40
    movz x10, #0xA500  // w10 = 0x0000A500
    movk x10, #0x00FF, lsl #16
    // → w10 = 0x00FFA500 (naranja)
    bl   pintar_rectangulo
    // ─── 3) Puerta marrón (10×15) ───
    //   X = X_base + 10, Y = Y_base + 25
    add  x1, x1, #10   // x1 = X_base + 10 
    add  x2, x2, #25   // x2 = Y_base + 25
    mov  x3, #10       // ancho  = 10
    mov  x4, #15       // alto   = 15
    movz x10, #0x4513  // w10 = 0x00004513
    movk x10, #0x008B, lsl #16
    // → w10 = 0x008B4513 (marrón)
    bl   pintar_rectangulo
    // ─── 4) Ventana izquierda (6×6, celeste) ───
    //   X = X_base + 5, Y = Y_base + 10
    mov  x1, x22 //restauro el xbase
    add  x1, x1, #5    // x1 = x_base + 5
    mov  x2, x23
    add  x2, x2, #10   // x2 = Y_base + 10
    mov  x3, #6        // ancho  = 6
    mov  x4, #6        // alto   = 6
    movz x10, #0xD8E6  // w10 = 0x0000D8E6
    movk x10, #0x00AD, lsl #16
    // → w10 = 0x00ADD8E6 (celeste)
    bl   pintar_rectangulo

    // ─── 5) Ventana derecha (6×6, celeste) ───
    //   X = X_base + 19, Y = Y_base + 10
    mov  x1, x22
    add  x1, x1, #19   // x1 = X_base + 19
    mov  x2, x23
    add  x2, x2, #10   // x2 = Y_base + 10
    mov  x3, #6        // ancho  = 6
    mov  x4, #6        // alto   = 6
    movz x10, #0xD8E6
    movk x10, #0x00AD, lsl #16
    bl   pintar_rectangulo

    // ─── 6) Hoja izquierda verde (8×8) ───
    //   X = X_base + 6, Y = Y_base – 8
    mov  x1, x22
    add  x1, x1, #6    // x1 = X_base + 6
    mov  x2, x23
    sub  x2, x2, #8    // x2 = Y_base - 8
    mov  x3, #8        // ancho  = 8
    mov  x4, #8        // alto   = 8
    movz x10, #0xFF00  // w10 = 0x0000FF00
    movk x10, #0x0000, lsl #16
    // → w10 = 0x0000FF00 (verde puro)
    bl   pintar_rectangulo

    // ─── 7) Hoja central verde (8×8) ───
    //   X = X_base + 11, Y = Y_base – 12
    mov  x1, x22
    add  x1, x1, #11   // x1 = X_base + 11
    mov  x2, x23
    sub  x2, x2, #12   // x2 = Y_base - 12
    mov  x3, #8
    mov  x4, #8
    movz x10, #0xFF00
    movk x10, #0x0000, lsl #16
    bl   pintar_rectangulo

    // ─── 8) Hoja derecha verde (8×8) ───
    //   X = X_base + 16, Y = Y_base – 8
    mov  x1, x22
    add  x1, x1, #16   // x1 = X_base + 16
    mov  x2, x23
    sub  x2, x2, #8    // x2 = Y_base - 8
    mov  x3, #8
    mov  x4, #8
    movz x10, #0xFF00
    movk x10, #0x0000, lsl #16
    bl   pintar_rectangulo

    // Restaurar stack y regresar
    ldp  x29, x30, [sp], #16
    
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

detalles_arena:

        stp  x29, x30, [sp, #-16]!  

    // Inicialización de colores
    movz x21, #0x00B9, lsl #16    // Color arena 1
    movk x21, #0xAF77, lsl #0

    movz x22, #0x00D1, lsl #16    // Color arena 2
    movk x22, #0xB886, lsl #0

    // Tamaño del rectángulo
    mov x3, #12
    mov x4, #12

    mov x10, x21
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x22
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x21
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x22
    bl pintar_rectangulo

    sub x1, x1, #3
    sub x2, x2, #30
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x21          
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x22          
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x21
    bl pintar_rectangulo

    sub x1, x1, #3
    sub x2, x2, #30
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x22
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x21
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x22
    bl pintar_rectangulo

    sub x1, x1, #3
    sub x2, x2, #30
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x21
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x22
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x21
    bl pintar_rectangulo

    sub x1, x1, #3
    sub x2, x2, #30
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x22
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x21
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x22
    bl pintar_rectangulo

    sub x1, x1, #3
    sub x2, x2, #30
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x21
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x22
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x21
    bl pintar_rectangulo

    sub x1, x1, #3
    sub x2, x2, #30
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x22
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x21
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x22
    bl pintar_rectangulo

    sub x1, x1, #3
    sub x2, x2, #30
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x21
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x22
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x21
    bl pintar_rectangulo

    sub x1, x1, #3
    sub x2, x2, #30
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x22
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x21
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x22
    bl pintar_rectangulo

    sub x1, x1, #3
    sub x2, x2, #30
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x21
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x22
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x21
    bl pintar_rectangulo

    sub x1, x1, #3
    sub x2, x2, #30
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x22
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x21
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x22
    bl pintar_rectangulo

    sub x1, x1, #3
    sub x2, x2, #30
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x21
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x22
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x21
    bl pintar_rectangulo

    sub x1, x1, #3
    sub x2, x2, #30
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x22
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x21
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x22
    bl pintar_rectangulo

    sub x1, x1, #3
    sub x2, x2, #30
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x21
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x22
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x21
    bl pintar_rectangulo

    sub x1, x1, #3
    sub x2, x2, #30
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x22
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x21
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x22
    bl pintar_rectangulo

    sub x1, x1, #3
    sub x2, x2, #30
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x21
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x22
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x21
    bl pintar_rectangulo

    sub x1, x1, #3
    sub x2, x2, #30
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x22
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x21
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x22
    bl pintar_rectangulo

    sub x1, x1, #3
    sub x2, x2, #30
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x21
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x22
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x21
    bl pintar_rectangulo

    sub x1, x1, #3
    sub x2, x2, #30
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x22
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x21
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x22
    bl pintar_rectangulo

    sub x1, x1, #3
    sub x2, x2, #30
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x21
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x22
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x21
    bl pintar_rectangulo

    sub x1, x1, #3
    sub x2, x2, #30
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x22
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x21
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x22
    bl pintar_rectangulo

    sub x1, x1, #3
    sub x2, x2, #30
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x21
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x22
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x21
    bl pintar_rectangulo

    sub x1, x1, #3
    sub x2, x2, #30
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x22
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x21
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x22
    bl pintar_rectangulo

    sub x1, x1, #3
    sub x2, x2, #30
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x21
    bl pintar_rectangulo


    sub x1, x1, #630  // volvemos a inicializar los detalles pero mas abajo
    add x2, x2, #15
    mov x10, x22
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x21
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x22
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x21
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x22
    bl pintar_rectangulo

    add x1, x1, #4
    sub x2, x2, #20
    mov x10, x21
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x22
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x21
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x22
    bl pintar_rectangulo

    sub x1, x1, #3
    sub x2, x2, #30
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x21
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x22
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x21
    bl pintar_rectangulo

    sub x1, x1, #3
    sub x2, x2, #30
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x22
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x21
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x22
    bl pintar_rectangulo

    sub x1, x1, #3
    sub x2, x2, #30
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x21
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x22
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x21
    bl pintar_rectangulo

    sub x1, x1, #3
    sub x2, x2, #30
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x22
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x21
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x22
    bl pintar_rectangulo

    sub x1, x1, #3
    sub x2, x2, #30
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x21
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x22
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x21
    bl pintar_rectangulo

    sub x1, x1, #3
    sub x2, x2, #30
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x22
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x21
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x22
    bl pintar_rectangulo

    sub x1, x1, #3
    sub x2, x2, #30
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x21
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x22
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x21
    bl pintar_rectangulo

    sub x1, x1, #3
    sub x2, x2, #30
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x22
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x21
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x22
    bl pintar_rectangulo

    sub x1, x1, #3
    sub x2, x2, #30
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x21
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x22
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x21
    bl pintar_rectangulo

    sub x1, x1, #3
    sub x2, x2, #30
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x22
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x21
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x22
    bl pintar_rectangulo

    sub x1, x1, #3
    sub x2, x2, #30
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x21
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x22
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x21
    bl pintar_rectangulo

    sub x1, x1, #3
    sub x2, x2, #30
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x22
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x21
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x22
    bl pintar_rectangulo

    sub x1, x1, #3
    sub x2, x2, #30
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x21
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x22
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x21
    bl pintar_rectangulo

    sub x1, x1, #3
    sub x2, x2, #30
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x22
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x21
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x22
    bl pintar_rectangulo

    sub x1, x1, #3
    sub x2, x2, #30
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x21
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x22
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x21
    bl pintar_rectangulo

    sub x1, x1, #3
    sub x2, x2, #30
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x22
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x21
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x22
    bl pintar_rectangulo

    sub x1, x1, #3
    sub x2, x2, #30
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x21
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x22
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x21
    bl pintar_rectangulo

    sub x1, x1, #3
    sub x2, x2, #30
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x22
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x21
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x22
    bl pintar_rectangulo

    sub x1, x1, #3
    sub x2, x2, #30
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x21
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x22
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x21
    bl pintar_rectangulo

    sub x1, x1, #3
    sub x2, x2, #30
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x22
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x21
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x22
    bl pintar_rectangulo

    sub x1, x1, #3
    sub x2, x2, #30
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x21
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x22
    bl pintar_rectangulo

    sub x1, x1, #630
    sub x2, x2, #15
    mov x10, x21
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x22
    bl pintar_rectangulo

    add x1, x1, #10
    add x2, x2, #10
    mov x10, x21
    bl pintar_rectangulo

    ldp x29, x30, [sp], #16     // Restaura x30

    ret
    
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




// Función: dibujar_pez_2
//
//     x1 = xbase 
//     x2 = ybase 
//
//   Colores:
//     x21 = cuerpo  
//     x22 = aleta    
//     x23 = ojo
//     x24 = cola
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


// DEJAR ESTA LINEA AL ULTIMO
