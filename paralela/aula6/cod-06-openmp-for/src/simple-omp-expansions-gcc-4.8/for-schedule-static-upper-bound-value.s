	.file	"for-schedule-static-upper-bound-value.c"
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
	popq	%rbp
	ret
	.size	main, .-main
	.type	main._omp_fn.0, @function
main._omp_fn.0:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$40, %rsp
	movq	%rdi, -40(%rbp)
	call	omp_get_num_threads
	movl	%eax, %ebx
	call	omp_get_thread_num
	movl	%eax, %esi
	movl	$1024, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ecx
	movl	$1024, %eax
	cltd
	idivl	%ebx
	movl	%edx, %eax
	cmpl	%eax, %esi
	jl	.L3
.L6:
	imull	%ecx, %esi
	movl	%esi, %edx
	addl	%edx, %eax
	leal	(%rax,%rcx), %edx
	cmpl	%edx, %eax
	jge	.L2
	movl	%eax, -20(%rbp)
.L5:
	addl	$1, -20(%rbp)
	cmpl	%edx, -20(%rbp)
	jl	.L5
	jmp	.L2
.L3:
	movl	$0, %eax
	addl	$1, %ecx
	jmp	.L6
.L2:
	addq	$40, %rsp
	popq	%rbx
	popq	%rbp
	ret
	.size	main._omp_fn.0, .-main._omp_fn.0
	.ident	"GCC: (Debian 4.8.4-1) 4.8.4"
	.section	.note.GNU-stack,"",@progbits
