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
    // FONDO
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

    // ------------------------------
    //  ARENA
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

    // ------------------------------
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
    
