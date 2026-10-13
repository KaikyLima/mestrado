	.file	"example-vectoraddsub-sections.c"
	.comm	h_a,40,32
	.comm	h_b,40,32
	.comm	h_c,40,32
	.comm	h_d,40,32
	.section	.rodata
	.align 8
.LC0:
	.string	"   Thread[%lu,%lu]: Initializing the arrays...\n"
	.text
	.globl	init_array
	.type	init_array, @function
init_array:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$8, %rsp
	movl	$0, %eax
	call	pthread_self
	movslq	%eax, %rbx
	movl	$0, %eax
	call	omp_get_thread_num
	movl	%eax, %edx
	movq	stdout(%rip), %rax
	movq	%rbx, %rcx
	movl	$.LC0, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf
	movl	$0, %edx
	movl	$0, %esi
	movl	$init_array._omp_fn.0, %edi
	call	GOMP_parallel_start
	movl	$0, %edi
	call	init_array._omp_fn.0
	call	GOMP_parallel_end
	addq	$8, %rsp
	popq	%rbx
	popq	%rbp
	ret
	.size	init_array, .-init_array
	.section	.rodata
	.align 8
.LC1:
	.string	"   Thread[%lu,%lu]: Printing the vector result...\n"
	.text
	.globl	print_array
	.type	print_array, @function
print_array:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$40, %rsp
	movq	%rdi, -40(%rbp)
	movl	$0, %eax
	call	pthread_self
	movslq	%eax, %rbx
	movl	$0, %eax
	call	omp_get_thread_num
	movl	%eax, %edx
	movq	stdout(%rip), %rax
	movq	%rbx, %rcx
	movl	$.LC1, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf
	movq	-40(%rbp), %rax
	movq	%rax, -32(%rbp)
	leaq	-32(%rbp), %rax
	movl	$0, %edx
	movq	%rax, %rsi
	movl	$print_array._omp_fn.1, %edi
	call	GOMP_parallel_start
	leaq	-32(%rbp), %rax
	movq	%rax, %rdi
	call	print_array._omp_fn.1
	call	GOMP_parallel_end
	movq	-32(%rbp), %rax
	movq	%rax, -40(%rbp)
	addq	$40, %rsp
	popq	%rbx
	popq	%rbp
	ret
	.size	print_array, .-print_array
	.section	.rodata
	.align 8
.LC3:
	.string	"   Thread[%lu,%lu]: Checking result...\n"
.LC5:
	.string	"Resultado Final: (%f, %f)\n"
	.text
	.globl	check_result
	.type	check_result, @function
check_result:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$24, %rsp
	movl	.LC2(%rip), %eax
	movl	%eax, -20(%rbp)
	movl	$0, %eax
	call	pthread_self
	movslq	%eax, %rbx
	movl	$0, %eax
	call	omp_get_thread_num
	movl	%eax, %edx
	movq	stdout(%rip), %rax
	movq	%rbx, %rcx
	movl	$.LC3, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf
	movl	-20(%rbp), %eax
	movl	%eax, -32(%rbp)
	leaq	-32(%rbp), %rax
	movl	$0, %edx
	movq	%rax, %rsi
	movl	$check_result._omp_fn.2, %edi
	call	GOMP_parallel_start
	leaq	-32(%rbp), %rax
	movq	%rax, %rdi
	call	check_result._omp_fn.2
	call	GOMP_parallel_end
	movl	-32(%rbp), %eax
	movl	%eax, -20(%rbp)
	movss	-20(%rbp), %xmm0
	movss	.LC4(%rip), %xmm1
	divss	%xmm1, %xmm0
	unpcklps	%xmm0, %xmm0
	cvtps2pd	%xmm0, %xmm1
	movss	-20(%rbp), %xmm0
	cvtps2pd	%xmm0, %xmm0
	movq	stdout(%rip), %rax
	movl	$.LC5, %esi
	movq	%rax, %rdi
	movl	$2, %eax
	call	fprintf
	addq	$24, %rsp
	popq	%rbx
	popq	%rbp
	ret
	.size	check_result, .-check_result
	.globl	addvector
	.type	addvector, @function
