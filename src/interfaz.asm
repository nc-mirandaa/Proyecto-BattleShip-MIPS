# Archivo: interfaz.asm
# Responsable: [Nathaly]
# Descripción: Código para la interfaz gráfica y controles.

.data
display_addr: .word 0x10010000      # Dirección base del display
color_agua:   .word 0x0000FF        # Azul puro
msg_ok:       .asciiz "Tablero pintado completamente de azul.\n"

.text
main:
    jal pintar_tablero_agua

    # Imprimir mensaje de éxito
    li $v0, 4
    la $a0, msg_ok
    syscall

    # Terminar
    li $v0, 10
    syscall

pintar_tablero_agua:
    la $t0, display_addr
    lw $t1, 0($t0)         # Dirección real del Bitmap Display
    lw $t2, color_agua     # Color azul

    li $t3, 0              # Y fila = 0
loop_y:
    li $t4, 0              # X columna = 0

loop_x:
    sll $t5, $t3, 4        # Y * 16 (fila × columnas)
    add $t5, $t5, $t4      # + X
    sll $t5, $t5, 2        # * 4 bytes por píxel
    add $t6, $t1, $t5      # Dirección final

    sw $t2, 0($t6)         # Escribir azul en la celda

    addi $t4, $t4, 1
    blt $t4, 16, loop_x

    addi $t3, $t3, 1
    blt $t3, 32, loop_y

    jr $ra