# Archivo: interfaz.asm
# Responsable: [Nathaly]
# Descripción: Código para la interfaz gráfica y controles.

.data
display_addr: .word 0x10010000  # Dirección base del Bitmap
color_agua:    .word 0x0000FF   # Azul puro
color_barco:   .word 0x808080   # Gris
color_impacto: .word 0xFF0000   # Rojo (disparo acertado)
color_fallo:   .word 0xFFFFFF   # Blanco (disparo fallido)
color_cursor:  .word 0xFFFF00   # Amarillo (selección)

.text
main:
    # Pintar todo el tablero de agua
    jal pintar_tablero_agua
    
    # Pintar una celda de prueba (cursor en X=5, Y=10)
    li $a0, 2                  # Coordenada X
    li $a1, 3                 # Coordenada Y
    lw $a2, color_cursor       # Color amarillo
    jal dibujar_celda          # Llamar a la función
    
    # Dibujar celda en (5,7) rojo
    li $a0, 5
    li $a1, 7
    lw $a2, color_impacto
    jal dibujar_celda
    
    # Terminar programa
    li $v0, 10
    syscall

# Función para pintar el tablero de agua
pintar_tablero_agua:
    la $t0, display_addr
    lw $t1, 0($t0)            # $t1 = dirección base
    lw $t2, color_agua        # $t2 = color agua
    li $t3, 0                 # Contador Y
    
loop_y:
    li $t4, 0                 # Contador X
loop_x:
    # Calcular dirección de la celda (X + Y * 16)
    sll $t5, $t3, 4           # Y * 16
    add $t5, $t5, $t4         # X + (Y * 16)
    sll $t5, $t5, 2           # Convertir a bytes (4 bytes por píxel)
    add $t5, $t5, $t1         # Dirección final
    
    sw $t2, 0($t5)            # Pintar celda de agua
    
    addi $t4, $t4, 1          # Siguiente X
    blt $t4, 16, loop_x       # Si X < 16, repetir
    
    addi $t3, $t3, 1          # Siguiente Y
    blt $t3, 32, loop_y       # Si Y < 32, repetir
    
    jr $ra

# Función para pintar una celda específica
dibujar_celda:
    # Inputs:
    # $a0 = coordenada X (0-15)
    # $a1 = coordenada Y (0-31)
    # $a2 = color (en formato 0xRRGGBB)
    
    la $t0, display_addr     # Carga dirección base
    lw $t1, 0($t0)          # $t1 = 0x10010000
    
    # Cálculo de dirección: base + (Y * 16 * 4) + (X * 4)
    sll $t2, $a1, 6         # Y * 64 (16 columnas * 4 bytes)
    sll $t3, $a0, 2         # X * 4 bytes
    add $t4, $t1, $t2       # base + Y offset
    add $t4, $t4, $t3       # + X offset
    
    sw $a2, 0($t4)          # Almacena el color
    jr $ra