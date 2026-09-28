	.file	"example-atomic-directive.c"
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
	pushq	%r12
	pushq	%rbx
	subq	$32, %rsp
	movq	%fs:40, %rax
	movq	%rax, -24(%rbp)
	xorl	%eax, %eax
	movl	$0, -36(%rbp)
	call	pthread_self@PLT
	movq	%rax, %rbx
	call	omp_get_thread_num@PLT
	movq	%rbx, %rdx
	movl	%eax, %esi
	leaq	.LC0(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
	leaq	-36(%rbp), %rax
	movq	%rax, -32(%rbp)
	leaq	-32(%rbp), %rax
	movl	$0, %ecx
	movl	$4, %edx
	movq	%rax, %rsi
	leaq	main._omp_fn.0(%rip), %rdi
	call	GOMP_parallel@PLT
	call	pthread_self@PLT
	movq	%rax, %rbx
	call	omp_get_thread_num@PLT
	movq	%rbx, %rdx
	movl	%eax, %esi
	leaq	.LC1(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
	movl	-36(%rbp), %ebx
	call	pthread_self@PLT
	movq	%rax, %r12
	call	omp_get_thread_num@PLT
	movl	%ebx, %ecx
	movq	%r12, %rdx
	movl	%eax, %esi
	leaq	.LC2(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
	movl	$0, %eax
	movq	-24(%rbp), %rcx
	subq	%fs:40, %rcx
	je	.L3
	call	__stack_chk_fail@PLT
.L3:
	addq	$32, %rsp
	popq	%rbx
	popq	%r12
	popq	%rbp
	ret
	.size	main, .-main
	.section	.rodata
	.align 8
.LC3:
	.string	"Thread[%d][%lu]: Before... n: %d\n"
	.align 8
.LC5:
	.string	"Thread[%d][%lu]: After.... n: %d\n"
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
	movq	-40(%rbp), %rax
	movq	(%rax), %rax
	movl	(%rax), %ebx
	call	pthread_self@PLT
	movq	%rax, %rdx
	movl	-20(%rbp), %eax
	movl	%ebx, %ecx
	movl	%eax, %esi
	leaq	.LC3(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
	pxor	%xmm2, %xmm2
	cvtsi2sdl	-20(%rbp), %xmm2
	movq	%xmm2, %rax
	movsd	.LC4(%rip), %xmm0
	movapd	%xmm0, %xmm1
	movq	%rax, %xmm0
	call	pow@PLT
	movq	-40(%rbp), %rax
	movq	(%rax), %rdx
	movl	(%rdx), %eax
	movl	%eax, %ecx
.L5:
	pxor	%xmm1, %xmm1
	cvtsi2sdl	%ecx, %xmm1
	addsd	%xmm0, %xmm1
	cvttsd2sil	%xmm1, %esi
	movl	%ecx, %eax
	lock cmpxchgl	%esi, (%rdx)
	movl	%ecx, %esi
	movl	%eax, %ecx
	cmpl	%esi, %eax
	jne	.L5
	movq	-40(%rbp), %rax
	movq	(%rax), %rax
	movl	(%rax), %ebx
	call	pthread_self@PLT
	movq	%rax, %rdx
	movl	-20(%rbp), %eax
	movl	%ebx, %ecx
	movl	%eax, %esi
	leaq	.LC5(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
	movq	-8(%rbp), %rbx
	leave
	ret
	.size	main._omp_fn.0, .-main._omp_fn.0
	.section	.rodata
	.align 8
.LC4:
	.long	0
	.long	1074266112
	.ident	"GCC: (GNU) 10.2.0"
	.section	.note.GNU-stack,"",@progbits