addvector:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$64, %rsp
	movq	%rdi, -40(%rbp)
	movq	%rsi, -48(%rbp)
	movq	%rdx, -56(%rbp)
	movl	$0, -4(%rbp)
	movq	-40(%rbp), %rax
	movq	%rax, -32(%rbp)
	movq	-48(%rbp), %rax
	movq	%rax, -24(%rbp)
	movq	-56(%rbp), %rax
	movq	%rax, -16(%rbp)
	leaq	-32(%rbp), %rax
	movl	$0, %edx
	movq	%rax, %rsi
	movl	$addvector._omp_fn.3, %edi
	call	GOMP_parallel_start
	leaq	-32(%rbp), %rax
	movq	%rax, %rdi
	call	addvector._omp_fn.3
	call	GOMP_parallel_end
	movq	-32(%rbp), %rax
	movq	%rax, -40(%rbp)
	movq	-24(%rbp), %rax
	movq	%rax, -48(%rbp)
	movq	-16(%rbp), %rax
	movq	%rax, -56(%rbp)
	leave
	ret
	.size	addvector, .-addvector
	.section	.rodata
	.align 8
.LC6:
	.string	"       Thread[%lu,%lu]: (subvector) Executing loop iteration %d.\n"
	.text
	.globl	subvector
	.type	subvector, @function
subvector:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$56, %rsp
	movq	%rdi, -40(%rbp)
	movq	%rsi, -48(%rbp)
	movq	%rdx, -56(%rbp)
	movl	$0, -20(%rbp)
	movl	$0, -20(%rbp)
	jmp	.L6
