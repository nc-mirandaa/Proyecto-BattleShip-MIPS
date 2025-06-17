# Archivo: interfaz.asm
# Responsable: [Nathaly]
# Descripción: Código para la interfaz gráfica y controles.

.data
display_addr:     .word 0x10010000        # Dirección base del display
color_agua:       .word 0x0000FF          # Azul
mensaje_ok:       .asciiz "✅ Celdas dibujadas exitosamente.\n"
mensaje_error:    .asciiz "⚠️ Dirección NO alineada. Revisa coordenadas.\n"
mensaje_fuera:    .asciiz "⚠️ Coordenadas X o Y fuera de rango (0–15 / 0–31).\n"

.text
main:
    # Pintar el fondo del tablero
    jal pintar_tablero_agua

    #### Celda 1: GRIS en (3, 5) ####
    li $a0, 3         # X
    li $a1, 5         # Y
    li $a2, 0x808080  # Gris
    jal dibujar_celda

    #### Celda 2: ROJA en (8, 10) ####
    li $a0, 8         # X
    li $a1, 10        # Y
    li $a2, 0xFF0000  # Rojo
    jal dibujar_celda

    # Mensaje de éxito
    li $v0, 4
    la $a0, mensaje_ok
    syscall

    # Terminar el programa
    li $v0, 10
    syscall

# === FUNCION: Pintar tablero completo de azul ===
pintar_tablero_agua:
    la $t0, display_addr
    lw $t1, 0($t0)
    lw $t2, color_agua

    li $t3, 0    # Y
loop_y:
    li $t4, 0    # X
loop_x:
    sll $t5, $t3, 4     # Y * 16
    add $t5, $t5, $t4
    sll $t5, $t5, 2     # * 4
    add $t6, $t1, $t5   # Dirección final

    sw $t2, 0($t6)

    addi $t4, $t4, 1
    blt $t4, 16, loop_x

    addi $t3, $t3, 1
    blt $t3, 32, loop_y

    jr $ra

# === FUNCION: Dibujar celda individual con validaciones ===
dibujar_celda:
    # Validar que X ($a0) esté entre 0 y 15
    blt $a0, 0, fuera_rango
    bgt $a0, 15, fuera_rango

    # Validar que Y ($a1) esté entre 0 y 31
    blt $a1, 0, fuera_rango
    bgt $a1, 31, fuera_rango

    # Cargar dirección base real // no funciona
#    la $t0, display_addr
#    lw $t1, 0($t0)

	li $t1, 0x10010000

    # Calcular desplazamiento
    sll $t2, $a1, 6       # Y * 64
    sll $t3, $a0, 2       # X * 4
    add $t4, $t1, $t2
    add $t4, $t4, $t3     # Dirección final

    # Validar alineación a 4 bytes
    andi $t5, $t4, 0x3
    bnez $t5, no_alineado

    # Pintar celda
    sw $a2, 0($t4)
    jr $ra

# === SI COORDENADAS FUERA DE RANGO ===
fuera_rango:
    li $v0, 4
    la $a0, mensaje_fuera
    syscall
    jr $ra

# === SI LA DIRECCIÓN NO ESTÁ ALINEADA ===
no_alineado:
    li $v0, 4
    la $a0, mensaje_error
    syscall
    jr $ra