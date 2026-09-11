	.file	"example-nested-parallel.c"
	.text
	.globl	main
	.type	main, @function
main:
	pushq	%rbp
	movq	%rsp, %rbp
	movl	$1, %edi
	call	omp_set_nested
	movl	$0, %edi
	call	omp_set_dynamic
	movl	$3, %edx
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
	.section	.rodata
.LC0:
	.string	"Outer: num_thds=%d\n"
	.text
	.type	main._omp_fn.0, @function
main._omp_fn.0:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movl	$3, %edx
	movl	$0, %esi
	movl	$main._omp_fn.1, %edi
	call	GOMP_parallel_start
	movl	$0, %edi
	call	main._omp_fn.1
	call	GOMP_parallel_end
	call	GOMP_barrier
	movl	$0, %edi
	call	omp_set_nested
	movl	$0, %edx
	movl	$0, %esi
	movl	$main._omp_fn.2, %edi
	call	GOMP_parallel_start
	movl	$0, %edi
	call	main._omp_fn.2
	call	GOMP_parallel_end
	call	GOMP_barrier
	call	GOMP_single_start
	cmpb	$1, %al
	jne	.L3
	call	omp_get_num_threads
	movl	%eax, %esi
	movl	$.LC0, %edi
	movl	$0, %eax
	call	printf
.L3:
	leave
	ret
	.size	main._omp_fn.0, .-main._omp_fn.0
	.section	.rodata
.LC1:
	.string	"Inner: num_thds=%d\n"
	.text
	.type	main._omp_fn.1, @function
main._omp_fn.1:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	call	GOMP_single_start
	cmpb	$1, %al
	jne	.L6
	call	omp_get_num_threads
	movl	%eax, %esi
	movl	$.LC1, %edi
	movl	$0, %eax
	call	printf
.L6:
	leave
	ret
	.size	main._omp_fn.1, .-main._omp_fn.1
	.type	main._omp_fn.2, @function
main._omp_fn.2:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	call	GOMP_single_start
	cmpb	$1, %al
	jne	.L9
	call	omp_get_num_threads
	movl	%eax, %esi
	movl	$.LC1, %edi
	movl	$0, %eax
	call	printf
.L9:
	leave
	ret
	.size	main._omp_fn.2, .-main._omp_fn.2
	.ident	"GCC: (Debian 4.8.4-1) 4.8.4"
	.section	.note.GNU-stack,"",@progbits