.L7:
	movl	$0, %eax
	call	pthread_self
	movslq	%eax, %rbx
	movl	$0, %eax
	call	omp_get_thread_num
	movl	%eax, %edx
	movq	stdout(%rip), %rax
	movl	-20(%rbp), %ecx
	movl	%ecx, %r8d
	movq	%rbx, %rcx
	movl	$.LC6, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf
	movl	-20(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rdx
	movq	-56(%rbp), %rax
	addq	%rdx, %rax
	movl	-20(%rbp), %edx
	movslq	%edx, %rdx
	leaq	0(,%rdx,4), %rcx
	movq	-40(%rbp), %rdx
	addq	%rcx, %rdx
	movss	(%rdx), %xmm0
	movl	-20(%rbp), %edx
	movslq	%edx, %rdx
	leaq	0(,%rdx,4), %rcx
	movq	-48(%rbp), %rdx
	addq	%rcx, %rdx
	movss	(%rdx), %xmm1
	subss	%xmm1, %xmm0
	movss	%xmm0, (%rax)
	addl	$1, -20(%rbp)
.L6:
	cmpl	$9, -20(%rbp)
	jle	.L7
	addq	$56, %rsp
	popq	%rbx
	popq	%rbp
	ret
	.size	subvector, .-subvector
	.section	.rodata
	.align 8
.LC7:
	.string	"Thread[%lu]: Before parallel region.\n"
	.align 8
.LC8:
	.string	"Thread[%lu]: After parallel region.\n"
	.text
	.globl	main
	.type	main, @function
main:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$32, %rsp
	movl	%edi, -20(%rbp)
	movq	%rsi, -32(%rbp)
	movl	$0, %eax
	call	init_array
	movl	$1, %edi
	movl	$0, %eax
	call	omp_set_nested
	movl	$0, %eax
	call	pthread_self
	movslq	%eax, %rdx
	movq	stdout(%rip), %rax
	movl	$.LC7, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf
	movl	-4(%rbp), %eax
	movl	%eax, -16(%rbp)
	leaq	-16(%rbp), %rax
	movl	$8, %edx
	movq	%rax, %rsi
	movl	$main._omp_fn.4, %edi
	call	GOMP_parallel_start
	leaq	-16(%rbp), %rax
	movq	%rax, %rdi
	call	main._omp_fn.4
	call	GOMP_parallel_end
	movl	-16(%rbp), %eax
	movl	%eax, -4(%rbp)
	movl	$0, %eax
	call	pthread_self
	movslq	%eax, %rdx
	movq	stdout(%rip), %rax
	movl	$.LC8, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf
	movl	$0, %eax
	call	check_result
	movl	$0, %eax
	leave
	ret
	.size	main, .-main
	.section	.rodata
	.align 8
.LC9:
	.string	"       Thread[%lu,%lu]: (init_array) Executing loop iteration %d.\n"
	.text
	.type	init_array._omp_fn.0, @function
init_array._omp_fn.0:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r12
	pushq	%rbx
	subq	$32, %rsp
	movq	%rdi, -40(%rbp)
	call	omp_get_num_threads
	movl	%eax, %ebx
	call	omp_get_thread_num
	movl	%eax, %esi
	movl	$10, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ecx
	movl	$10, %eax
	cltd
	idivl	%ebx
	movl	%edx, %eax
	cmpl	%eax, %esi
	jl	.L11
.L14:
	imull	%ecx, %esi
	movl	%esi, %edx
	addl	%edx, %eax
	leal	(%rax,%rcx), %ebx
	cmpl	%ebx, %eax
	jge	.L10
	movl	%eax, -20(%rbp)
.L13:
	movl	$0, %eax
	call	pthread_self
	movslq	%eax, %r12
	movl	$0, %eax
	call	omp_get_thread_num
	movl	%eax, %edx
	movq	stdout(%rip), %rax
	movl	-20(%rbp), %ecx
	movl	%ecx, %r8d
	movq	%r12, %rcx
	movl	$.LC9, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf
	movl	-20(%rbp), %eax
	movslq	%eax, %rdx
	movl	.LC10(%rip), %eax
	movl	%eax, h_a(,%rdx,4)
	movl	-20(%rbp), %eax
	movslq	%eax, %rdx
	movl	.LC10(%rip), %eax
	movl	%eax, h_b(,%rdx,4)
	addl	$1, -20(%rbp)
	cmpl	%ebx, -20(%rbp)
	jl	.L13
	jmp	.L10
.L11:
	movl	$0, %eax
	addl	$1, %ecx
	jmp	.L14
.L10:
	addq	$32, %rsp
	popq	%rbx
	popq	%r12
	popq	%rbp
	ret
	.size	init_array._omp_fn.0, .-init_array._omp_fn.0
	.section	.rodata
	.align 8
.LC11:
	.string	"       Thread[%lu,%lu]: (print_array) Executing loop iteration %d: v[%d]: %f.\n"
	.text
	.type	print_array._omp_fn.1, @function
print_array._omp_fn.1:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r12
	pushq	%rbx
	subq	$32, %rsp
	movq	%rdi, -40(%rbp)
	call	omp_get_num_threads
	movl	%eax, %ebx
	call	omp_get_thread_num
	movl	%eax, %esi
	movl	$10, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ecx
	movl	$10, %eax
	cltd
	idivl	%ebx
	movl	%edx, %eax
	cmpl	%eax, %esi
	jl	.L16
.L19:
	imull	%ecx, %esi
	movl	%esi, %edx
	addl	%edx, %eax
	leal	(%rax,%rcx), %ebx
	cmpl	%ebx, %eax
	jge	.L15
	movl	%eax, -20(%rbp)
.L18:
	movl	-20(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rdx
	movq	-40(%rbp), %rax
	movq	(%rax), %rax
	addq	%rdx, %rax
	movss	(%rax), %xmm0
	unpcklps	%xmm0, %xmm0
	cvtps2pd	%xmm0, %xmm1
	movsd	%xmm1, -48(%rbp)
	movl	$0, %eax
	call	pthread_self
	movslq	%eax, %r12
	movl	$0, %eax
	call	omp_get_thread_num
	movl	%eax, %edx
	movq	stdout(%rip), %rax
	movl	-20(%rbp), %esi
	movl	-20(%rbp), %ecx
	movsd	-48(%rbp), %xmm0
	movl	%esi, %r9d
	movl	%ecx, %r8d
	movq	%r12, %rcx
	movl	$.LC11, %esi
	movq	%rax, %rdi
	movl	$1, %eax
	call	fprintf
	addl	$1, -20(%rbp)
	cmpl	%ebx, -20(%rbp)
	jl	.L18
	jmp	.L15
.L16:
	movl	$0, %eax
	addl	$1, %ecx
	jmp	.L19
.L15:
	addq	$32, %rsp
	popq	%rbx
	popq	%r12
	popq	%rbp
	ret
	.size	print_array._omp_fn.1, .-print_array._omp_fn.1
	.section	.rodata
	.align 8
.LC12:
	.string	"       Thread[%lu,%lu]: (check_result) Executing loop iteration %d.\n"
	.text
	.type	check_result._omp_fn.2, @function
check_result._omp_fn.2:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r12
	pushq	%rbx
	subq	$32, %rsp
	movq	%rdi, -40(%rbp)
	call	omp_get_num_threads
	movl	%eax, %ebx
	call	omp_get_thread_num
	movl	%eax, %esi
	movl	$10, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ecx
	movl	$10, %eax
	cltd
	idivl	%ebx
	movl	%edx, %eax
	cmpl	%eax, %esi
	jl	.L21
.L24:
	imull	%ecx, %esi
	movl	%esi, %edx
	addl	%edx, %eax
	leal	(%rax,%rcx), %ebx
	cmpl	%ebx, %eax
	jge	.L20
	movl	%eax, -20(%rbp)
.L23:
	movl	$0, %eax
	call	pthread_self
	movslq	%eax, %r12
	movl	$0, %eax
	call	omp_get_thread_num
	movl	%eax, %edx
	movq	stdout(%rip), %rax
	movl	-20(%rbp), %ecx
	movl	%ecx, %r8d
	movq	%r12, %rcx
	movl	$.LC12, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf
	movl	-20(%rbp), %eax
	cltq
	movss	h_c(,%rax,4), %xmm1
	movq	-40(%rbp), %rax
	movss	(%rax), %xmm0
	addss	%xmm1, %xmm0
	movq	-40(%rbp), %rax
	movss	%xmm0, (%rax)
	addl	$1, -20(%rbp)
	cmpl	%ebx, -20(%rbp)
	jl	.L23
	jmp	.L20
.L21:
	movl	$0, %eax
	addl	$1, %ecx
	jmp	.L24
.L20:
	addq	$32, %rsp
	popq	%rbx
	popq	%r12
	popq	%rbp
	ret
	.size	check_result._omp_fn.2, .-check_result._omp_fn.2
	.section	.rodata
	.align 8
.LC13:
	.string	"       Thread[%lu,%lu]: (addvector) Executing loop iteration %d.\n"
	.text
	.type	addvector._omp_fn.3, @function
addvector._omp_fn.3:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r12
	pushq	%rbx
	subq	$32, %rsp
	movq	%rdi, -40(%rbp)
	call	omp_get_num_threads
	movl	%eax, %ebx
	call	omp_get_thread_num
	movl	%eax, %esi
	movl	$10, %eax
	cltd
	idivl	%ebx
	movl	%eax, %ecx
	movl	$10, %eax
	cltd
	idivl	%ebx
	movl	%edx, %eax
	cmpl	%eax, %esi
	jl	.L26
.L29:
	imull	%ecx, %esi
	movl	%esi, %edx
	addl	%edx, %eax
	leal	(%rax,%rcx), %ebx
	cmpl	%ebx, %eax
	jge	.L27
	movl	%eax, -20(%rbp)
.L28:
	movl	$0, %eax
	call	pthread_self
	movslq	%eax, %r12
	movl	$0, %eax
	call	omp_get_thread_num
	movl	%eax, %edx
	movq	stdout(%rip), %rax
	movl	-20(%rbp), %ecx
	movl	%ecx, %r8d
	movq	%r12, %rcx
	movl	$.LC13, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf
	movl	-20(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rdx
	movq	-40(%rbp), %rax
	movq	16(%rax), %rax
	addq	%rax, %rdx
	movl	-20(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rcx
	movq	-40(%rbp), %rax
	movq	(%rax), %rax
	addq	%rcx, %rax
	movss	(%rax), %xmm1
	movl	-20(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rcx
	movq	-40(%rbp), %rax
	movq	8(%rax), %rax
	addq	%rcx, %rax
	movss	(%rax), %xmm0
	addss	%xmm1, %xmm0
	movss	%xmm0, (%rdx)
	addl	$1, -20(%rbp)
	cmpl	%ebx, -20(%rbp)
	jl	.L28
.L27:
	call	GOMP_barrier
	jmp	.L30
.L26:
	movl	$0, %eax
	addl	$1, %ecx
	jmp	.L29
.L30:
	addq	$32, %rsp
	popq	%rbx
	popq	%r12
	popq	%rbp
	ret
	.size	addvector._omp_fn.3, .-addvector._omp_fn.3
	.section	.rodata
	.align 8
.LC14:
	.string	"   Thread[%lu,%lu]: Working on section 2.1.\n"
	.align 8
.LC15:
	.string	"   Thread[%lu,%lu]: Working on section 1.2.\n"
	.align 8
.LC16:
	.string	"   Thread[%lu,%lu]: Working on section 1.1.\n"
	.text
	.type	main._omp_fn.4, @function
main._omp_fn.4:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movl	$0, %eax
	call	omp_get_thread_num
	movq	-8(%rbp), %rdx
	movl	%eax, (%rdx)
	movl	$2, %edi
	call	GOMP_sections_start
.L42:
	cmpl	$1, %eax
	je	.L33
	cmpl	$1, %eax
	jb	.L34
	cmpl	$2, %eax
	je	.L35
	ud2
.L34:
	call	GOMP_sections_end
	call	GOMP_barrier
	movl	$2, %edi
	call	GOMP_sections_start
.L40:
	cmpl	$1, %eax
	je	.L37
	cmpl	$1, %eax
	jb	.L38
	cmpl	$2, %eax
	je	.L39
	ud2
.L38:
	call	GOMP_sections_end
	jmp	.L44
.L41:
	call	GOMP_sections_next
	jmp	.L40
.L39:
	movl	$0, %eax
	call	pthread_self
	movslq	%eax, %rcx
	movq	stdout(%rip), %rax
	movq	-8(%rbp), %rdx
	movl	(%rdx), %edx
	movl	$.LC14, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf
	movl	$h_d, %edi
	call	print_array
	jmp	.L41
.L37:
	movl	$0, %eax
	call	pthread_self
	movslq	%eax, %rcx
	movq	stdout(%rip), %rax
	movq	-8(%rbp), %rdx
	movl	(%rdx), %edx
	movl	$.LC14, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf
	movl	$h_c, %edi
	call	print_array
	jmp	.L41
.L43:
	call	GOMP_sections_next
	jmp	.L42
.L35:
	movl	$0, %eax
	call	pthread_self
	movslq	%eax, %rcx
	movq	stdout(%rip), %rax
	movq	-8(%rbp), %rdx
	movl	(%rdx), %edx
	movl	$.LC15, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf
	movl	$h_d, %edx
	movl	$h_b, %esi
	movl	$h_a, %edi
	call	subvector
	jmp	.L43
.L33:
	movl	$0, %eax
	call	pthread_self
	movslq	%eax, %rcx
	movq	stdout(%rip), %rax
	movq	-8(%rbp), %rdx
	movl	(%rdx), %edx
	movl	$.LC16, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf
	movl	$h_c, %edx
	movl	$h_b, %esi
	movl	$h_a, %edi
	call	addvector
	jmp	.L43
.L44:
	leave
	ret
	.size	main._omp_fn.4, .-main._omp_fn.4
	.section	.rodata
	.align 4
.LC2:
	.long	0
	.align 4
.LC4:
	.long	1092616192
	.align 4
.LC10:
	.long	1056964608
	.ident	"GCC: (Debian 4.8.4-1) 4.8.4"
	.section	.note.GNU-stack,"",@progbits
