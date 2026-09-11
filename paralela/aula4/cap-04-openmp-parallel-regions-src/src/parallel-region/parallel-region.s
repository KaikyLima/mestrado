	.file	"parallel-region.c"
	.text
	.globl	main
	.type	main, @function
main:
	pushq	%rbp
	movq	%rsp, %rbp
	movl	$0, %edx
	movl	$0, %esi
	movl	$main._omp_fn.0, %edi
	call	GOMP_parallel_start
	movl	$0, %edi
	call	main._omp_fn.0
	call	GOMP_parallel_end
	movl	$0, %eax
	popq	%rbp
	ret
	.size	main, .-main
	.type	main._omp_fn.0, @function
main._omp_fn.0:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%rdi, -8(%rbp)
	popq	%rbp
	ret
	.size	main._omp_fn.0, .-main._omp_fn.0
	.ident	"GCC: (Debian 4.8.4-1) 4.8.4"
	.section	.note.GNU-stack,"",@progbits
