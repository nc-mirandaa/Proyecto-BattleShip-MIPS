# Archivo: interfaz.asm
# Responsable: [Nathaly]
# Descripción: Código para la interfaz gráfica y controles.

.data
display_addr:     .word 0x10010000        # Dirección base del display

#colores
color_agua: .word 0x0000FF  # Azul
color_borde: .word 0x000000 # Negro
color_barco: .word 0x808080 # Gris
color_selec: .word 0xFFFF00 # Amarillo
color_impacto: .word 0xFF0000 # Rojo
color_fallo: .word 0xFFFFFF # Blanco

# Tablero del jugador (16x16) - 0=agua, 1-4=barcos
tablero_jugador: .space 256

# Variable para el modo de juego (0=PvP, 1=PvCPU)
modo_juego: .word 


# Mensajes del menú de modo de juego
msg_bienvenida: .asciiz "=== BATTLESHIP GAME ===\n"
msg_seleccionar_modo: .asciiz "Selecciona el modo de juego:\n"
msg_opcion_pvp: .asciiz "1. PvP (Jugador vs Jugador)\n"
msg_opcion_pvcpu: .asciiz "2. PvCPU (Jugador vs CPU)\n"
msg_ingrese_opcion: .asciiz "Ingrese su opcion (1 o 2): "
msg_opcion_invalida: .asciiz "Opcion invalida. Intente nuevamente.\n"
msg_modo_pvp: .asciiz "Modo PvP seleccionado!\n"
msg_modo_pvcpu: .asciiz "Modo PvCPU seleccionado!\n"

# Mensajes existentes
msg_colocar: .asciiz "Colocando barco de tamaño "
msg_de_4: .asciiz " (barco "
msg_de_total: .asciiz " de 4)\n"
msg_controles: .asciiz "Controles: WASD=mover, R=rotar, E=colocar\n"
msg_error_pos: .asciiz "Posicion invalida o ocupada!\n"
msg_barco_colocado: .asciiz "Barco colocado correctamente!\n"
msg_todos_colocados: .asciiz "Todos los barcos han sido colocados!\n"

.text
.globl main

main:
    # Pintar el fondo del tablero
    jal pintar_tablero_agua
    
    #Menu
    jal mostrar_menu_modo
    jal seleccionar_modo


    # Terminar el programa
    li $v0, 10
    syscall

#//////////////////////////////////////////////////

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
    

# Subrutina para mostrar el menú de modo de juego
mostrar_menu_modo:
li $v0, 4
la $a0, msg_bienvenida
syscall

li $v0, 4
la $a0, msg_seleccionar_modo
syscall

li $v0, 4
la $a0, msg_opcion_pvp
syscall

li $v0, 4
la $a0, msg_opcion_pvcpu
syscall

jr $ra


#/////////////// probar primero porque no funciona el menu ///////////////////////

# Subrutina para seleccionar el modo de juego
seleccionar_modo:
seleccionar_modo_loop:
li $v0, 4
la $a0, msg_ingrese_opcion
syscall

# Leer opción del usuario
li $v0, 5
syscall
move $t0, $v0

# Verificar opción válida (1 o 2)
li $t1, 1
beq $t0, $t1, modo_seleccionado_pvp
li $t1, 2
beq $t0, $t1, modo_seleccionado_pvcpu

# Opción inválida
li $v0, 4
la $a0, msg_opcion_invalida
syscall
j seleccionar_modo_loop

modo_seleccionado_pvp:
li $t0, 0 # 0 = PvP
sw $t0, modo_juego
li $v0, 4
la $a0, msg_modo_pvp
syscall
jr $ra

modo_seleccionado_pvcpu:
li $t0, 1 # 1 = PvCPU
sw $t0, modo_juego
li $v0, 4
la $a0, msg_modo_pvcpu
syscall
jr $ra
