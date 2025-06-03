    .equ SCREEN_WIDTH,     640
    .equ SCREEN_HEIGHT,    480
    .equ BITS_PER_PIXEL,   32

    .equ GPIO_BASE,        0x3f200000
    .equ GPIO_GPFSEL0,     0x00
    .equ GPIO_GPLEV0,      0x34

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

    // TIBURON ANIMADO


 
    bl dibujar_cuerpo
    bl dibujar_ojo1
    bl dibujar_cola1
    bl dibujar_aletas1

    bl hacer_tiempo

    //repetir en distintas posiciones de x e y
    add x2, x2, #4
    add x1, x1, #4
    bl dibujar_cuerpo
    bl dibujar_ojo2
    //bl dibujar_cola2
    //dibujar_aletas2

   


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

    // TIBURON_COLA
    mov x0, x20
    mov x1, #240
    mov x2, #180
    mov x10, x21
    mov x3, #8
    mov x4, #8
    bl pintar_rectangulo

    mov x1, #240
    add x2, x2, #8
    mov x10, x22
    mov x3, #8
    mov x4, #8
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

    // PINTAR CUERPO

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
    mov x4, #4
    mov x10, x16
    bl pintar_rectangulo

    add x2, x2, #4
    mov x10, x27
    bl pintar_rectangulo

    sub x2, x2, #8
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

    ret


dibujar_aletas1:

    sub x1, x1, #96
    add x2, x2, #20

    ret

dibujar_cola1:

    ret

dibujar_ojo1:

    sub x1, x1, #24
    mov x10, x25
    mov x3, #8
    mov x4, #6
    bl pintar_rectangulo

    sub x1, x1, #2
    mov x3, #2
    mov x4, #2
    bl pintar_rectangulo

    ret


dibujar_ojo2:

    sub x1, x1, #24
    mov x10, x25
    mov x3, #8
    mov x4, #6
    bl pintar_rectangulo

    add x1, x1, #8
    mov x3, #2
    mov x4, #2
    bl pintar_rectangulo

    ret

hacer_tiempo:
    mov x18, #0xff
    sub x18, x18, #1
    cbnz x18, hacer_tiempo
    ret
