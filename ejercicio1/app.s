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

    //  bucle para representar la ARENA
    // ------------------------------
    movz    x10, 0x00D1, lsl 16    // x10 = 0x00D10000
    movk    x10, 0xC986, lsl 0     // x10 = 0x00D1C986  (color = 0xD1C986)

    // Calcular desplazamiento a la fila 400: (400 * 640 * 4)
    mov     x1, #400
    lsl     x12, x1, #9            // x12 = 400 * 512
    lsl     x13, x1, #7            // x13 = 400 * 128
    add     x12, x12, x13          // x12 = 400 * 640
    lsl     x12, x12, #2           // x12 = 400 * 640 * 4 bytes

    add     x0, x20, x12           // x0 = framebuffer + offset fila 400
    mov     x2, #80                // 80 filas de arena

arena_loop_y:
    mov     x1, SCREEN_WIDTH       // 640 columnas
arena_loop_x:
    stur    w10, [x0]
    add     x0, x0, #4
    subs    x1, x1, #1
    b.ne    arena_loop_x
    subs    x2, x2, #1
    b.ne    arena_loop_y

    // ------------------------------
    // ALGA HORIZONTAL(prueba) de 80×20
    // ------------------------------
    movz    x10, 0x002F, lsl 16    // x10 = 0x002F0000
    movk    x10, 0x7E41, lsl 0     // x10 = 0x002F7E41  (color = 0x2F7E41)

    // Parámetros alga horizontal: X0=100, Y0=200, ancho=80, alto=20
    mov     x1, #100               // X0
    mov     x2, #200               // Y0
    mov     x3, #80                // ancho = 80
    mov     x4, #20                // alto  = 20
    bl      pintar_rectangulo

    // --------------------------
    // PRIMERA HOJA ALGA1 de 10×80 
    // ------------------------------
    // Reutilizamos el mismo color en x10
    // Parámetros alga vertical: X0=300, Y0=200, ancho=10, alto=80
    mov     x1, #300               // X0 (por ejemplo, más a la derecha)
    mov     x2, #200               // Y0
    mov     x3, #10                // ancho = 20 (más estrecho)
    mov     x4, #80                // alto  = 80 (más alto)
    bl      pintar_rectangulo
    //------------------------
    // SEGUNDA HOJA ALGA1 10X80
    // ------------------------------
    // Parámetros alga vertical: X0=290, Y0=120, ancho=10, alto=80
    mov     x1, #290               // X0 (por ejemplo, más a la derecha)
    mov     x2, #120               // Y0
    mov     x3, #10                // ancho = 20 (más estrecho)
    mov     x4, #80                // alto  = 80 (más alto)
    bl      pintar_rectangulo
    //------------------------
    // TERCERA HOJA ALGA1 10X80
    // ------------------------------
    // Parámetros alga vertical: X0=300, Y0=40, ancho=10, alto=80
    mov     x1, #300              // X0 (por ejemplo, más a la derecha)
    mov     x2, #40               // Y0
    mov     x3, #10                // ancho = 20 
    mov     x4, #80                // alto  = 80
    bl      pintar_rectangulo


    // ------ Círculo de tamano radio 20 ------
    mov     x0, x20             // framebuffer_base
    mov     x1, #200            // X_centro
    mov     x2, #120            // Y_centro
    mov     x3, #20             // radio en píxeles
    mov     x10, #0xFFFFFF      // color blanco
    bl      pintar_circulo

    // ------ Círculo de tamano radio 10
    mov     x0, x20             // framebuffer_base
    mov     x1, #300            // X_centro
    mov     x2, #200            // Y_centro
    mov     x3, #10             // radio = 10
    mov     x10, #0x0000FF      // color azul
    bl      pintar_circulo


    // TIBURON ANIMADO

    mov x0, x20
    mov x1, #240
    mov x2, #200
 
    bl dibujar_cola1
    bl dibujar_cuerpo
    bl dibujar_ojo1
    bl dibujar_aletas1

    mov x0, x20
    mov x1, #220
    mov x2, #200
    movz    x26, 0x00D1, lsl 16    // x10 = 0x00D10000
    movk    x26, 0xC986, lsl 0     // x10 = 0x00D1C986
    bl dibujar_cuerpo_calamar
    bl dibujar_tentaculos_calamar

    mov x1, #220
    mov x2, #150
    bl dibujar_cangrejo_cuerpo

    

    // AQUI LLAMAR A TU FUNCION QUE HACE TU dibujo 

    bl dibujar_XXXXXX

    //

    mov x1, #0
    mov x2, #400
    bl detalles_arena


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
    // Guardar ancho y alto en registros temporales
    mov     x5, x3           // x5 = ancho
    mov     x6, x4           // x6 = alto

    // Calcular dirección inicial (X0,Y0):
    // offset_bytes = ((Y0 * SCREEN_WIDTH) + X0) * 4
    lsl     x12, x2, #9      // x12 = Y0 * 512
    lsl     x13, x2, #7      // x13 = Y0 * 128
    add     x12, x12, x13    // x12 = Y0 * 640
    add     x12, x12, x1     // x12 = Y0*640 + X0
    lsl     x12, x12, #2     // x12 = (Y0*640 + X0) * 4
    add     x12, x20, x12    // x12 = framebuffer + offset

    mov     x11, x6          // x11 = filas restantes (alto)
    mov     x7,  x5          // x7  = columnas restantes (ancho)

