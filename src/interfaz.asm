# Archivo: interfaz.asm
# Responsable: [Nathaly]
# Descripción: Código para la interfaz gráfica y controles.

.data
display_addr:     .word 0x10010000

#========= colores ===========
color_agua:       .word 0x0000FF       # Azul
color_divisor:    .word 0xFFFFFF       # Blanco

#========= mensajes ===========
msj_bienvenida: .asciiz " Bienvenida al juego Battleship\n¿Deseas empezar una partida? (s/n): "
msj_modo:       .asciiz "Selecciona el modo de juego:\n1. Persona vs Persona\n2. Persona vs CPU\nOpción: "
msj_vs_pvp:     .asciiz "\n Has elegido Persona vs Persona\n"
msj_vs_cpu:     .asciiz "\n Has elegido Persona vs CPU\n"
msj_invalido:   .asciiz "\n Opción no válida\n"

mensaje_ok:       .asciiz " Tablero completo\n"
mensaje_error:    .asciiz "️ Dirección no alineada\n"
mensaje_fuera:    .asciiz "️ Coordenadas fuera de rango\n"

.text
main:
    # Mostrar mensaje de bienvenida
    li $v0, 4
    la $a0, msj_bienvenida
    syscall

    # Leer carácter
    
    li $v0, 12
    syscall
    move $t0, $v0       # Captura la letra

    li $v0, 12          # Consumir ENTER residual
    syscall

    li $t1, 115           # 's'
    bne $t0, $t1, fin     # Si no es 's', salir


    # Pintar fondo
    jal pintar_tablero_agua

    # Mostrar opciones de modo de juego
    li $v0, 4
    la $a0, msj_modo
    syscall

    # Leer entero
    li $v0, 5
    syscall
    move $t2, $v0

    li $t3, 1
    beq $t2, $t3, modo_pvp

    li $t3, 2
    beq $t2, $t3, modo_cpu

    # Opción no válida
    li $v0, 4
    la $a0, msj_invalido
    syscall
    j fin

modo_pvp:
    li $v0, 4
    la $a0, msj_vs_pvp
    syscall
    j fin

modo_cpu:
    li $v0, 4
    la $a0, msj_vs_cpu
    syscall

fin:
    li $v0, 10
    syscall

# === Fondo con línea blanca en Y = 16 ===
pintar_tablero_agua:
    li $t1, 0x10010000

    li $t3, 0
loop_y:
    li $t4, 0
loop_x:
    li $t2, 0x0000FF        # Azul
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
