	.file	"zad6.c"
	.text
	.globl	relo3
	.type	relo3, @function
relo3:
.LFB0:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%edi, -4(%rbp)
	movl	-4(%rbp), %eax
	subl	$100, %eax
	cmpl	$5, %eax
	ja	.L2
	movl	%eax, %eax
	leaq	0(,%rax,4), %rdx
	leaq	.L4(%rip), %rax
	movl	(%rdx,%rax), %eax
	cltq
	leaq	.L4(%rip), %rdx
	addq	%rdx, %rax
	jmp	*%rax
	.section	.rodata
	.align 4
	.align 4
.L4:
	.long	.L7-.L4
	.long	.L6-.L4
	.long	.L2-.L4
	.long	.L5-.L4
	.long	.L5-.L4
	.long	.L3-.L4
	.text
.L7:
	movl	-4(%rbp), %eax
	jmp	.L8
.L6:
	movl	-4(%rbp), %eax
	addl	$1, %eax
	jmp	.L8
.L5:
	movl	-4(%rbp), %eax
	addl	$3, %eax
	jmp	.L8
.L3:
	movl	-4(%rbp), %eax
	addl	$5, %eax
	jmp	.L8
.L2:
	movl	-4(%rbp), %eax
	addl	$6, %eax
.L8:
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	relo3, .-relo3
	.ident	"GCC: (GNU) 8.2.1 20181127"
	.section	.note.GNU-stack,"",@progbits
