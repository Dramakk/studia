	.file	"act3.c"
	.text
	.globl	mx
	.type	mx, @function
mx:
.LFB0:
	.cfi_startproc
	leaq	(%rdi,%rdi,2), %rdx
	leaq	0(,%rdx,4), %rax
	ret
	.cfi_endproc
.LFE0:
	.size	mx, .-mx
	.globl	addm
	.type	addm, @function
addm:
.LFB1:
	.cfi_startproc
	call	mx
	addq	$1, %rax
	ret
	.cfi_endproc
.LFE1:
	.size	addm, .-addm
	.ident	"GCC: (GNU) 8.2.1 20181127"
	.section	.note.GNU-stack,"",@progbits
