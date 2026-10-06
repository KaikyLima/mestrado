	.file	"vectoradd-omp-for.c"
	.text
	.globl	h_a
	.bss
	.align 8
	.type	h_a, @object
	.size	h_a, 8
h_a:
	.zero	8
	.globl	h_b
	.align 8
	.type	h_b, @object
	.size	h_b, 8
h_b:
	.zero	8
	.globl	h_c
	.align 8
	.type	h_c, @object
	.size	h_c, 8
h_c:
	.zero	8
	.globl	partition
	.align 4
	.type	partition, @object
	.size	partition, 4
partition:
	.zero	4
	.section	.rodata
	.align 8
.LC0:
	.string	"Thread[%lu]: Initializing the arrays.\n"
	.text
	.globl	init_array
	.type	init_array, @function
init_array:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$32, %rsp
	movl	%edi, -20(%rbp)
	call	pthread_self@PLT
	movq	%rax, %rdx
	movq	stdout(%rip), %rax
	leaq	.LC0(%rip), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf@PLT
	movl	$0, -4(%rbp)
	jmp	.L2
.L3:
	movq	h_a(%rip), %rax
	movl	-4(%rbp), %edx
	movslq	%edx, %rdx
	salq	$2, %rdx
	addq	%rdx, %rax
	movss	.LC1(%rip), %xmm0
	movss	%xmm0, (%rax)
	movq	h_b(%rip), %rax
	movl	-4(%rbp), %edx
	movslq	%edx, %rdx
	salq	$2, %rdx
	addq	%rdx, %rax
	movss	.LC1(%rip), %xmm0
	movss	%xmm0, (%rax)
	addl	$1, -4(%rbp)
.L2:
	movl	-4(%rbp), %eax
	cmpl	-20(%rbp), %eax
	jl	.L3
	nop
	nop
	leave
	ret
	.size	init_array, .-init_array
	.section	.rodata
.LC2:
	.string	"Thread[%lu]: h_c[%07d]: %f.\n"
	.text
	.globl	print_array
	.type	print_array, @function
print_array:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$40, %rsp
	movl	%edi, -36(%rbp)
	movl	$0, -20(%rbp)
	jmp	.L5
.L6:
	movq	h_c(%rip), %rax
	movl	-20(%rbp), %edx
	movslq	%edx, %rdx
	salq	$2, %rdx
	addq	%rdx, %rax
	movss	(%rax), %xmm0
	pxor	%xmm1, %xmm1
	cvtss2sd	%xmm0, %xmm1
	movq	%xmm1, %rbx
	call	pthread_self@PLT
	movq	%rax, %rdi
	movq	stdout(%rip), %rax
	movl	-20(%rbp), %edx
	leaq	.LC2(%rip), %rsi
	movq	%rbx, %xmm0
	movl	%edx, %ecx
	movq	%rdi, %rdx
	movq	%rax, %rdi
	movl	$1, %eax
	call	fprintf@PLT
	addl	$1, -20(%rbp)
.L5:
	movl	-20(%rbp), %eax
	cmpl	-36(%rbp), %eax
	jl	.L6
	nop
	nop
	movq	-8(%rbp), %rbx
	leave
	ret
	.size	print_array, .-print_array
	.section	.rodata
.LC4:
	.string	"Thread[%lu]: Checking.\n"
	.align 8
.LC5:
	.string	"Thread[%lu]: Final Result: (%f, %f).\n"
	.text
	.globl	check_result
	.type	check_result, @function
check_result:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$40, %rsp
	movl	%edi, -36(%rbp)
	pxor	%xmm0, %xmm0
	movss	%xmm0, -20(%rbp)
	call	pthread_self@PLT
	movq	%rax, %rdx
	movq	stdout(%rip), %rax
	leaq	.LC4(%rip), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf@PLT
	movl	$0, -24(%rbp)
	jmp	.L8
.L9:
	movq	h_c(%rip), %rax
	movl	-24(%rbp), %edx
	movslq	%edx, %rdx
	salq	$2, %rdx
	addq	%rdx, %rax
	movss	(%rax), %xmm0
	movss	-20(%rbp), %xmm1
	addss	%xmm1, %xmm0
	movss	%xmm0, -20(%rbp)
	addl	$1, -24(%rbp)
