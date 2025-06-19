# Archivo: interfaz.asm
# Responsable: [Nathaly]
# Descripción: Código para la interfaz gráfica y controles.

.data
display_addr:     .word 0x10010000
color_agua:       .word 0x0000FF       # Azul
color_divisor:    .word 0xFFFFFF       # Blanco
mensaje_ok:       .asciiz "✅ Tablero completo\n"
mensaje_error:    .asciiz "⚠️ Dirección no alineada\n"
mensaje_fuera:    .asciiz "⚠️ Coordenadas fuera de rango\n"

.text
main:
    # Pintar fondo azul y línea blanca
    jal pintar_tablero_agua

    # Celda roja en (5, 5) → tablero superior (ataque)
    li $a0, 5
    li $a1, 5
    li $a2, 0xFF0000
    jal dibujar_celda

    # Celda gris en (10, 20) → tablero inferior (defensa)
    li $a0, 10
    li $a1, 20
    li $a2, 0x808080
    jal dibujar_celda

    # Mensaje de éxito
    li $v0, 4
    la $a0, mensaje_ok
    syscall

    li $v0, 10
    syscall

# === Pintar fondo + línea divisoria en Y = 16 ===
pintar_tablero_agua:
    li $t1, 0x10010000      # Dirección base

    li $t3, 0               # Y
loop_y:
    li $t4, 0               # X
loop_x:
    li $t2, 0x0000FF        # Azul por defecto
    beq $t3, 16, usar_blanco
    j pintar_pixel

usar_blanco:
    li $t2, 0xFFFFFF        # Línea divisoria

pintar_pixel:
    sll $t5, $t3, 4         # Y * 16
    add $t5, $t5, $t4
    sll $t5, $t5, 2
    add $t6, $t1, $t5
    sw $t2, 0($t6)

    addi $t4, $t4, 1
    blt $t4, 16, loop_x

    addi $t3, $t3, 1
    blt $t3, 32, loop_y

    jr $ra

# === Dibujar celda con validación ===
dibujar_celda:
    # Validar X: 0–15
    blt $a0, 0, fuera_rango
    bgt $a0, 15, fuera_rango
    # Validar Y: 0–31
    blt $a1, 0, fuera_rango
    bgt $a1, 31, fuera_rango

    li $t1, 0x10010000

    sll $t2, $a1, 4        # Y * 16
    sll $t3, $a0, 2        # X * 4
    add $t4, $t1, $t2
    add $t4, $t4, $t3

    andi $t5, $t4, 0x3
    bnez $t5, no_alineado

    sw $a2, 0($t4)
    jr $ra

fuera_rango:
    li $v0, 4
    la $a0, mensaje_fuera
    syscall
    jr $ra

no_alineado:
    li $v0, 4
    la $a0, mensaje_error
    syscall
    jr $ra