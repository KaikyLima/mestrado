	.file	"vectoradd-omp-static.c"
	.comm	h_a,8,8
	.comm	h_b,8,8
	.comm	h_c,8,8
	.globl	partition
	.bss
	.align 4
	.type	partition, @object
	.size	partition, 4
partition:
	.zero	4
	.globl	n
	.align 4
	.type	n, @object
	.size	n, 4
n:
	.zero	4
	.section	.rodata
.LC0:
	.string	"Inicializando os arrays.\n"
	.text
	.globl	init_array
	.type	init_array, @function
init_array:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$32, %rsp
	movl	%edi, -20(%rbp)
	movq	stdout(%rip), %rax
	movq	%rax, %rcx
	movl	$25, %edx
	movl	$1, %esi
	movl	$.LC0, %edi
	call	fwrite
	movl	$0, -4(%rbp)
	jmp	.L2
.L3:
	movq	h_a(%rip), %rax
	movl	-4(%rbp), %edx
	movslq	%edx, %rdx
	salq	$2, %rdx
	addq	%rax, %rdx
	movl	.LC1(%rip), %eax
	movl	%eax, (%rdx)
	movq	h_b(%rip), %rax
	movl	-4(%rbp), %edx
	movslq	%edx, %rdx
	salq	$2, %rdx
	addq	%rax, %rdx
	movl	.LC1(%rip), %eax
	movl	%eax, (%rdx)
	addl	$1, -4(%rbp)
.L2:
	movl	-4(%rbp), %eax
	cmpl	-20(%rbp), %eax
	jl	.L3
	leave
	ret
	.size	init_array, .-init_array
	.section	.rodata
.LC2:
	.string	"h_c[%07d]: %f\n"
	.text
	.globl	print_array
	.type	print_array, @function
print_array:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$32, %rsp
	movl	%edi, -20(%rbp)
	movl	$0, -4(%rbp)
	jmp	.L5
.L6:
	movq	h_c(%rip), %rax
	movl	-4(%rbp), %edx
	movslq	%edx, %rdx
	salq	$2, %rdx
	addq	%rdx, %rax
	movss	(%rax), %xmm0
	unpcklps	%xmm0, %xmm0
	cvtps2pd	%xmm0, %xmm0
	movq	stdout(%rip), %rax
	movl	-4(%rbp), %edx
	movl	$.LC2, %esi
	movq	%rax, %rdi
	movl	$1, %eax
	call	fprintf
	addl	$1, -4(%rbp)
.L5:
	movl	-4(%rbp), %eax
	cmpl	-20(%rbp), %eax
	jl	.L6
	leave
	ret
	.size	print_array, .-print_array
	.section	.rodata
.LC4:
	.string	"Verificando o resultado.\n"
.LC5:
	.string	"Resultado Final: (%f, %f)\n"
	.text
	.globl	check_result
	.type	check_result, @function
check_result:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$32, %rsp
	movl	%edi, -20(%rbp)
	movl	.LC3(%rip), %eax
	movl	%eax, -8(%rbp)
	movq	stdout(%rip), %rax
	movq	%rax, %rcx
	movl	$25, %edx
	movl	$1, %esi
	movl	$.LC4, %edi
	call	fwrite
	movl	$0, -4(%rbp)
	jmp	.L8
.L9:
	movq	h_c(%rip), %rax
	movl	-4(%rbp), %edx
	movslq	%edx, %rdx
	salq	$2, %rdx
	addq	%rdx, %rax
	movss	(%rax), %xmm0
	movss	-8(%rbp), %xmm1
	addss	%xmm1, %xmm0
	movss	%xmm0, -8(%rbp)
	addl	$1, -4(%rbp)
