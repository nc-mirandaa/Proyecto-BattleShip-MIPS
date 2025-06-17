# Archivo: interfaz.asm
# Responsable: [Nathaly]
# Descripción: Código para la interfaz gráfica y controles.

.data
display_addr: .word 0x10010000
color_prueba: .word 0x00FF00   # Verde brillante

.text
main:
    # Cargar valores de prueba
    li $a0, 5          # X
    li $a1, 10         # Y
    lw $a2, color_prueba
    jal dibujar_celda

    # Mensaje de verificación
    li $v0, 4
    la $a0, mensaje_ok
    syscall

    # Terminar programa
    li $v0, 10
    syscall

# Función para dibujar una celda
dibujar_celda:
    la $t0, display_addr
    lw $t1, 0($t0)       # Dirección del display

    sll $t2, $a1, 6      # Y * 64 (16 columnas * 4 bytes)
    sll $t3, $a0, 2      # X * 4 bytes
    add $t4, $t1, $t2
    add $t4, $t4, $t3

    sw $a2, 0($t4)
    jr $ra

.data
mensaje_ok: .asciiz "Celda pintada exitosamente.\n"