	.file	"for-schedule-dynamic-upper-bound-value.c"
	.text
	.globl	main
	.type	main, @function
main:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$32, %rsp
	movq	$1, (%rsp)
	movl	$1, %r9d
	movl	$1024, %r8d
	movl	$0, %ecx
	movl	$0, %edx
	movl	$0, %esi
	movl	$main._omp_fn.0, %edi
	call	GOMP_parallel_loop_dynamic_start
	movl	$0, %edi
	call	main._omp_fn.0
	call	GOMP_parallel_end
	leave
	ret
	.size	main, .-main
	.type	main._omp_fn.0, @function
main._omp_fn.0:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$48, %rsp
	movq	%rdi, -40(%rbp)
	leaq	-16(%rbp), %rdx
	leaq	-24(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	GOMP_loop_dynamic_next
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