.L8:
	movl	-4(%rbp), %eax
	cmpl	-20(%rbp), %eax
	jl	.L9
	cvtsi2ss	-20(%rbp), %xmm0
	movss	-8(%rbp), %xmm1
	divss	%xmm0, %xmm1
	movaps	%xmm1, %xmm0
	unpcklps	%xmm0, %xmm0
	cvtps2pd	%xmm0, %xmm1
	movss	-8(%rbp), %xmm0
	cvtps2pd	%xmm0, %xmm0
	movq	stdout(%rip), %rax
	movl	$.LC5, %esi
	movq	%rax, %rdi
	movl	$2, %eax
	call	fprintf
	leave
	ret
	.size	check_result, .-check_result
	.section	.rodata
.LC6:
	.string	"Uso: %s <size> <numthreads>\n"
	.align 8
.LC7:
	.string	"num_elementos: %d num_threads: %d\n"
	.align 8
.LC8:
	.string	"Thread[%lu]: Todas as threads terminaram...\n"
	.align 8
.LC9:
	.string	"Thread[%lu]: Imprimindo o resultado.\n"
	.align 8
.LC10:
	.string	"Thread[%lu]: Verificando o resultado.\n"
.LC11:
	.string	"Thread[%lu]: Fui, Tchau!\n"
	.text
	.globl	main
	.type	main, @function
main:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$32, %rsp
	movl	%edi, -20(%rbp)
	movq	%rsi, -32(%rbp)
	movl	$0, -4(%rbp)
	cmpl	$2, -20(%rbp)
	jg	.L11
	movq	-32(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %rsi
	movl	$.LC6, %edi
	movl	$0, %eax
	call	printf
	movl	$0, %edi
	call	exit
.L11:
	movq	-32(%rbp), %rax
	addq	$8, %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	atoi
	movl	%eax, -8(%rbp)
	movq	-32(%rbp), %rax
	addq	$16, %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	atoi
	movl	%eax, -4(%rbp)
	movl	-8(%rbp), %eax
	cltd
	idivl	-4(%rbp)
	movl	%eax, partition(%rip)
	movl	-8(%rbp), %eax
	movl	%eax, n(%rip)
	movl	-4(%rbp), %edx
	movl	-8(%rbp), %eax
	movl	%eax, %esi
	movl	$.LC7, %edi
	movl	$0, %eax
	call	printf
	movl	-8(%rbp), %eax
	cltq
	salq	$2, %rax
	movq	%rax, %rdi
	call	malloc
	movq	%rax, h_a(%rip)
	movl	-8(%rbp), %eax
	cltq
	salq	$2, %rax
	movq	%rax, %rdi
	call	malloc
	movq	%rax, h_b(%rip)
	movl	-8(%rbp), %eax
	cltq
	salq	$2, %rax
	movq	%rax, %rdi
	call	malloc
	movq	%rax, h_c(%rip)
	movl	-8(%rbp), %eax
	movl	%eax, %edi
	call	init_array
	movl	-4(%rbp), %eax
	movl	%eax, %edx
	movl	$0, %esi
	movl	$main._omp_fn.0, %edi
	call	GOMP_parallel_start
	movl	$0, %edi
	call	main._omp_fn.0
	call	GOMP_parallel_end
	movl	$0, %eax
	call	pthread_self
	cltq
	movq	%rax, %rsi
	movl	$.LC8, %edi
	movl	$0, %eax
	call	printf
	movl	$0, %eax
	call	pthread_self
	cltq
	movq	%rax, %rsi
	movl	$.LC9, %edi
	movl	$0, %eax
	call	printf
	movl	$0, %eax
	call	pthread_self
	cltq
	movq	%rax, %rsi
	movl	$.LC10, %edi
	movl	$0, %eax
	call	printf
	movl	-8(%rbp), %eax
	movl	%eax, %edi
	call	check_result
	movl	$0, %eax
	call	pthread_self
	cltq
	movq	%rax, %rsi
	movl	$.LC11, %edi
	movl	$0, %eax
	call	printf
	movl	$0, %eax
	leave
	ret
	.size	main, .-main
	.section	.rodata
	.align 8
.LC12:
	.string	"  Thread[%lu]: Particao prevista: %d [%d..%d]: %d.\n"
	.align 8
.LC13:
	.string	"  Thread[%lu]: Executando sobre particao: %d [%d..%d]: %d.\n"
.LC14:
	.string	"  Thread[%lu]: Terminando...\n"
	.text
	.type	main._omp_fn.0, @function
main._omp_fn.0:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$56, %rsp
	movq	%rdi, -56(%rbp)
	call	omp_get_thread_num
	cltq
	movq	%rax, -40(%rbp)
	movl	partition(%rip), %eax
	cltq
	imulq	-40(%rbp), %rax
	movq	%rax, -48(%rbp)
	movl	partition(%rip), %eax
	movslq	%eax, %rdx
	movq	-48(%rbp), %rax
	addq	%rdx, %rax
	movq	%rax, -24(%rbp)
	movq	-48(%rbp), %rax
	movq	-24(%rbp), %rdx
	movq	%rdx, %rbx
	subq	%rax, %rbx
	movl	$0, %eax
	call	pthread_self
	cltq
	movq	-24(%rbp), %rsi
	movq	-48(%rbp), %rcx
	movq	-40(%rbp), %rdx
	movq	%rbx, %r9
	movq	%rsi, %r8
	movq	%rax, %rsi
	movl	$.LC12, %edi
	movl	$0, %eax
	call	printf
	movl	n(%rip), %eax
	cltq
	subq	-24(%rbp), %rax
	movq	%rax, %rdx
	movl	partition(%rip), %eax
	cltq
	cmpq	%rax, %rdx
	jl	.L14
.L17:
	movq	-48(%rbp), %rax
	movq	-24(%rbp), %rdx
	movq	%rdx, %rbx
	subq	%rax, %rbx
	movl	$0, %eax
	call	pthread_self
	cltq
	movq	-24(%rbp), %rsi
	movq	-48(%rbp), %rcx
	movq	-40(%rbp), %rdx
	movq	%rbx, %r9
	movq	%rsi, %r8
	movq	%rax, %rsi
	movl	$.LC13, %edi
	movl	$0, %eax
	call	printf
	movq	-48(%rbp), %rax
	movl	%eax, -28(%rbp)
	nop
.L16:
	movl	-28(%rbp), %eax
	cltq
	cmpq	-24(%rbp), %rax
	jl	.L15
	movl	$0, %eax
	call	pthread_self
	cltq
	movq	%rax, %rsi
	movl	$.LC14, %edi
	movl	$0, %eax
	call	printf
	jmp	.L18
.L15:
	movq	h_c(%rip), %rax
	movl	-28(%rbp), %edx
	movslq	%edx, %rdx
	salq	$2, %rdx
	addq	%rdx, %rax
	movq	h_a(%rip), %rdx
	movl	-28(%rbp), %ecx
	movslq	%ecx, %rcx
	salq	$2, %rcx
	addq	%rcx, %rdx
	movss	(%rdx), %xmm1
	movq	h_b(%rip), %rdx
	movl	-28(%rbp), %ecx
	movslq	%ecx, %rcx
	salq	$2, %rcx
	addq	%rcx, %rdx
	movss	(%rdx), %xmm0
	addss	%xmm1, %xmm0
	movss	%xmm0, (%rax)
	addl	$1, -28(%rbp)
	jmp	.L16
.L14:
	movl	n(%rip), %eax
	cltq
	movq	%rax, -24(%rbp)
	jmp	.L17
.L18:
	addq	$56, %rsp
	popq	%rbx
	popq	%rbp
	ret
	.size	main._omp_fn.0, .-main._omp_fn.0
	.section	.rodata
	.align 4
.LC1:
	.long	1056964608
	.align 4
.LC3:
	.long	0
	.ident	"GCC: (Debian 4.8.4-1) 4.8.4"
	.section	.note.GNU-stack,"",@progbits
