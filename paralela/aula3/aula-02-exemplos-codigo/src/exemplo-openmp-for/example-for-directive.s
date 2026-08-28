	.file	"example-for-directive.c"
	.text
	.section	.rodata
	.align 8
.LC0:
	.string	"Thread[%d][%lu]: Before parallel region.\n"
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
	subq	$8, %rsp
	call	pthread_self@PLT
	movq	%rax, %rbx
	call	omp_get_thread_num@PLT
	movl	%eax, %ecx
	leaq	.LC0(%rip), %rax
	movq	%rbx, %rdx
	movl	%ecx, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf@PLT
	leaq	main._omp_fn.0(%rip), %rax
	movl	$0, %ecx
	movl	$4, %edx
	movl	$0, %esi
	movq	%rax, %rdi
	call	GOMP_parallel@PLT
	call	pthread_self@PLT
	movq	%rax, %rbx
	call	omp_get_thread_num@PLT
	movl	%eax, %ecx
	leaq	.LC1(%rip), %rax
	movq	%rbx, %rdx
	movl	%ecx, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf@PLT
	movl	$0, %eax
	movq	-8(%rbp), %rbx
	leave
	ret
	.size	main, .-main
	.section	.rodata
	.align 8
.LC2:
	.string	"Thread[%d][%lu]: Working in %lu loop iteration.\n"
	.text
	.type	main._omp_fn.0, @function
main._omp_fn.0:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$40, %rsp
	movq	%rdi, -40(%rbp)
	call	omp_get_thread_num@PLT
	movl	%eax, -20(%rbp)
	call	omp_get_num_threads@PLT
	movl	%eax, %ebx
	call	omp_get_thread_num@PLT
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
	jl	.L4
.L7:
	imull	%ecx, %esi
	movl	%esi, %edx
	addl	%edx, %eax
	leal	(%rax,%rcx), %ebx
	cmpl	%ebx, %eax
	jge	.L8
	movl	%eax, -24(%rbp)
.L6:
	call	pthread_self@PLT
	movq	%rax, %rsi
	movl	-24(%rbp), %edx
	movl	-20(%rbp), %eax
	leaq	.LC2(%rip), %rdi
	movl	%edx, %ecx
	movq	%rsi, %rdx
	movl	%eax, %esi
	movl	$0, %eax
	call	printf@PLT
	addl	$1, -24(%rbp)
	cmpl	%ebx, -24(%rbp)
	jl	.L6
	jmp	.L8
.L4:
	movl	$0, %eax
	addl	$1, %ecx
	jmp	.L7
.L8:
	nop
	movq	-8(%rbp), %rbx
	leave
	ret
	.size	main._omp_fn.0, .-main._omp_fn.0
	.ident	"GCC: (GNU) 16.2.1 20260810"
	.section	.note.GNU-stack,"",@progbits
