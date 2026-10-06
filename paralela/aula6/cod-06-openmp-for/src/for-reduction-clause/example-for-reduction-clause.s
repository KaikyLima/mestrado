	.file	"example-for-reduction-clause.c"
	.section	.rodata
	.align 8
.LC0:
	.string	"Thread[%d][%lu]: Before parallel region...\n"
	.align 8
.LC1:
	.string	"Thread[%d][%lu]: After parallel region dot: %d...\n"
	.text
	.globl	main
	.type	main, @function
main:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$184, %rsp
	movl	$0, -24(%rbp)
	movl	$0, -20(%rbp)
	jmp	.L2
.L3:
	movl	-20(%rbp), %eax
	cltq
	movl	-20(%rbp), %edx
	movl	%edx, -128(%rbp,%rax,4)
	movl	-20(%rbp), %eax
	cltq
	movl	-20(%rbp), %edx
	movl	%edx, -192(%rbp,%rax,4)
	addl	$1, -20(%rbp)
.L2:
	cmpl	$15, -20(%rbp)
	jle	.L3
	movl	$0, %eax
	call	pthread_self
	movslq	%eax, %rbx
	call	omp_get_thread_num
	movq	%rbx, %rdx
	movl	%eax, %esi
	movl	$.LC0, %edi
	movl	$0, %eax
	call	printf
	leaq	-128(%rbp), %rax
	movq	%rax, -64(%rbp)
	leaq	-192(%rbp), %rax
	movq	%rax, -56(%rbp)
	movl	-28(%rbp), %eax
	movl	%eax, -48(%rbp)
	movl	-24(%rbp), %eax
	movl	%eax, -44(%rbp)
	leaq	-64(%rbp), %rax
	movl	$0, %edx
	movq	%rax, %rsi
	movl	$main._omp_fn.0, %edi
	call	GOMP_parallel_start
	leaq	-64(%rbp), %rax
	movq	%rax, %rdi
	call	main._omp_fn.0
	call	GOMP_parallel_end
	movl	-48(%rbp), %eax
	movl	%eax, -28(%rbp)
	movl	-44(%rbp), %eax
	movl	%eax, -24(%rbp)
	movl	$0, %eax
	call	pthread_self
	movslq	%eax, %rbx
	call	omp_get_thread_num
	movl	-24(%rbp), %edx
	movl	%edx, %ecx
	movq	%rbx, %rdx
	movl	%eax, %esi
	movl	$.LC1, %edi
	movl	$0, %eax
	call	printf
	movl	$0, %eax
	addq	$184, %rsp
	popq	%rbx
	popq	%rbp
	ret
	.size	main, .-main
	.section	.rodata
	.align 8
.LC2:
	.string	"Thread[%d][%lu]: Threading starting...\n"
	.align 8
.LC3:
	.string	"Thread[%d][%lu]: Working in %lu loop iteration %d * %d = %d -> %d.\n"
	.align 8
.LC4:
	.string	"Thread[%d][%lu]: dot at the loop final: %d.\n"
	.text
	.type	main._omp_fn.0, @function
main._omp_fn.0:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$48, %rsp
	movq	%rdi, -56(%rbp)
	call	omp_get_thread_num
	movq	-56(%rbp), %rdx
	movl	%eax, 16(%rdx)
	movl	$0, %eax
	call	pthread_self
	movslq	%eax, %rdx
	movq	-56(%rbp), %rax
	movl	16(%rax), %eax
	movl	%eax, %esi
	movl	$.LC2, %edi
	movl	$0, %eax
	call	printf
	movl	$0, -36(%rbp)
	call	omp_get_num_threads
	movl	%eax, %ebx
	call	omp_get_thread_num
	movl	%eax, %esi
	movl	$16, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ecx
	movl	$16, %eax
	cltd
	idivl	%ebx
	movl	%edx, %eax
	cmpl	%eax, %esi
	jl	.L6
.L11:
	imull	%ecx, %esi
	movl	%esi, %edx
	addl	%edx, %eax
	leal	(%rax,%rcx), %ebx
	cmpl	%ebx, %eax
	jge	.L7
	movl	%eax, -40(%rbp)
.L8:
	movq	-56(%rbp), %rax
	movq	(%rax), %rax
	movl	-40(%rbp), %edx
	movslq	%edx, %rdx
	movl	(%rax,%rdx,4), %ecx
	movq	-56(%rbp), %rax
	movq	8(%rax), %rax
	movl	-40(%rbp), %edx
	movslq	%edx, %rdx
	movl	(%rax,%rdx,4), %eax
	imull	%ecx, %eax
	addl	%eax, -36(%rbp)
	movq	-56(%rbp), %rax
	movq	(%rax), %rax
	movl	-40(%rbp), %edx
	movslq	%edx, %rdx
	movl	(%rax,%rdx,4), %ecx
	movq	-56(%rbp), %rax
	movq	8(%rax), %rax
	movl	-40(%rbp), %edx
	movslq	%edx, %rdx
	movl	(%rax,%rdx,4), %eax
	imull	%eax, %ecx
	movl	%ecx, %r12d
	movq	-56(%rbp), %rax
	movq	8(%rax), %rax
	movl	-40(%rbp), %edx
	movslq	%edx, %rdx
	movl	(%rax,%rdx,4), %r14d
	movq	-56(%rbp), %rax
	movq	(%rax), %rax
	movl	-40(%rbp), %edx
	movslq	%edx, %rdx
	movl	(%rax,%rdx,4), %r13d
	movl	$0, %eax
	call	pthread_self
	movslq	%eax, %rdx
	movq	-56(%rbp), %rax
	movl	16(%rax), %eax
	movl	-40(%rbp), %ecx
	movl	-36(%rbp), %esi
	movl	%esi, 8(%rsp)
	movl	%r12d, (%rsp)
	movl	%r14d, %r9d
	movl	%r13d, %r8d
	movl	%eax, %esi
	movl	$.LC3, %edi
	movl	$0, %eax
	call	printf
	addl	$1, -40(%rbp)
	cmpl	%ebx, -40(%rbp)
	jl	.L8
.L7:
	movq	-56(%rbp), %rax
	leaq	20(%rax), %rdx
	movl	-36(%rbp), %eax
	lock addl	%eax, (%rdx)
	call	GOMP_barrier
	call	omp_get_thread_num
	testl	%eax, %eax
	jne	.L5
	movl	$0, %eax
	call	pthread_self
	movslq	%eax, %rbx
	call	omp_get_thread_num
	movq	-56(%rbp), %rdx
	movl	20(%rdx), %edx
	movl	%edx, %ecx
	movq	%rbx, %rdx
	movl	%eax, %esi
	movl	$.LC4, %edi
	movl	$0, %eax
	call	printf
	jmp	.L5
.L6:
	movl	$0, %eax
	addl	$1, %ecx
	jmp	.L11
.L5:
	addq	$48, %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%rbp
	ret
	.size	main._omp_fn.0, .-main._omp_fn.0
	.ident	"GCC: (Debian 4.8.4-1) 4.8.4"
	.section	.note.GNU-stack,"",@progbits
