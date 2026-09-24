	.file	"vectoradd-omp-dynamic.c"
	.comm	h_a,8,8
	.comm	h_b,8,8
	.comm	h_c,8,8
	.globl	partition
	.bss
	.align 4
	.type	partition, @object
	.size	partition, 4
partition:
	.zero	4
	.globl	last_assigned
	.align 4
	.type	last_assigned, @object
	.size	last_assigned, 4
last_assigned:
	.zero	4
	.globl	total_of_iterations
	.align 4
	.type	total_of_iterations, @object
	.size	total_of_iterations, 4
total_of_iterations:
	.zero	4
	.globl	work_finished
	.type	work_finished, @object
	.size	work_finished, 1
work_finished:
	.zero	1
	.globl	n
	.align 4
	.type	n, @object
	.size	n, 4
n:
	.zero	4
	.comm	mutex,32,32
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
	movl	$0, %eax
	call	pthread_self
	movslq	%eax, %rdx
	movq	stdout(%rip), %rax
	movl	$.LC0, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf
	movl	$0, -4(%rbp)
	jmp	.L2
.L3:
	movq	h_a(%rip), %rax
	movl	-4(%rbp), %edx
	movslq	%edx, %rdx
	salq	$2, %rdx
	addq	%rax, %rdx
	movl	.LC1(%rip), %eax
	movl	%eax, (%rdx)
	movq	h_b(%rip), %rax
	movl	-4(%rbp), %edx
	movslq	%edx, %rdx
	salq	$2, %rdx
	addq	%rax, %rdx
	movl	.LC1(%rip), %eax
	movl	%eax, (%rdx)
	addl	$1, -4(%rbp)
.L2:
	movl	-4(%rbp), %eax
	cmpl	-20(%rbp), %eax
	jl	.L3
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
	subq	$32, %rsp
	movl	%edi, -20(%rbp)
	movl	$0, -4(%rbp)
	jmp	.L5
.L6:
	movq	h_c(%rip), %rax
	movl	-4(%rbp), %edx
	movslq	%edx, %rdx
	salq	$2, %rdx
	addq	%rdx, %rax
	movss	(%rax), %xmm0
	unpcklps	%xmm0, %xmm0
	cvtps2pd	%xmm0, %xmm1
	movsd	%xmm1, -32(%rbp)
	movl	$0, %eax
	call	pthread_self
	movslq	%eax, %rdx
	movq	stdout(%rip), %rax
	movl	-4(%rbp), %ecx
	movsd	-32(%rbp), %xmm0
	movl	$.LC2, %esi
	movq	%rax, %rdi
	movl	$1, %eax
	call	fprintf
	addl	$1, -4(%rbp)
.L5:
	movl	-4(%rbp), %eax
	cmpl	-20(%rbp), %eax
	jl	.L6
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
	subq	$48, %rsp
	movl	%edi, -20(%rbp)
	movl	.LC3(%rip), %eax
	movl	%eax, -8(%rbp)
	movl	$0, %eax
	call	pthread_self
	movslq	%eax, %rdx
	movq	stdout(%rip), %rax
	movl	$.LC4, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf
	movl	$0, -4(%rbp)
	jmp	.L8
.L9:
	movq	h_c(%rip), %rax
	movl	-4(%rbp), %edx
	movslq	%edx, %rdx
	salq	$2, %rdx
	addq	%rdx, %rax
	movss	(%rax), %xmm0
	movss	-8(%rbp), %xmm1
	addss	%xmm1, %xmm0
	movss	%xmm0, -8(%rbp)
	addl	$1, -4(%rbp)
.L8:
	movl	-4(%rbp), %eax
	cmpl	-20(%rbp), %eax
	jl	.L9
	cvtsi2ss	-20(%rbp), %xmm0
	movss	-8(%rbp), %xmm1
	divss	%xmm0, %xmm1
	movaps	%xmm1, %xmm0
	unpcklps	%xmm0, %xmm0
	cvtps2pd	%xmm0, %xmm2
	movsd	%xmm2, -32(%rbp)
	movss	-8(%rbp), %xmm3
	cvtps2pd	%xmm3, %xmm3
	movsd	%xmm3, -40(%rbp)
	movl	$0, %eax
	call	pthread_self
	movslq	%eax, %rdx
	movq	stdout(%rip), %rax
	movsd	-32(%rbp), %xmm1
	movsd	-40(%rbp), %xmm0
	movl	$.LC5, %esi
	movq	%rax, %rdi
	movl	$2, %eax
	call	fprintf
	leave
	ret
	.size	check_result, .-check_result
	.section	.rodata
	.align 8
.LC6:
	.string	"Thread[%lu]: Trying to get the next partition.\n"
	.align 8
.LC7:
	.string	"Thread[%lu]: Got the partition [%lu, %lu].\n"
	.text
	.globl	get_next_loop_partition
	.type	get_next_loop_partition, @function
