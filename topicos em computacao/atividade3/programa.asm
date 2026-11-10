# Atividade 03 - preenche vetor[10] = 1..10 e soma os elementos
#
# C equivalente:
#   for (i = 0; i < 10; i++) v[i] = i + 1;
#   s = 0;
#   for (i = 0; i < 10; i++) s += v[i];
#   v[10] = s;  // endereço 40 -> 55

        addi $t0, $zero, 0      # ptr = 0
        addi $t1, $zero, 10     # N = 10
        addi $t2, $zero, 0      # i = 0

fill:   addi $t3, $t2, 1        # val = i + 1
        sw   $t3, 0($t0)        # v[i] = val
        addi $t0, $t0, 4        # próximo endereço
        addi $t2, $t2, 1        # i++
        bne  $t2, $t1, fill     # se i != 10, repete

        addi $t0, $zero, 0      # ptr = 0
        addi $t2, $zero, 0      # i = 0
        addi $s0, $zero, 0      # soma = 0

soma:   beq  $t2, $t1, fim      # se i == 10, termina a soma
        lw   $t3, 0($t0)        # lê v[i]
        add  $s0, $s0, $t3      # soma += v[i]
        addi $t0, $t0, 4        # próximo endereço
        addi $t2, $t2, 1        # i++
        j    soma               # repete a soma

fim:    sw   $s0, 40($zero)     # grava 55 no endereço 40
        lw   $t4, 40($zero)     # confere: $t4 = 55

# Fim do programa