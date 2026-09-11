	.file	"example-parallel-data-share-clauses.c"
	.section	.rodata
	.align 8
.LC0:
	.string	"Thread[%d, %lu]: Valor final de n: %d.\n"
	.text
	.globl	main
	.type	main, @function
main:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$24, %rsp
	movl	$0, -20(%rbp)
	movl	-20(%rbp), %eax
	movl	%eax, -32(%rbp)
	leaq	-32(%rbp), %rax
	movl	$0, %edx
	movq	%rax, %rsi
	movl	$main._omp_fn.0, %edi
	call	GOMP_parallel_start
	leaq	-32(%rbp), %rax
	movq	%rax, %rdi
	call	main._omp_fn.0
	call	GOMP_parallel_end
	movl	-32(%rbp), %eax
	movl	%eax, -20(%rbp)
	movl	$0, %eax
	call	pthread_self
	movslq	%eax, %rbx
	call	omp_get_thread_num
	movl	-20(%rbp), %edx
	movl	%edx, %ecx
	movq	%rbx, %rdx
	movl	%eax, %esi
	movl	$.LC0, %edi
	movl	$0, %eax
	call	printf
	movl	$0, %eax
	addq	$24, %rsp
	popq	%rbx
	popq	%rbp
	ret
	.size	main, .-main
	.section	.rodata
	.align 8
.LC1:
	.string	"Thread[%d, %lu]: Valor de n: %d antes.\n"
	.align 8
.LC2:
	.string	"Thread[%d, %lu]: Valor de n: %d depois.\n"
	.text
	.type	main._omp_fn.0, @function
main._omp_fn.0:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	call	omp_get_thread_num
	movl	%eax, -4(%rbp)
	movl	$0, %eax
	call	pthread_self
	cltq
	movq	%rax, -16(%rbp)
	movq	-24(%rbp), %rax
	movl	(%rax), %ecx
	movq	-16(%rbp), %rdx
	movl	-4(%rbp), %eax
	movl	%eax, %esi
	movl	$.LC1, %edi
	movl	$0, %eax
	call	printf
	movq	-24(%rbp), %rax
	movl	(%rax), %edx
	movl	-4(%rbp), %eax
	addl	%eax, %edx
	movq	-24(%rbp), %rax
	movl	%edx, (%rax)
	movq	-24(%rbp), %rax
	movl	(%rax), %ecx
	movq	-16(%rbp), %rdx
	movl	-4(%rbp), %eax
	movl	%eax, %esi
	movl	$.LC2, %edi
	movl	$0, %eax
	call	printf
	leave
	ret
	.size	main._omp_fn.0, .-main._omp_fn.0
	.ident	"GCC: (Debian 4.8.4-1) 4.8.4"
	.section	.note.GNU-stack,"",@progbits