pintar_filas:
    mov     x13, x7          // x13 = contador de columnas (ancho)
    mov     x14, x12         // puntero actual en la fila

pintar_columnas:
    stur    w10, [x14]       // escribir color
    add     x14, x14, #4     // avanzar 1 píxel en X
    subs    x13, x13, #1
    b.ne    pintar_columnas

    // Siguiente fila: sumar SCREEN_WIDTH * 4 bytes = 640*4
    add     x12, x12, #(SCREEN_WIDTH * 4)
    subs    x11, x11, #1
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
    // calcular r^2
    mul     x11, x3, x3         // x11 = radio^2

    // deltaY = -radio
    mov     x5, x3
    neg     x5, x5              // x5 = -radio

ciclo_filas_circulo:
    cmp     x5, x3
    b.gt    fin_circulo         // si deltaY > radio, terminamos

    // dy2 = deltaY^2
    mul     x6, x5, x5          // x6 = dy^2

    // deltaX = -radio
    mov     x7, x3
    neg     x7, x7              // x7 = -radio

ciclo_columnas_circulo:
    cmp     x7, x3
    b.gt    siguiente_fila      // si deltaX > radio, pasamos a la siguiente fila

    // dx2 = deltaX^2
    mul     x8, x7, x7          // x8 = dx^2

    // suma = dx^2 + dy^2
    add     x9, x6, x8
    cmp     x9, x11
    b.gt    continuar_columna   // si fuera mayor que r^2, no pintamos

    // ---------------------------
    // Pintar el píxel en (X_centro + deltaX, Y_centro + deltaY)
    // Verificamos límites: 0 ≤ X < 640, 0 ≤ Y < 480
    // ---------------------------
    add     x12, x1, x7         // X_actual = X_centro + deltaX
    cmp     x12, #0
    blt     continuar_columna
    cmp     x12, #639           // SCREEN_WIDTH - 1
    bgt     continuar_columna

    add     x13, x2, x5         // Y_actual = Y_centro + deltaY
    cmp     x13, #0
    blt     continuar_columna
    cmp     x13, #479           // SCREEN_HEIGHT - 1
    bgt     continuar_columna

    // offset_bytes = ((Y_actual * SCREEN_WIDTH) + X_actual) * 4
    lsl     x14, x13, #9        // Y_actual * 512
    lsl     x15, x13, #7        // Y_actual * 128
    add     x14, x14, x15       // x14 = Y_actual * 640
    add     x14, x14, x12       // x14 = Y_actual*640 + X_actual
    lsl     x14, x14, #2        // x14 = ((Y_actual*640)+X_actual)*4
    add     x14, x0, x14        // x14 = &pixel(Y_actual,X_actual)

    stur    w10, [x14]          // escribimos color

