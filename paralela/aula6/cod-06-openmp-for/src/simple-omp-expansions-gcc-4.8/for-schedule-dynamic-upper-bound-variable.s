	.file	"for-schedule-dynamic-upper-bound-variable.c"
	.text
	.globl	main
	.type	main, @function
main:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$32, %rsp
	movl	$1024, -4(%rbp)
	movl	-4(%rbp), %eax
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
	movl	%eax, -4(%rbp)
	leave
	ret
	.size	main, .-main
	.type	main._omp_fn.0, @function
main._omp_fn.0:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$48, %rsp
	movq	%rdi, -40(%rbp)
	movq	-40(%rbp), %rax
	movl	(%rax), %eax
	cltq
	leaq	-16(%rbp), %rcx
	leaq	-24(%rbp), %rdx
	movq	%rcx, %r9
	movq	%rdx, %r8
	movl	$1, %ecx
	movl	$1, %edx
	movq	%rax, %rsi
	movl	$0, %edi
	call	GOMP_loop_dynamic_start
	testb	%al, %al
	je	.L3
.L5:
	movq	-24(%rbp), %rax
	movl	%eax, -4(%rbp)
	movq	-16(%rbp), %rax
.L4:
	addl	$1, -4(%rbp)
	cmpl	%eax, -4(%rbp)
	jl	.L4
	leaq	-16(%rbp), %rdx
	leaq	-24(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	GOMP_loop_dynamic_next
	testb	%al, %al
	jne	.L5
.L3:
	call	GOMP_loop_end_nowait
	leave
	ret
	.size	main._omp_fn.0, .-main._omp_fn.0
	.ident	"GCC: (Debian 4.8.4-1) 4.8.4"
	.section	.note.GNU-stack,"",@progbits
