	.file	"example-critical-directive.c"
	.text
	.section	.rodata
	.align 8
.LC0:
	.string	"Thread[%d][%lu]: Before parallel region...\n"
	.align 8
.LC1:
	.string	"Thread[%d][%lu]: After parallel region...\n"
	.align 8
.LC2:
	.string	"Thread[%d][%lu]: Final.... n: %d\n"
	.text
	.globl	main
	.type	main, @function
main:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$24, %rsp
	movq	%fs:40, %rax
	movq	%rax, -24(%rbp)
	xorl	%eax, %eax
	movl	$0, -28(%rbp)
	call	pthread_self@PLT
	movq	%rax, %rbx
	call	omp_get_thread_num@PLT
	movq	%rbx, %rdx
	movl	%eax, %esi
	leaq	.LC0(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
	movl	-28(%rbp), %eax
	movl	%eax, -32(%rbp)
	leaq	-32(%rbp), %rax
	movl	$0, %ecx
	movl	$4, %edx
	movq	%rax, %rsi
	leaq	main._omp_fn.0(%rip), %rdi
	call	GOMP_parallel@PLT
	movl	-32(%rbp), %eax
	movl	%eax, -28(%rbp)
	call	pthread_self@PLT
	movq	%rax, %rbx
	call	omp_get_thread_num@PLT
	movq	%rbx, %rdx
	movl	%eax, %esi
	leaq	.LC1(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
	call	pthread_self@PLT
	movq	%rax, %rbx
	call	omp_get_thread_num@PLT
	movl	%eax, %esi
	movl	-28(%rbp), %eax
	movl	%eax, %ecx
	movq	%rbx, %rdx
	leaq	.LC2(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
	movl	$0, %eax
	movq	-24(%rbp), %rcx
	subq	%fs:40, %rcx
	je	.L3
	call	__stack_chk_fail@PLT
.L3:
	movq	-8(%rbp), %rbx
	leave
	ret
	.size	main, .-main
	.section	.rodata
	.align 8
.LC3:
	.string	"Thread[%d][%lu]: Before... n: %d\n"
	.align 8
.LC4:
	.string	"Thread[%d][%lu]: After.... n: %d\n"
	.text
	.type	main._omp_fn.0, @function
main._omp_fn.0:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	call	omp_get_thread_num@PLT
	movl	%eax, -4(%rbp)
	call	GOMP_critical_start@PLT
	call	pthread_self@PLT
	movq	%rax, %rsi
	movq	-24(%rbp), %rax
	movl	(%rax), %edx
	movl	-4(%rbp), %eax
	movl	%edx, %ecx
	movq	%rsi, %rdx
	movl	%eax, %esi
	leaq	.LC3(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
	movq	-24(%rbp), %rax
	movl	(%rax), %edx
	movl	-4(%rbp), %eax
	addl	%eax, %edx
	movq	-24(%rbp), %rax
	movl	%edx, (%rax)
	call	pthread_self@PLT
	movq	%rax, %rsi
	movq	-24(%rbp), %rax
	movl	(%rax), %edx
	movl	-4(%rbp), %eax
	movl	%edx, %ecx
	movq	%rsi, %rdx
	movl	%eax, %esi
	leaq	.LC4(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
	call	GOMP_critical_end@PLT
	leave
	ret
	.size	main._omp_fn.0, .-main._omp_fn.0
	.ident	"GCC: (GNU) 10.2.0"
	.section	.note.GNU-stack,"",@progbits
