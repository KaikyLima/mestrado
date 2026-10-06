	.file	"example-for-schedule-dynamic-clause.c"
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
	subq	$248, %rsp
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
	movl	-20(%rbp), %eax
	cltq
	movl	$0, -256(%rbp,%rax,4)
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
	leaq	-256(%rbp), %rax
	movq	%rax, -48(%rbp)
	leaq	-64(%rbp), %rax
	movl	$4, %edx
	movq	%rax, %rsi
	movl	$main._omp_fn.0, %edi
	call	GOMP_parallel_start
	leaq	-64(%rbp), %rax
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
	addq	$248, %rsp
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
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$48, %rsp
	movq	%rdi, -72(%rbp)
	call	omp_get_thread_num
	movl	%eax, -40(%rbp)
	movl	$0, %eax
	call	pthread_self
	movslq	%eax, %rdx
	movl	-40(%rbp), %eax
	movl	%eax, %esi
	movl	$.LC2, %edi
	movl	$0, %eax
	call	printf
	leaq	-48(%rbp), %rdx
	leaq	-56(%rbp), %rax
	movq	%rdx, %r9
	movq	%rax, %r8
	movl	$2, %ecx
	movl	$1, %edx
	movl	$16, %esi
	movl	$0, %edi
	call	GOMP_loop_dynamic_start
	testb	%al, %al
	je	.L6
.L8:
	movq	-56(%rbp), %rax
	movl	%eax, -36(%rbp)
	movq	-48(%rbp), %rax
	movl	%eax, %ebx
.L7:
	movq	-72(%rbp), %rax
	movq	(%rax), %rax
	movl	-36(%rbp), %edx
	movslq	%edx, %rdx
	movl	(%rax,%rdx,4), %ecx
	movq	-72(%rbp), %rax
	movq	8(%rax), %rax
	movl	-36(%rbp), %edx
	movslq	%edx, %rdx
	movl	(%rax,%rdx,4), %eax
	imull	%eax, %ecx
	movq	-72(%rbp), %rax
	movq	16(%rax), %rax
	movl	-36(%rbp), %edx
	movslq	%edx, %rdx
	movl	%ecx, (%rax,%rdx,4)
	movq	-72(%rbp), %rax
	movq	16(%rax), %rax
	movl	-36(%rbp), %edx
	movslq	%edx, %rdx
	movl	(%rax,%rdx,4), %r12d
	movq	-72(%rbp), %rax
	movq	8(%rax), %rax
	movl	-36(%rbp), %edx
	movslq	%edx, %rdx
	movl	(%rax,%rdx,4), %r14d
	movq	-72(%rbp), %rax
	movq	(%rax), %rax
	movl	-36(%rbp), %edx
	movslq	%edx, %rdx
	movl	(%rax,%rdx,4), %r13d
	movl	$0, %eax
	call	pthread_self
	movslq	%eax, %rdx
	movl	-36(%rbp), %ecx
	movl	-40(%rbp), %eax
	movl	%r12d, (%rsp)
	movl	%r14d, %r9d
	movl	%r13d, %r8d
	movl	%eax, %esi
	movl	$.LC3, %edi
	movl	$0, %eax
	call	printf
	addl	$1, -36(%rbp)
	cmpl	%ebx, -36(%rbp)
	jl	.L7
	leaq	-48(%rbp), %rdx
	leaq	-56(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	GOMP_loop_dynamic_next
	testb	%al, %al
	jne	.L8
.L6:
	call	GOMP_loop_end
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