continuar_columna:
    add     x7, x7, #1          // deltaX++
    b       ciclo_columnas_circulo

siguiente_fila:
    add     x5, x5, #1          // deltaY++
    b       ciclo_filas_circulo

fin_circulo:
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

dibujar_aletas2:

    ret

hacer_tiempo:
    ldr x0, =0x3FFFFFF  // Valor empírico para QEMU (probado en RPi 4)
1:
    subs x0, x0, #1
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

dibujar_bob:
    stp  x29, x30, [sp, #-16]!    // Guardar FP y LR
    mov  x29, sp
    mov x22,x1 //nos facilita no tener q recaclular la pos inicial
    mov x23,x2 //tmb lo guardamos

    // 1. Cuerpo amarillo (20×30)
    mov  x3, #20        // ancho
    mov  x4, #30        // alto
    movz x10, #0xF700   // w10 = 0x0000FF00 (byte alto = 0x00FF)
    movk x10, #0x00FF, lsl #16
    // → w10 final = 0x00FFFF00 (amarillo)
    bl   pintar_rectangulo

    // 2. Ojos 
    // Ojo izquierdo, desplazado 4px a derecha y 6px abajo dentro del cuerpo
    add  x1, x1, #4     // x = X_base + 4
    add  x2, x2, #6     // y = Y_base + 6
    mov  x3, #4
    mov  x4, #4
    movz x10, #0xFFFF   // w10 = 0xFFFFFF
    movk x10, #0x00FF, lsl #16
    // → w10 final = 0x00FFFFFF (blanco)
    bl   pintar_rectangulo

    // Ojo der 10px a la derecha de X_base (4 + 6)
    add  x1, x1, #8     // x = (X_base + 4) + 6 = X_base + 10 (tenemos en cuenta la usma anterior)
    // y sigue siendo Y_base + 6 no se modifica esta donde nos interesa
    mov  x3, #4
    mov  x4, #4
    movz x10, #0xFFFF
    movk x10, #0x00FF, lsl #16
    bl   pintar_rectangulo

    // 3. Boca (6×2)
    // Restaurar x1 a X_base + 7 (aprox centro menos 3px)
    sub  x1, x1, #10    // x = (X_base + 10) - 10 = X_base
    add  x1, x1, #7     // x = X_base + 7
    // y = Y_base + 20 (parte inferior del cuerpo, 30 - 8)
    sub  x2, x2, #6     // x2 = (Y_base + 6) - 6 = Y_base
    add  x2, x2, #20    // x2 = Y_base + 20
    mov  x3, #6
    mov  x4, #2
    movz x10, #0x0000   // w10 = 0x00000000 (negro)
    movk x10, #0x0000, lsl #16
    bl   pintar_rectangulo

    //4 Pantalones azules (20x10)
    //necesito posicionarme 30 pixeles abajo de la pos nicial
    mov x1, x22
    mov x2, x23
    add x2, x2, #30
    add x3, x3, #15
    add x4, x4, #5
    movz x10, #0x00FF   // w10 =(azul)
    movk x10, #0x0000, lsl #16
    bl   pintar_rectangulo


    //5 piernas
    //desde x2 solo bajamos 9 pixeles para hacer las piernas
    add x2, x2, #9
    add x1,x1,#3
    mov x3,#3
    mov x4,#10
    movz x10, #0xF700   // w10 = 0x0000FF00 (byte alto = 0x00FF)
    movk x10, #0x00FF, lsl #16
    bl pintar_rectangulo


    //la otra pierna solo sumamos x1
    add x1, x1, #12
    bl pintar_rectangulo
    // Restaurar stack y salir
    ldp  x29, x30, [sp], #16
    ret


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

// 
    //Dibujar algas //
    dibujar_algas:

        //158233 = verde
        movk x10, #0x0015 , lsl #16
        movk x10, #0x8233

        
        mov x3, #10
        mov x4, #10
        bl pintar_rectangulo 

        
        mov x4, #60  
        add x1, x1, #10
        sub x2, x2, #50
        bl pintar_rectangulo

        add x1, x1, #10
        mov x4, #40
        add x2, x2 ,#20
        bl pintar_rectangulo


        add x1, x1, #10
        add x2, x2, #10
        mov x4, #20
        bl pintar_rectangulo

        add x1, x1, #10
        sub x2, x2, #20
        mov x4, #30
        bl pintar_rectangulo

        sub x1, x1, #10
        sub x2, x2, #40
        mov x4, #40
        bl pintar_rectangulo

        add x1, x1, #10
        sub x2, x2, #20
        bl pintar_rectangulo


        add x1, x1, #10
        add x2, x2, #10
        mov x4, #10
        bl pintar_rectangulo


        mov x4, #30
        sub x2, x2, #30
        bl pintar_rectangulo

        movk x10, #0x0015 , lsl #16
        movk x10, #0x8233

        sub x1, x1, #50
        add x2, x2, #30
        mov x4, #60
        bl pintar_rectangulo


        sub x1, x1, #10
        mov x4, #40
        add x2, x2, #10
        bl pintar_rectangulo


        add x1, x1, #20
        mov x4,#70
        sub x2, x2, #60
        bl pintar_rectangulo


        add x1, x1, #10
        add x2, x2, #10
        mov x4, #40
        bl pintar_rectangulo



        sub x1, x1, #20
        sub x2, x2, #30
        mov x4, #30
        bl pintar_rectangulo

    // Restaurar stack y regresar
    ldp  x29, x30, [sp], #16
    ret

//

//HACER BURBUJAS

dibujar_burbujas:
    // Entradas: x1 = x_center, x2 = y_center, x3 = radio
    // Usa un color celeste claro para la burbuja

    mov x0, x20                 // framebuffer base


    // Color celeste (6aa0ab)
    movz x10, #0x006a , lsl #16
    movk x10, #0xa0ab

    bl pintar_circulo

    sub x3, x3, #2

    //2fa4b9
    movz x10, #0x002f , lsl #16
    movk x10, #0xa4b9

    bl pintar_circulo    

    mov x11, x1      // x11 = centro x
    mov x12, x2      // x12 = centro y 


    lsr x4, x3, #1         // x4 = radius / 2

    sub x1, x1, x4         // x_bright = x_center + radius / 2
    sub x2, x2, x4         // y_bright = y_center - radius / 2

    movz x10, #0x00ff , lsl #16
    movk x10, #0xffff

    mov x4, #4
    mov x3, #4

    bl pintar_rectangulo

    add x1, x1, #4
    sub x2, x2, #4

    bl pintar_rectangulo
    
    
    ldp x29, x30, [sp], #16
    
    
    ret

//








dibujar_XXXXXX:

    stp  x29, x30, [sp, #-16]!  

    // DEFINI TUS COLORES

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


    mov x1, #0            // luego borrar estas lineas una vez inicializado
    mov x2, #0            // idem

    //-------DEFINI TU FUNCION AQUI-------

    ldp  x29, x30, [sp], #16

    ret

detalles_arena:

    stp  x29, x30, [sp, #-16]!  

    // DEFINI TUS COLORES

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


    mov x1, #0            // luego borrar estas lineas una vez inicializado
    mov x2, #0            // idem

    //-------DEFINI TU FUNCION AQUI-------

    ldp  x29, x30, [sp], #16


    ret


//FUNCION CANGREJO X1=XBASE X2=YBASE color ya definido
dibujar_cangrejo_cuerpo:


    stp x29, x30, [sp, #-16]!  // Guarda x30 (LR) y x29 (FP)
//POS xbase=x1 ybase=x2
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
    //

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

//FUNCION DUBIJAR CUERPO + TENTACULO CALAMAR -----------------------
//dibuja el cuerpo del calamar mas abajo esta la fucnion que dibuja
//los tentaculos son fucniones distintas pero se llaman ambas para dibujar el
//calamar completo, se modulariza asi para hacer mas facil la animacion
//x1=xbase del calamar
//x2=ybase del calamr 
//x26=color del calamar



dibujar_cuerpo_calamar:

    stp x29, x30, [sp, #-16]!  // Guarda x30 (LR) y x29 (FP)
//POS xbase=x1 ybase=x2
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
