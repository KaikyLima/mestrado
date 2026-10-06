	.file	"example-for-schedule-static-clause.c"
	.section	.rodata
	.align 8
.LC0:
	.string	"Thread[%d][%lu]: Before parallel region...\n"
	.align 8
.LC1:
	.string	"Thread[%d][%lu]: After parallel region...\n"
	.text
	.globl	main
	.type	main, @function
main:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$232, %rsp
	movl	$0, -24(%rbp)
	movl	$0, -20(%rbp)
	jmp	.L2
.L3:
	movl	-20(%rbp), %eax
	cltq
	movl	-20(%rbp), %edx
	movl	%edx, -112(%rbp,%rax,4)
	movl	-20(%rbp), %eax
	cltq
	movl	-20(%rbp), %edx
	movl	%edx, -176(%rbp,%rax,4)
	movl	-20(%rbp), %eax
	cltq
	movl	$0, -240(%rbp,%rax,4)
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
	leaq	-112(%rbp), %rax
	movq	%rax, -48(%rbp)
	leaq	-176(%rbp), %rax
	movq	%rax, -40(%rbp)
	leaq	-240(%rbp), %rax
	movq	%rax, -32(%rbp)
	leaq	-48(%rbp), %rax
	movl	$4, %edx
	movq	%rax, %rsi
	movl	$main._omp_fn.0, %edi
	call	GOMP_parallel_start
	leaq	-48(%rbp), %rax
	movq	%rax, %rdi
	call	main._omp_fn.0
	call	GOMP_parallel_end
	movl	$0, %eax
	call	pthread_self
	movslq	%eax, %rbx
	call	omp_get_thread_num
	movq	%rbx, %rdx
	movl	%eax, %esi
	movl	$.LC1, %edi
	movl	$0, %eax
	call	printf
	movl	$0, %eax
	addq	$232, %rsp
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
	.string	"Thread[%d][%lu]: Working in %lu loop iteration %d * %d = %d.\n"
	.text
	.type	main._omp_fn.0, @function
main._omp_fn.0:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$56, %rsp
	movq	%rdi, -72(%rbp)
	call	omp_get_thread_num
	movl	%eax, -56(%rbp)
	movl	$0, %eax
	call	pthread_self
	movslq	%eax, %rdx
	movl	-56(%rbp), %eax
	movl	%eax, %esi
	movl	$.LC2, %edi
	movl	$0, %eax
	call	printf
	call	omp_get_num_threads
	movl	%eax, %r12d
	call	omp_get_thread_num
	movl	%eax, %r13d
	movl	$0, %ebx
.L8:
	movl	%ebx, %eax
	imull	%r12d, %eax
	addl	%r13d, %eax
	addl	%eax, %eax
	leal	2(%rax), %edx
	movl	$16, %ecx
	cmpl	$16, %edx
	cmovle	%edx, %ecx
	movl	%ecx, %r14d
	cmpl	$16, %eax
	jge	.L6
	movl	%eax, -52(%rbp)
.L7:
	movq	-72(%rbp), %rax
	movq	(%rax), %rax
	movl	-52(%rbp), %edx
	movslq	%edx, %rdx
	movl	(%rax,%rdx,4), %ecx
	movq	-72(%rbp), %rax
	movq	8(%rax), %rax
	movl	-52(%rbp), %edx
	movslq	%edx, %rdx
	movl	(%rax,%rdx,4), %eax
	imull	%eax, %ecx
	movq	-72(%rbp), %rax
	movq	16(%rax), %rax
	movl	-52(%rbp), %edx
	movslq	%edx, %rdx
	movl	%ecx, (%rax,%rdx,4)
	movq	-72(%rbp), %rax
	movq	16(%rax), %rax
	movl	-52(%rbp), %edx
	movslq	%edx, %rdx
	movl	(%rax,%rdx,4), %r15d
	movq	-72(%rbp), %rax
	movq	8(%rax), %rax
	movl	-52(%rbp), %edx
	movslq	%edx, %rdx
	movl	(%rax,%rdx,4), %eax
	movl	%eax, -76(%rbp)
	movq	-72(%rbp), %rax
	movq	(%rax), %rax
	movl	-52(%rbp), %edx
	movslq	%edx, %rdx
	movl	(%rax,%rdx,4), %esi
	movl	%esi, -80(%rbp)
	movl	$0, %eax
	call	pthread_self
	movslq	%eax, %rdx
	movl	-52(%rbp), %ecx
	movl	-56(%rbp), %eax
	movl	%r15d, (%rsp)
	movl	-76(%rbp), %r9d
	movl	-80(%rbp), %r8d
	movl	%eax, %esi
	movl	$.LC3, %edi
	movl	$0, %eax
	call	printf
	addl	$1, -52(%rbp)
	cmpl	%r14d, -52(%rbp)
	jl	.L7
	addl	$1, %ebx
	jmp	.L8
.L6:
	call	GOMP_barrier
	addq	$56, %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	ret
	.size	main._omp_fn.0, .-main._omp_fn.0
	.ident	"GCC: (Debian 4.8.4-1) 4.8.4"
	.section	.note.GNU-stack,"",@progbits