get_next_loop_partition:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r12
	pushq	%rbx
	subq	$32, %rsp
	movq	%rdi, -40(%rbp)
	movq	%rsi, -48(%rbp)
	movb	$1, -17(%rbp)
	movq	-40(%rbp), %rax
	movq	$0, (%rax)
	movq	-48(%rbp), %rax
	movq	$0, (%rax)
	movl	$0, %eax
	call	pthread_self
	movslq	%eax, %rdx
	movq	stdout(%rip), %rax
	movl	$.LC6, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf
	movl	$mutex, %edi
	call	sem_wait
	movzbl	work_finished(%rip), %eax
	testb	%al, %al
	je	.L11
	movb	$0, -17(%rbp)
	jmp	.L12
.L11:
	movl	last_assigned(%rip), %eax
	movslq	%eax, %rdx
	movq	-40(%rbp), %rax
	movq	%rdx, (%rax)
	movl	last_assigned(%rip), %edx
	movl	partition(%rip), %eax
	addl	%edx, %eax
	movslq	%eax, %rdx
	movq	-48(%rbp), %rax
	movq	%rdx, (%rax)
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movl	total_of_iterations(%rip), %eax
	cltq
	cmpq	%rax, %rdx
	jle	.L13
	movl	total_of_iterations(%rip), %eax
	movslq	%eax, %rdx
	movq	-48(%rbp), %rax
	movq	%rdx, (%rax)
.L13:
	movq	-48(%rbp), %rax
	movq	(%rax), %rax
	movl	%eax, last_assigned(%rip)
	movb	$1, -17(%rbp)
	movl	last_assigned(%rip), %edx
	movl	total_of_iterations(%rip), %eax
	cmpl	%eax, %edx
	sete	%al
	movb	%al, work_finished(%rip)
.L12:
	movl	$mutex, %edi
	call	sem_post
	movq	-48(%rbp), %rax
	movq	(%rax), %r12
	movq	-40(%rbp), %rax
	movq	(%rax), %rbx
	movl	$0, %eax
	call	pthread_self
	movslq	%eax, %rdx
	movq	stdout(%rip), %rax
	movq	%r12, %r8
	movq	%rbx, %rcx
	movl	$.LC7, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf
	movzbl	-17(%rbp), %eax
	addq	$32, %rsp
	popq	%rbx
	popq	%r12
	popq	%rbp
	ret
	.size	get_next_loop_partition, .-get_next_loop_partition
	.section	.rodata
	.align 8
.LC8:
	.string	"Uso: %s <num_elements> <num_threads> <partition_size>\n"
	.align 8
.LC9:
	.string	"Thread[%lu]: num_elements: %d num_threads: %d.\n"
	.align 8
.LC10:
	.string	"Thread[%lu]: Allocating the arrays.\n"
	.align 8
.LC11:
	.string	"Thread[%lu]: Creating the Threads.\n"
	.align 8
.LC12:
	.string	"Thread[%lu]: All threads were finished.\n"
	.align 8
.LC13:
	.string	"Thread[%lu]: Printing the result.\n"
	.align 8
.LC14:
	.string	"Thread[%lu]: Checking the result.\n"
.LC15:
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
	movl	$0, -4(%rbp)
	cmpl	$3, -36(%rbp)
	jg	.L16
	movq	-48(%rbp), %rax
	movq	(%rax), %rdx
	movq	stderr(%rip), %rax
	movl	$.LC8, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf
	movl	$0, %edi
	call	exit
