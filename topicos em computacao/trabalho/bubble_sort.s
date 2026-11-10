# Programa 4: bubble sort de 32 inteiros (pior caso: vetor em ordem decrescente)
# Muitos desvios condicionais e acessos a vizinhos (bom para hazards e forwarding)

.data
vetor:  .space 128

.text
main:
    la   t0, vetor
    li   s0, 32             # n
    li   t2, 0
init:
    beq  t2, s0, fim_init
    sub  t3, s0, t2         # vetor[i] = n - i
    sw   t3, 0(t0)
    addi t0, t0, 4
    addi t2, t2, 1
    j    init
fim_init:
    li   s1, 0              # i
loop_i:
    addi t0, s0, -1         # n-1
    beq  s1, t0, fim
    li   s2, 0              # j
    sub  t1, t0, s1         # limite = n-1-i
    la   s3, vetor
loop_j:
    beq  s2, t1, next_i
    lw   t2, 0(s3)          # vetor[j]
    lw   t3, 4(s3)          # vetor[j+1]
    ble  t2, t3, noswap
    sw   t3, 0(s3)
    sw   t2, 4(s3)
noswap:
    addi s3, s3, 4
    addi s2, s2, 1
    j    loop_j
next_i:
    addi s1, s1, 1
    j    loop_i
fim:
    li   a7, 10
    ecall