.L8:
	movl	-24(%rbp), %eax
	cmpl	-36(%rbp), %eax
	jl	.L9
	pxor	%xmm1, %xmm1
	cvtsi2ssl	-36(%rbp), %xmm1
	movss	-20(%rbp), %xmm0
	divss	%xmm1, %xmm0
	pxor	%xmm2, %xmm2
	cvtss2sd	%xmm0, %xmm2
	movsd	%xmm2, -48(%rbp)
	pxor	%xmm3, %xmm3
	cvtss2sd	-20(%rbp), %xmm3
	movq	%xmm3, %rbx
	call	pthread_self@PLT
	movq	%rax, %rdx
	movq	stdout(%rip), %rax
	leaq	.LC5(%rip), %rcx
	movsd	-48(%rbp), %xmm1
	movq	%rbx, %xmm0
	movq	%rcx, %rsi
	movq	%rax, %rdi
	movl	$2, %eax
	call	fprintf@PLT
	nop
	movq	-8(%rbp), %rbx
	leave
	ret
	.size	check_result, .-check_result
	.section	.rodata
	.align 8
.LC6:
	.string	"Uso: %s <num_elements> <num_threads> <partition_size>\n"
	.align 8
.LC7:
	.string	"Thread[%lu]: num_elements: %d num_threads: %d.\n"
	.align 8
.LC8:
	.string	"Thread[%lu]: Allocating the arrays.\n"
	.align 8
.LC9:
	.string	"Thread[%lu]: Before parallel region.\n"
	.align 8
.LC10:
	.string	"Thread[%lu]: All threads were finished.\n"
	.align 8
.LC11:
	.string	"Thread[%lu]: Printing the result.\n"
	.align 8
.LC12:
	.string	"Thread[%lu]: Checking the result.\n"
.LC13:
	.string	"Thread[%lu]: Fui, Tchau!\n"
	.text
	.globl	main
	.type	main, @function
main:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$48, %rsp
	movl	%edi, -36(%rbp)
	movq	%rsi, -48(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movl	$0, -24(%rbp)
	cmpl	$3, -36(%rbp)
	jg	.L11
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	stderr(%rip), %rax
	leaq	.LC6(%rip), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf@PLT
	movl	$0, %edi
	call	exit@PLT
.L11:
	movq	-48(%rbp), %rax
	addq	$8, %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -20(%rbp)
	movq	-48(%rbp), %rax
	addq	$16, %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, -24(%rbp)
	movq	-48(%rbp), %rax
	addq	$24, %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movl	%eax, partition(%rip)
	call	pthread_self@PLT
	movq	%rax, %rdi
	movq	stdout(%rip), %rax
	movl	-24(%rbp), %ecx
	movl	-20(%rbp), %edx
	leaq	.LC7(%rip), %rsi
	movl	%ecx, %r8d
	movl	%edx, %ecx
	movq	%rdi, %rdx
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf@PLT
	call	pthread_self@PLT
	movq	%rax, %rdx
	movq	stdout(%rip), %rax
	leaq	.LC8(%rip), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf@PLT
	movl	-20(%rbp), %eax
	cltq
	salq	$2, %rax
	movq	%rax, %rdi
	call	malloc@PLT
	movq	%rax, h_a(%rip)
	movl	-20(%rbp), %eax
	cltq
	salq	$2, %rax
	movq	%rax, %rdi
	call	malloc@PLT
	movq	%rax, h_b(%rip)
	movl	-20(%rbp), %eax
	cltq
	salq	$2, %rax
	movq	%rax, %rdi
	call	malloc@PLT
	movq	%rax, h_c(%rip)
	movl	-20(%rbp), %eax
	movl	%eax, %edi
	call	init_array
	call	pthread_self@PLT
	movq	%rax, %rdx
	movq	stdout(%rip), %rax
	leaq	.LC9(%rip), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf@PLT
	movl	-24(%rbp), %edx
	movl	-20(%rbp), %eax
	movl	%eax, -16(%rbp)
	leaq	-16(%rbp), %rax
	leaq	main._omp_fn.0(%rip), %rdi
	movl	$0, %ecx
	movq	%rax, %rsi
	call	GOMP_parallel@PLT
	call	pthread_self@PLT
	movq	%rax, %rdx
	movq	stdout(%rip), %rax
	leaq	.LC10(%rip), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf@PLT
	call	pthread_self@PLT
	movq	%rax, %rdx
	movq	stdout(%rip), %rax
	leaq	.LC11(%rip), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf@PLT
	call	pthread_self@PLT
	movq	%rax, %rdx
	movq	stdout(%rip), %rax
	leaq	.LC12(%rip), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf@PLT
	movl	-20(%rbp), %eax
	movl	%eax, %edi
	call	check_result
	call	pthread_self@PLT
	movq	%rax, %rdx
	movq	stdout(%rip), %rax
	leaq	.LC13(%rip), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf@PLT
	movl	$0, %eax
	movq	-8(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L13
	call	__stack_chk_fail@PLT
.L13:
	leave
	ret
	.size	main, .-main
	.section	.rodata
	.align 8
.LC14:
	.string	"   Thread[%lu,%lu]: Working on partition.\n"
.LC15:
	.string	"  Thread[%lu]: Exiting.\n"
	.text
	.type	main._omp_fn.0, @function
main._omp_fn.0:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$72, %rsp
	movq	%rdi, -72(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -24(%rbp)
	xorl	%eax, %eax
	movq	-72(%rbp), %rax
	movl	(%rax), %eax
	movl	%eax, -52(%rbp)
	call	omp_get_thread_num@PLT
	cltq
	movq	%rax, -32(%rbp)
	movl	partition(%rip), %edx
	movl	-52(%rbp), %eax
	movslq	%edx, %rdx
	cltq
	leaq	-40(%rbp), %rsi
	leaq	-48(%rbp), %rcx
	movq	%rsi, %r9
	movq	%rcx, %r8
	movq	%rdx, %rcx
	movl	$1, %edx
	movq	%rax, %rsi
	movl	$0, %edi
	call	GOMP_loop_nonmonotonic_dynamic_start@PLT
	testb	%al, %al
	je	.L15
.L17:
	movq	-48(%rbp), %rax
	movl	%eax, -56(%rbp)
	movq	-40(%rbp), %rax
	movl	%eax, %ebx
.L16:
	call	pthread_self@PLT
	movq	%rax, %rcx
	movq	stdout(%rip), %rax
	movq	-32(%rbp), %rdx
	leaq	.LC14(%rip), %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf@PLT
	movq	h_a(%rip), %rax
	movl	-56(%rbp), %edx
	movslq	%edx, %rdx
	salq	$2, %rdx
	addq	%rdx, %rax
	movss	(%rax), %xmm1
	movq	h_b(%rip), %rax
	movl	-56(%rbp), %edx
	movslq	%edx, %rdx
	salq	$2, %rdx
	addq	%rdx, %rax
	movss	(%rax), %xmm0
	movq	h_c(%rip), %rax
	movl	-56(%rbp), %edx
	movslq	%edx, %rdx
	salq	$2, %rdx
	addq	%rdx, %rax
	addss	%xmm1, %xmm0
	movss	%xmm0, (%rax)
	addl	$1, -56(%rbp)
	cmpl	%ebx, -56(%rbp)
	jl	.L16
	leaq	-40(%rbp), %rdx
	leaq	-48(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	GOMP_loop_nonmonotonic_dynamic_next@PLT
	testb	%al, %al
	jne	.L17
.L15:
	call	GOMP_loop_end@PLT
	call	pthread_self@PLT
	movq	%rax, %rdx
	movq	stdout(%rip), %rax
	leaq	.LC15(%rip), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf@PLT
	movq	-24(%rbp), %rax
	subq	%fs:40, %rax
	je	.L18
	call	__stack_chk_fail@PLT
.L18:
	movq	-8(%rbp), %rbx
	leave
	ret
	.size	main._omp_fn.0, .-main._omp_fn.0
	.section	.rodata
	.align 4
.LC1:
	.long	1056964608
	.ident	"GCC: (GNU) 16.2.1 20260810"
	.section	.note.GNU-stack,"",@progbits