.L16:
	movq	-48(%rbp), %rax
	addq	$8, %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	atoi
	movl	%eax, -8(%rbp)
	movq	-48(%rbp), %rax
	addq	$16, %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	atoi
	movl	%eax, -4(%rbp)
	movq	-48(%rbp), %rax
	addq	$24, %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	atoi
	movl	%eax, partition(%rip)
	movl	-8(%rbp), %eax
	movl	%eax, total_of_iterations(%rip)
	movl	$0, %eax
	call	pthread_self
	movslq	%eax, %rdx
	movq	stdout(%rip), %rax
	movl	-4(%rbp), %esi
	movl	-8(%rbp), %ecx
	movl	%esi, %r8d
	movl	$.LC9, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf
	movl	$0, %eax
	call	pthread_self
	movslq	%eax, %rdx
	movq	stdout(%rip), %rax
	movl	$.LC10, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf
	movl	-8(%rbp), %eax
	cltq
	salq	$2, %rax
	movq	%rax, %rdi
	call	malloc
	movq	%rax, h_a(%rip)
	movl	-8(%rbp), %eax
	cltq
	salq	$2, %rax
	movq	%rax, %rdi
	call	malloc
	movq	%rax, h_b(%rip)
	movl	-8(%rbp), %eax
	cltq
	salq	$2, %rax
	movq	%rax, %rdi
	call	malloc
	movq	%rax, h_c(%rip)
	movl	-8(%rbp), %eax
	movl	%eax, %edi
	call	init_array
	movl	$1, %edx
	movl	$0, %esi
	movl	$mutex, %edi
	call	sem_init
	movb	$0, work_finished(%rip)
	movl	$0, %eax
	call	pthread_self
	movslq	%eax, %rdx
	movq	stdout(%rip), %rax
	movl	$.LC11, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf
	movl	-4(%rbp), %eax
	movl	%eax, %edx
	movl	$0, %esi
	movl	$main._omp_fn.0, %edi
	call	GOMP_parallel_start
	movl	$0, %edi
	call	main._omp_fn.0
	call	GOMP_parallel_end
	movl	$0, %eax
	call	pthread_self
	movslq	%eax, %rdx
	movq	stdout(%rip), %rax
	movl	$.LC12, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf
	movl	$0, %eax
	call	pthread_self
	movslq	%eax, %rdx
	movq	stdout(%rip), %rax
	movl	$.LC13, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf
	movl	$0, %eax
	call	pthread_self
	movslq	%eax, %rdx
	movq	stdout(%rip), %rax
	movl	$.LC14, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf
	movl	-8(%rbp), %eax
	movl	%eax, %edi
	call	check_result
	movl	$0, %eax
	call	pthread_self
	movslq	%eax, %rdx
	movq	stdout(%rip), %rax
	movl	$.LC15, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf
	movl	$0, %eax
	leave
	ret
	.size	main, .-main
	.section	.rodata
.LC16:
	.string	"  Thread[%lu]: Exiting.\n"
	.align 8
.LC17:
	.string	"  Thread[%lu]: No work to do.\n"
	.align 8
.LC18:
	.string	"   Thread[%lu,%lu]: Working on partition: [%d..%d]: %d.\n"
	.text
	.type	main._omp_fn.0, @function
main._omp_fn.0:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$72, %rsp
	movq	%rdi, -88(%rbp)
	call	omp_get_thread_num
	cltq
	movq	%rax, -48(%rbp)
	movb	$0, -49(%rbp)
.L22:
	leaq	-72(%rbp), %rdx
	leaq	-64(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	get_next_loop_partition
	movb	%al, -49(%rbp)
	cmpb	$0, -49(%rbp)
	jne	.L19
	movzbl	-49(%rbp), %eax
	xorl	$1, %eax
	testb	%al, %al
	jne	.L20
.L21:
	movl	$0, %eax
	call	pthread_self
	movslq	%eax, %rdx
	movq	stdout(%rip), %rax
	movl	$.LC16, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf
	jmp	.L24
.L20:
	movl	$0, %eax
	call	pthread_self
	movslq	%eax, %rdx
	movq	stdout(%rip), %rax
	movl	$.LC17, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf
	jmp	.L21
.L19:
	movq	-72(%rbp), %rdx
	movq	-64(%rbp), %rax
	subq	%rax, %rdx
	movq	%rdx, %r13
	movq	-72(%rbp), %r12
	movq	-64(%rbp), %rbx
	movl	$0, %eax
	call	pthread_self
	movslq	%eax, %rcx
	movq	stdout(%rip), %rax
	movq	-48(%rbp), %rdx
	movq	%r13, (%rsp)
	movq	%r12, %r9
	movq	%rbx, %r8
	movl	$.LC18, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf
	movq	-64(%rbp), %rax
	movl	%eax, -36(%rbp)
	nop
.L23:
	movl	-36(%rbp), %eax
	movslq	%eax, %rdx
	movq	-72(%rbp), %rax
	cmpq	%rax, %rdx
	jge	.L22
	movq	h_c(%rip), %rax
	movl	-36(%rbp), %edx
	movslq	%edx, %rdx
	salq	$2, %rdx
	addq	%rdx, %rax
	movq	h_a(%rip), %rdx
	movl	-36(%rbp), %ecx
	movslq	%ecx, %rcx
	salq	$2, %rcx
	addq	%rcx, %rdx
	movss	(%rdx), %xmm1
	movq	h_b(%rip), %rdx
	movl	-36(%rbp), %ecx
	movslq	%ecx, %rcx
	salq	$2, %rcx
	addq	%rcx, %rdx
	movss	(%rdx), %xmm0
	addss	%xmm1, %xmm0
	movss	%xmm0, (%rax)
	addl	$1, -36(%rbp)
	jmp	.L23
.L24:
	addq	$72, %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%rbp
	ret
	.size	main._omp_fn.0, .-main._omp_fn.0
	.section	.rodata
	.align 4
.LC1:
	.long	1056964608
	.align 4
.LC3:
	.long	0
	.ident	"GCC: (Debian 4.8.4-1) 4.8.4"
	.section	.note.GNU-stack,"",@progbits
