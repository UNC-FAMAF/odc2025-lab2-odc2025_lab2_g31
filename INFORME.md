Nombre y apellido 
Integrante 1: Lautaro Santino Maldonado,46845849
Integrante 2: Daniel Alejandro Rojas,46890147
Integrante 3: Martina Brida,45375590
Integrante 4: Maximo Barrionuevo Mazurkievich,46889534


Descripción ejercicio 1: 
Lo que hace es mostrar una escena de fondo del mar emulada con QEMU. Primero guarda en un registro la dirección del framebuffer que recibe para usarla de base y así poder dibujar en la pantalla. Después pinta todo el fondo de un color azul verdoso, recorriendo toda la pantalla con dos bucles, uno que va por las filas y otro por las columnas, para ir pintando pixel por pixel.
Luego va agregando más detalles, llama a funciones que pintan la arena, unas letras que dicen las siglas del laboratorio, y otras cosas como algas y detalles en la arena para que no quede tan vacío el fondo.
Después dibuja un tiburón, que está hecho por partes, como la cola, el cuerpo, el ojo y las aletas, cada una con su función, y lo pone en una posición más o menos centrada. También pinta dos calamares en distintas partes; uno tiene los tentáculos quietos y el otro los tiene moviéndose para darle más vida a la animación.
Además, aparece un cangrejo y varios peces, algunos solitos y otros en cardumen. Para los peces usan diferentes funciones y colores, armando los tonos con instrucciones que modifican los valores de color.
Todo el código está dividido en funciones para que sea más ordenado y fácil de manejar, así se puede reutilizar código y también mover o animar cada figura sin complicarse. Así queda todo más prolijo y fácil de modificar después.


Descripción ejercicio 2:
Este programa hace un dibujo animado del fondo del mar. Está hecho por capas, como si fuera un dibujo con muchas hojas superpuestas.

Primero se pinta todo de azul, como si fuera el agua del mar. Esa es la primera capa, el fondo.
Después se dibuja el suelo marino, con arena, letras, burbujas y algas. Esa es la segunda capa, que le da más vida y detalles al fondo.
Encima de eso, se dibujan peces de distintos colores. Están repartidos por la pantalla y se van moviendo un poquito en cada vuelta, como si nadaran. Esa es la tercera capa.
Y por último, se dibuja un tiburón que también se mueve. A veces cambia un poco su forma para que parezca que está nadando. Esa es la cuarta capa, que va por encima de todo.
Todo esto se repite muchas veces para que parezca que todo se está moviendo y animando. Así se crea una escena del fondo del mar, como si fuera una película dibujada.
Durante el desarrollo del programa, intentamos agregar una función para pintar un círculo en la pantalla. Pero esa función causó un problema en la animación: desde que no aparecieran lo llamado,principalmente.
Por eso tuvimos que revisar y corregir esa parte para que la animación funcione sin problemas. A veces, al agregar algo que conllevaba la llamada a la función pintar_circulo, produjo afectar cómo se dibujan las otras cosas.

Justificación instrucciones ARMv8:
Neg: sirve para negar un valor.Nos sirvio para:
+Iniciar un bucle desde -radio (centro hacia arriba/izquierda).
+Facilitar el recorrido simétrico vertical (deltaY) desde el borde superior del círculo hasta el borde inferior.
+Evitar tener que calcular 0 - radio con sub x4, xzr, x3.
cmp:Compara dos registros.Pero no guarda el resultado, solo pone banderas
subs:Hace x1 = x2 - x3, y además pone las banderas para decidir si saltar después.
b.eq=Salta si son iguales (eq = equal)
b.ne=Salta si NO son iguales (ne = not equal)
b.ge=Salta si es mayor o igual (ge = greater or equal)
bl=Es un salto a una subrutina (“branch with link”), como llamar a una función.Guarda la dirección de regreso en el registro x30 (link register, LR).
beq=Es lo mismo que b.eq — solo otra forma de escribirlo. Algunas herramientas usan una u otra.

*Algunos son no tan conocidos por ello los pongo
