/*********************************************************************/
/* Copyright 2009, 2010 The University of Texas at Austin.           */
/* All rights reserved.                                              */
/*                                                                   */
/* Redistribution and use in source and binary forms, with or        */
/* without modification, are permitted provided that the following   */
/* conditions are met:                                               */
/*                                                                   */
/*   1. Redistributions of source code must retain the above         */
/*      copyright notice, this list of conditions and the following  */
/*      disclaimer.                                                  */
/*                                                                   */
/*   2. Redistributions in binary form must reproduce the above      */
/*      copyright notice, this list of conditions and the following  */
/*      disclaimer in the documentation and/or other materials       */
/*      provided with the distribution.                              */
/*                                                                   */
/*    THIS  SOFTWARE IS PROVIDED  BY THE  UNIVERSITY OF  TEXAS AT    */
/*    AUSTIN  ``AS IS''  AND ANY  EXPRESS OR  IMPLIED WARRANTIES,    */
/*    INCLUDING, BUT  NOT LIMITED  TO, THE IMPLIED  WARRANTIES OF    */
/*    MERCHANTABILITY  AND FITNESS FOR  A PARTICULAR  PURPOSE ARE    */
/*    DISCLAIMED.  IN  NO EVENT SHALL THE UNIVERSITY  OF TEXAS AT    */
/*    AUSTIN OR CONTRIBUTORS BE  LIABLE FOR ANY DIRECT, INDIRECT,    */
/*    INCIDENTAL,  SPECIAL, EXEMPLARY,  OR  CONSEQUENTIAL DAMAGES    */
/*    (INCLUDING, BUT  NOT LIMITED TO,  PROCUREMENT OF SUBSTITUTE    */
/*    GOODS  OR  SERVICES; LOSS  OF  USE,  DATA,  OR PROFITS;  OR    */
/*    BUSINESS INTERRUPTION) HOWEVER CAUSED  AND ON ANY THEORY OF    */
/*    LIABILITY, WHETHER  IN CONTRACT, STRICT  LIABILITY, OR TORT    */
/*    (INCLUDING NEGLIGENCE OR OTHERWISE)  ARISING IN ANY WAY OUT    */
/*    OF  THE  USE OF  THIS  SOFTWARE,  EVEN  IF ADVISED  OF  THE    */
/*    POSSIBILITY OF SUCH DAMAGE.                                    */
/*                                                                   */
/* The views and conclusions contained in the software and           */
/* documentation are those of the authors and should not be          */
/* interpreted as representing official policies, either expressed   */
/* or implied, of The University of Texas at Austin.                 */
/*********************************************************************/

#define ASSEMBLER
#include "common.h"

#ifndef WINDOWS_ABI
#define M	ARG1	/* rdi */
#define X	ARG4
#define INCX	ARG5
#define Y	ARG6
#define INCY	ARG2
#else
#define M	ARG1
#define X	ARG2
#define INCX	ARG3
#define Y	ARG4
#define INCY	%rbx
#endif

#include "l1param.h"

	PROLOGUE
	PROFCODE

#ifndef WINDOWS_ABI
	movq	 8(%rsp), INCY
#else
	pushq	%rbx

	movq	56(%rsp), X
	movq	64(%rsp), INCX
	movq	72(%rsp), Y
	movq	80(%rsp), INCY
#endif

	SAVEREGISTERS

	salq	$ZBASE_SHIFT, INCX
	salq	$ZBASE_SHIFT, INCY

	testq	M, M
	jle	.L19

	cmpq	$2 * SIZE, INCX
	jne	.L50
	cmpq	$2 * SIZE, INCY
	jne	.L50

	addq	M, M

	subq	$-32 * SIZE, X
	subq	$-32 * SIZE, Y

	cmpq	$3, M
	jle	.L16

	testq	$SIZE, Y
	je	.L05

	movss	-32 * SIZE(X), %xmm0
	movss	-32 * SIZE(Y), %xmm1

	movss	%xmm1, -32 * SIZE(X)
	movss	%xmm0, -32 * SIZE(Y)

	addq	$1 * SIZE, X
	addq	$1 * SIZE, Y
	decq	M
	ALIGN_3

.L05:
	testq	$2 * SIZE, Y
	je	.L10

	movsd	-32 * SIZE(X), %xmm0
	movsd	-32 * SIZE(Y), %xmm1

	movlps	%xmm1, -32 * SIZE(X)
	movlps	%xmm0, -32 * SIZE(Y)

	addq	$2 * SIZE, X
	addq	$2 * SIZE, Y
	subq	$2, M
	jle	.L19
	ALIGN_3

.L10:
	cmpq	$3, M
	jle	.L16

	testq	$2 * SIZE, X
	jne	.L30

	testq	$1 * SIZE, X
	jne	.L20

	movq	M,  %rax
	sarq	$5, %rax
	jle	.L13
	ALIGN_3

.L11:
#ifdef PREFETCHW
	PREFETCHW (PREFETCHSIZE +  0) - PREOFFSET(X)
#endif

	movaps	-32 * SIZE(X), %xmm0
	movaps	-32 * SIZE(Y), %xmm1

	movaps	%xmm0, 	-32 * SIZE(Y)
	movaps	%xmm1, 	-32 * SIZE(X)

	movaps	-28 * SIZE(X), %xmm0
	movaps	-28 * SIZE(Y), %xmm1

	movaps	%xmm0, 	-28 * SIZE(Y)
	movaps	%xmm1, 	-28 * SIZE(X)

#ifdef PREFETCHW
	PREFETCHW (PREFETCHSIZE +  0) - PREOFFSET(Y)
#endif

	movaps	-24 * SIZE(X), %xmm0
	movaps	-24 * SIZE(Y), %xmm1

	movaps	%xmm0, 	-24 * SIZE(Y)
	movaps	%xmm1, 	-24 * SIZE(X)

	movaps	-20 * SIZE(X), %xmm0
	movaps	-20 * SIZE(Y), %xmm1

	movaps	%xmm0, 	-20 * SIZE(Y)
	movaps	%xmm1, 	-20 * SIZE(X)

#ifdef PREFETCHW
	PREFETCHW (PREFETCHSIZE + 64) - PREOFFSET(X)
#endif

	movaps	-16 * SIZE(X), %xmm0
	movaps	-16 * SIZE(Y), %xmm1

	movaps	%xmm0, 	-16 * SIZE(Y)
	movaps	%xmm1, 	-16 * SIZE(X)

	movaps	-12 * SIZE(X), %xmm0
	movaps	-12 * SIZE(Y), %xmm1

	movaps	%xmm0, 	-12 * SIZE(Y)
	movaps	%xmm1, 	-12 * SIZE(X)

#ifdef PREFETCHW
	PREFETCHW (PREFETCHSIZE + 64) - PREOFFSET(Y)
#endif

	movaps	 -8 * SIZE(X), %xmm0
	movaps	 -8 * SIZE(Y), %xmm1

	movaps	%xmm0, 	 -8 * SIZE(Y)
	movaps	%xmm1, 	 -8 * SIZE(X)

	movaps	 -4 * SIZE(X), %xmm0
	movaps	 -4 * SIZE(Y), %xmm1

	movaps	%xmm0, 	 -4 * SIZE(Y)
	movaps	%xmm1, 	 -4 * SIZE(X)

	subq	$-32 * SIZE, Y
	subq	$-32 * SIZE, X

	decq	%rax
	jg	.L11
	ALIGN_3

.L13:
	testq	$16, M
	jle	.L14

	movaps	-32 * SIZE(X), %xmm0
	movaps	-32 * SIZE(Y), %xmm1

	movaps	%xmm0, 	-32 * SIZE(Y)
	movaps	%xmm1, 	-32 * SIZE(X)

	movaps	-28 * SIZE(X), %xmm0
	movaps	-28 * SIZE(Y), %xmm1

	movaps	%xmm0, 	-28 * SIZE(Y)
	movaps	%xmm1, 	-28 * SIZE(X)

	movaps	-24 * SIZE(X), %xmm0
	movaps	-24 * SIZE(Y), %xmm1

	movaps	%xmm0, 	-24 * SIZE(Y)
	movaps	%xmm1, 	-24 * SIZE(X)

	movaps	-20 * SIZE(X), %xmm0
	movaps	-20 * SIZE(Y), %xmm1

	movaps	%xmm0, 	-20 * SIZE(Y)
 	movaps	%xmm1, 	-20 * SIZE(X)

	addq	$16 * SIZE, X
	addq	$16 * SIZE, Y
	ALIGN_3

.L14:
	testq	$8, M
	jle	.L15

	movaps	-32 * SIZE(X), %xmm0
	movaps	-32 * SIZE(Y), %xmm1

	movaps	%xmm0, 	-32 * SIZE(Y)
	movaps	%xmm1, 	-32 * SIZE(X)

	movaps	-28 * SIZE(X), %xmm0
	movaps	-28 * SIZE(Y), %xmm1

	movaps	%xmm0, 	-28 * SIZE(Y)
	movaps	%xmm1, 	-28 * SIZE(X)

	addq	$8 * SIZE, X
	addq	$8 * SIZE, Y
	ALIGN_3

.L15:
	testq	$4, M
	jle	.L16

	movaps	-32 * SIZE(X), %xmm0
	movaps	-32 * SIZE(Y), %xmm1

	movaps	%xmm0, 	-32 * SIZE(Y)
	movaps	%xmm1, 	-32 * SIZE(X)

	addq	$4 * SIZE, X
	addq	$4 * SIZE, Y
	ALIGN_3

.L16:
	testq	$2, M
	jle	.L17

	movsd	-32 * SIZE(X), %xmm0
	movsd	-32 * SIZE(Y), %xmm1

	movlps	%xmm1, 	-32 * SIZE(X)
	addq	$2 * SIZE, X
	movlps	%xmm0, 	-32 * SIZE(Y)
	addq	$2 * SIZE, Y
	ALIGN_3

.L17:
	testq	$1, M
	jle	.L19

	movss	-32 * SIZE(X), %xmm0
	movss	-32 * SIZE(Y), %xmm1

	movss	%xmm1, 	-32 * SIZE(X)
	movss	%xmm0, 	-32 * SIZE(Y)
	ALIGN_3

.L19:
	xorq	%rax,%rax

	RESTOREREGISTERS

#ifdef WINDOWS_ABI
	popq	%rbx
#endif

	ret
	ALIGN_3

.L20:
	movaps	 -33 * SIZE(X), %xmm0
	movaps	 -32 * SIZE(Y), %xmm1

	movss	%xmm1, -32 * SIZE(X)
	pshufd	$0x39, %xmm1, %xmm3
	movlps	%xmm3, -31 * SIZE(X)

	subq	$3, M

	movq	M,  %rax
	sarq	$5, %rax
	jle	.L23
	ALIGN_4

.L21:
#ifdef PREFETCHW
	PREFETCHW (PREFETCHSIZE +  0) - PREOFFSET(X)
#endif

	movaps	-29 * SIZE(X), %xmm2
	movaps	-28 * SIZE(Y), %xmm3

	movss	%xmm2, %xmm0
	shufps	$0x39, %xmm0, %xmm0
	movaps	%xmm0, -32 * SIZE(Y)
	movss	%xmm3, %xmm1
	shufps	$0x93, %xmm3, %xmm1
	movaps	%xmm1, -29 * SIZE(X)

	movaps	-25 * SIZE(X), %xmm0
	movaps	-24 * SIZE(Y), %xmm1

	movss	%xmm0, %xmm2
	shufps	$0x39, %xmm2, %xmm2
	movaps	%xmm2, -28 * SIZE(Y)
	movss	%xmm1, %xmm3
	shufps	$0x93, %xmm1, %xmm3
	movaps	%xmm3, -25 * SIZE(X)

#ifdef PREFETCHW
	PREFETCHW (PREFETCHSIZE +  0) - PREOFFSET(Y)
#endif

	movaps	-21 * SIZE(X), %xmm2
	movaps	-20 * SIZE(Y), %xmm3

	movss	%xmm2, %xmm0
	shufps	$0x39, %xmm0, %xmm0
	movaps	%xmm0, -24 * SIZE(Y)
	movss	%xmm3, %xmm1
	shufps	$0x93, %xmm3, %xmm1
	movaps	%xmm1, -21 * SIZE(X)

	movaps	-17 * SIZE(X), %xmm0
	movaps	-16 * SIZE(Y), %xmm1

	movss	%xmm0, %xmm2
	shufps	$0x39, %xmm2, %xmm2
	movaps	%xmm2, -20 * SIZE(Y)
	movss	%xmm1, %xmm3
	shufps	$0x93, %xmm1, %xmm3
	movaps	%xmm3, -17 * SIZE(X)

#ifdef PREFETCHW
	PREFETCHW (PREFETCHSIZE + 64) - PREOFFSET(X)
#endif

	movaps	-13 * SIZE(X), %xmm2
	movaps	-12 * SIZE(Y), %xmm3

	movss	%xmm2, %xmm0
	shufps	$0x39, %xmm0, %xmm0
	movaps	%xmm0, -16 * SIZE(Y)
	movss	%xmm3, %xmm1
	shufps	$0x93, %xmm3, %xmm1
	movaps	%xmm1, -13 * SIZE(X)

	movaps	 -9 * SIZE(X), %xmm0
	movaps	 -8 * SIZE(Y), %xmm1

	movss	%xmm0, %xmm2
	shufps	$0x39, %xmm2, %xmm2
	movaps	%xmm2, -12 * SIZE(Y)
	movss	%xmm1, %xmm3
	shufps	$0x93, %xmm1, %xmm3
	movaps	%xmm3,  -9 * SIZE(X)

#ifdef PREFETCHW
	PREFETCHW (PREFETCHSIZE + 64) - PREOFFSET(Y)
#endif

	movaps	 -5 * SIZE(X), %xmm2
	movaps	 -4 * SIZE(Y), %xmm3

	movss	%xmm2, %xmm0
	shufps	$0x39, %xmm0, %xmm0
	movaps	%xmm0,  -8 * SIZE(Y)
	movss	%xmm3, %xmm1
	shufps	$0x93, %xmm3, %xmm1
	movaps	%xmm1,  -5 * SIZE(X)

	movaps	 -1 * SIZE(X), %xmm0
	movaps	  0 * SIZE(Y), %xmm1

	movss	%xmm0, %xmm2
	shufps	$0x39, %xmm2, %xmm2
	movaps	%xmm2,  -4 * SIZE(Y)
	movss	%xmm1, %xmm3
	shufps	$0x93, %xmm1, %xmm3
	movaps	%xmm3,  -1 * SIZE(X)

	subq	$-32 * SIZE, X
	subq	$-32 * SIZE, Y

	decq	%rax
	jg	.L21
	ALIGN_3

.L23:
	testq	$16, M
	jle	.L24

	movaps	-29 * SIZE(X), %xmm2
	movaps	-28 * SIZE(Y), %xmm3

	movss	%xmm2, %xmm0
	shufps	$0x39, %xmm0, %xmm0
	movaps	%xmm0, -32 * SIZE(Y)
	movss	%xmm3, %xmm1
	shufps	$0x93, %xmm3, %xmm1
	movaps	%xmm1, -29 * SIZE(X)

	movaps	-25 * SIZE(X), %xmm0
	movaps	-24 * SIZE(Y), %xmm1

	movss	%xmm0, %xmm2
	shufps	$0x39, %xmm2, %xmm2
	movaps	%xmm2, -28 * SIZE(Y)
	movss	%xmm1, %xmm3
	shufps	$0x93, %xmm1, %xmm3
	movaps	%xmm3, -25 * SIZE(X)

	movaps	-21 * SIZE(X), %xmm2
	movaps	-20 * SIZE(Y), %xmm3

	movss	%xmm2, %xmm0
	shufps	$0x39, %xmm0, %xmm0
	movaps	%xmm0, -24 * SIZE(Y)
	movss	%xmm3, %xmm1
	shufps	$0x93, %xmm3, %xmm1
	movaps	%xmm1, -21 * SIZE(X)

	movaps	-17 * SIZE(X), %xmm0
	movaps	-16 * SIZE(Y), %xmm1

	movss	%xmm0, %xmm2
	shufps	$0x39, %xmm2, %xmm2
	movaps	%xmm2, -20 * SIZE(Y)
	movss	%xmm1, %xmm3
	shufps	$0x93, %xmm1, %xmm3
	movaps	%xmm3, -17 * SIZE(X)

	addq	$16 * SIZE, X
	addq	$16 * SIZE, Y
	ALIGN_3

.L24:
	testq	$8, M
	jle	.L25

	movaps	-29 * SIZE(X), %xmm2
	movaps	-28 * SIZE(Y), %xmm3

	movss	%xmm2, %xmm0
	shufps	$0x39, %xmm0, %xmm0
	movaps	%xmm0, -32 * SIZE(Y)
	movss	%xmm3, %xmm1
	shufps	$0x93, %xmm3, %xmm1
	movaps	%xmm1, -29 * SIZE(X)

	movaps	-25 * SIZE(X), %xmm0
	movaps	-24 * SIZE(Y), %xmm1

	movss	%xmm0, %xmm2
	shufps	$0x39, %xmm2, %xmm2
	movaps	%xmm2, -28 * SIZE(Y)
	movss	%xmm1, %xmm3
	shufps	$0x93, %xmm1, %xmm3
	movaps	%xmm3, -25 * SIZE(X)

	addq	$8 * SIZE, X
	addq	$8 * SIZE, Y
	ALIGN_3

.L25:
	testq	$4, M
	jle	.L26

	movaps	-29 * SIZE(X), %xmm2
	movaps	-28 * SIZE(Y), %xmm3

	movss	%xmm2, %xmm0
	shufps	$0x39, %xmm0, %xmm0
	movaps	%xmm0, -32 * SIZE(Y)
	movss	%xmm3, %xmm1
	shufps	$0x93, %xmm3, %xmm1
	movaps	%xmm1, -29 * SIZE(X)

	movaps	%xmm2, %xmm0
	movaps	%xmm3, %xmm1

	addq	$4 * SIZE, X
	addq	$4 * SIZE, Y
	ALIGN_3

.L26:
	pshufd	$0x39, %xmm0, %xmm2
	pshufd	$0xff, %xmm0, %xmm0

	movlps	%xmm2, -32 * SIZE(Y)
	movss	%xmm0, -30 * SIZE(Y)

	testq	$2, M
	jle	.L27

	movsd	-29 * SIZE(X), %xmm0
	movsd	-29 * SIZE(Y), %xmm1

	movlps	%xmm0, -29 * SIZE(Y)
	movlps	%xmm1, -29 * SIZE(X)

	addq	$2 * SIZE, X
	addq	$2 * SIZE, Y
	ALIGN_3

.L27:
	testq	$1, M
	jle	.L29

	movss	-29 * SIZE(X), %xmm0
	movss	-29 * SIZE(Y), %xmm1

	movss	%xmm0, -29 * SIZE(Y)
	movss	%xmm1, -29 * SIZE(X)
	ALIGN_3

.L29:
	xorq	%rax,%rax

	RESTOREREGISTERS

#ifdef WINDOWS_ABI
	popq	%rbx
#endif

	ret
	ALIGN_3

.L30:
	testq	$1 * SIZE, X
	jne	.L40

	movhps	 -32 * SIZE(X), %xmm0
	movaps	 -32 * SIZE(Y), %xmm1

	movlps	%xmm1, -32 * SIZE(X)
	subq	$2, M

	movq	M,  %rax
	sarq	$5, %rax
	jle	.L33
	ALIGN_4

.L31:
#ifdef PREFETCHW
	PREFETCHW (PREFETCHSIZE +  0) - PREOFFSET(X)
#endif

	movaps	-30 * SIZE(X), %xmm2
	movaps	-28 * SIZE(Y), %xmm3

	SHUFPD_1  %xmm2, %xmm0
	movaps	%xmm0, -32 * SIZE(Y)
	SHUFPD_1  %xmm3, %xmm1
	movaps	%xmm1, -30 * SIZE(X)

	movaps	-26 * SIZE(X), %xmm0
	movaps	-24 * SIZE(Y), %xmm1

	SHUFPD_1  %xmm0, %xmm2
	movaps	%xmm2, -28 * SIZE(Y)
	SHUFPD_1  %xmm1, %xmm3
	movaps	%xmm3, -26 * SIZE(X)

#ifdef PREFETCHW
	PREFETCHW (PREFETCHSIZE +  0) - PREOFFSET(Y)
#endif

	movaps	-22 * SIZE(X), %xmm2
	movaps	-20 * SIZE(Y), %xmm3

	SHUFPD_1  %xmm2, %xmm0
	movaps	%xmm0, -24 * SIZE(Y)
	SHUFPD_1  %xmm3, %xmm1
	movaps	%xmm1, -22 * SIZE(X)

	movaps	-18 * SIZE(X), %xmm0
	movaps	-16 * SIZE(Y), %xmm1

	SHUFPD_1  %xmm0, %xmm2
	movaps	%xmm2, -20 * SIZE(Y)
	SHUFPD_1  %xmm1, %xmm3
	movaps	%xmm3, -18 * SIZE(X)

#ifdef PREFETCHW
	PREFETCHW (PREFETCHSIZE + 64) - PREOFFSET(X)
#endif

	movaps	-14 * SIZE(X), %xmm2
	movaps	-12 * SIZE(Y), %xmm3

	SHUFPD_1  %xmm2, %xmm0
	movaps	%xmm0, -16 * SIZE(Y)
	SHUFPD_1  %xmm3, %xmm1
	movaps	%xmm1, -14 * SIZE(X)

	movaps	-10 * SIZE(X), %xmm0
	movaps	 -8 * SIZE(Y), %xmm1

	SHUFPD_1  %xmm0, %xmm2
	movaps	%xmm2, -12 * SIZE(Y)
	SHUFPD_1  %xmm1, %xmm3
	movaps	%xmm3, -10 * SIZE(X)

#ifdef PREFETCHW
	PREFETCHW (PREFETCHSIZE + 64) - PREOFFSET(Y)
#endif

	movaps	 -6 * SIZE(X), %xmm2
	movaps	 -4 * SIZE(Y), %xmm3

	SHUFPD_1  %xmm2, %xmm0
	movaps	%xmm0,  -8 * SIZE(Y)
	SHUFPD_1  %xmm3, %xmm1
	movaps	%xmm1,  -6 * SIZE(X)

	movaps	 -2 * SIZE(X), %xmm0
	movaps	  0 * SIZE(Y), %xmm1

	SHUFPD_1  %xmm0, %xmm2
	movaps	%xmm2,  -4 * SIZE(Y)
	SHUFPD_1  %xmm1, %xmm3
	movaps	%xmm3,  -2 * SIZE(X)

	subq	$-32 * SIZE, X
	subq	$-32 * SIZE, Y

	decq	%rax
	jg	.L31
	ALIGN_3

.L33:
	testq	$16, M
	jle	.L34

	movaps	-30 * SIZE(X), %xmm2
	movaps	-28 * SIZE(Y), %xmm3

	SHUFPD_1  %xmm2, %xmm0
	movaps	%xmm0, -32 * SIZE(Y)
	SHUFPD_1  %xmm3, %xmm1
	movaps	%xmm1, -30 * SIZE(X)

	movaps	-26 * SIZE(X), %xmm0
	movaps	-24 * SIZE(Y), %xmm1

	SHUFPD_1  %xmm0, %xmm2
	movaps	%xmm2, -28 * SIZE(Y)
	SHUFPD_1  %xmm1, %xmm3
	movaps	%xmm3, -26 * SIZE(X)

	movaps	-22 * SIZE(X), %xmm2
	movaps	-20 * SIZE(Y), %xmm3

	SHUFPD_1  %xmm2, %xmm0
	movaps	%xmm0, -24 * SIZE(Y)
	SHUFPD_1  %xmm3, %xmm1
	movaps	%xmm1, -22 * SIZE(X)

	movaps	-18 * SIZE(X), %xmm0
	movaps	-16 * SIZE(Y), %xmm1

	SHUFPD_1  %xmm0, %xmm2
	movaps	%xmm2, -20 * SIZE(Y)
	SHUFPD_1  %xmm1, %xmm3
	movaps	%xmm3, -18 * SIZE(X)

	addq	$16 * SIZE, X
	addq	$16 * SIZE, Y
	ALIGN_3

.L34:
	testq	$8, M
	jle	.L35

	movaps	-30 * SIZE(X), %xmm2
	movaps	-28 * SIZE(Y), %xmm3

	SHUFPD_1  %xmm2, %xmm0
	movaps	%xmm0, -32 * SIZE(Y)
	SHUFPD_1  %xmm3, %xmm1
	movaps	%xmm1, -30 * SIZE(X)

	movaps	-26 * SIZE(X), %xmm0
	movaps	-24 * SIZE(Y), %xmm1

	SHUFPD_1  %xmm0, %xmm2
	movaps	%xmm2, -28 * SIZE(Y)
	SHUFPD_1  %xmm1, %xmm3
	movaps	%xmm3, -26 * SIZE(X)

	addq	$8 * SIZE, X
	addq	$8 * SIZE, Y
	ALIGN_3

.L35:
	testq	$4, M
	jle	.L36

	movaps	-30 * SIZE(X), %xmm2
	movaps	-28 * SIZE(Y), %xmm3

	SHUFPD_1  %xmm2, %xmm0
	movaps	%xmm0, -32 * SIZE(Y)
	SHUFPD_1  %xmm3, %xmm1
	movaps	%xmm1, -30 * SIZE(X)

	movaps	%xmm2, %xmm0
	movaps	%xmm3, %xmm1

	addq	$4 * SIZE, X
	addq	$4 * SIZE, Y
	ALIGN_3

.L36:
	movhps	%xmm0, -32 * SIZE(Y)

	testq	$2, M
	jle	.L37

	movsd	-30 * SIZE(X), %xmm0
	movsd	-30 * SIZE(Y), %xmm1

	movlps	%xmm0, -30 * SIZE(Y)
	movlps	%xmm1, -30 * SIZE(X)

	addq	$2 * SIZE, X
	addq	$2 * SIZE, Y
	ALIGN_3

.L37:
	testq	$1, M
	jle	.L39

	movss	-30 * SIZE(X), %xmm0
	movss	-30 * SIZE(Y), %xmm1

	movss	%xmm0, -30 * SIZE(Y)
	movss	%xmm1, -30 * SIZE(X)
	ALIGN_3

.L39:
	xorq	%rax,%rax

	RESTOREREGISTERS

#ifdef WINDOWS_ABI
	popq	%rbx
#endif

	ret
	ALIGN_3

.L40:
	movaps	 -35 * SIZE(X), %xmm0
	movaps	 -32 * SIZE(Y), %xmm1

	movss	%xmm1, -32 * SIZE(X)

	subq	$3, M

	movq	M,  %rax
	sarq	$5, %rax
	jle	.L43
	ALIGN_4

.L41:
#ifdef PREFETCHW
	PREFETCHW (PREFETCHSIZE +  0) - PREOFFSET(X)
#endif

	movaps	-31 * SIZE(X), %xmm2
	movaps	-28 * SIZE(Y), %xmm3

	movss	%xmm2, %xmm0
	shufps	$0x93, %xmm2, %xmm0
	movaps	%xmm0, -32 * SIZE(Y)
	movss	%xmm3, %xmm1
	shufps	$0x39, %xmm1, %xmm1
	movaps	%xmm1, -31 * SIZE(X)

	movaps	-27 * SIZE(X), %xmm0
	movaps	-24 * SIZE(Y), %xmm1

	movss	%xmm0, %xmm2
	shufps	$0x93, %xmm0, %xmm2
	movaps	%xmm2, -28 * SIZE(Y)
	movss	%xmm1, %xmm3
	shufps	$0x39, %xmm3, %xmm3
	movaps	%xmm3, -27 * SIZE(X)

#ifdef PREFETCHW
	PREFETCHW (PREFETCHSIZE +  0) - PREOFFSET(Y)
#endif

	movaps	-23 * SIZE(X), %xmm2
	movaps	-20 * SIZE(Y), %xmm3

	movss	%xmm2, %xmm0
	shufps	$0x93, %xmm2, %xmm0
	movaps	%xmm0, -24 * SIZE(Y)
	movss	%xmm3, %xmm1
	shufps	$0x39, %xmm1, %xmm1
	movaps	%xmm1, -23 * SIZE(X)

	movaps	-19 * SIZE(X), %xmm0
	movaps	-16 * SIZE(Y), %xmm1

	movss	%xmm0, %xmm2
	shufps	$0x93, %xmm0, %xmm2
	movaps	%xmm2, -20 * SIZE(Y)
	movss	%xmm1, %xmm3
	shufps	$0x39, %xmm3, %xmm3
	movaps	%xmm3, -19 * SIZE(X)

#ifdef PREFETCHW
	PREFETCHW (PREFETCHSIZE + 64) - PREOFFSET(X)
#endif

	movaps	-15 * SIZE(X), %xmm2
	movaps	-12 * SIZE(Y), %xmm3

	movss	%xmm2, %xmm0
	shufps	$0x93, %xmm2, %xmm0
	movaps	%xmm0, -16 * SIZE(Y)
	movss	%xmm3, %xmm1
	shufps	$0x39, %xmm1, %xmm1
	movaps	%xmm1, -15 * SIZE(X)

	movaps	-11 * SIZE(X), %xmm0
	movaps	 -8 * SIZE(Y), %xmm1

	movss	%xmm0, %xmm2
	shufps	$0x93, %xmm0, %xmm2
	movaps	%xmm2, -12 * SIZE(Y)
	movss	%xmm1, %xmm3
	shufps	$0x39, %xmm3, %xmm3
	movaps	%xmm3, -11 * SIZE(X)

#ifdef PREFETCHW
	PREFETCHW (PREFETCHSIZE + 64) - PREOFFSET(Y)
#endif

	movaps	 -7 * SIZE(X), %xmm2
	movaps	 -4 * SIZE(Y), %xmm3

	movss	%xmm2, %xmm0
	shufps	$0x93, %xmm2, %xmm0
	movaps	%xmm0,  -8 * SIZE(Y)
	movss	%xmm3, %xmm1
	shufps	$0x39, %xmm1, %xmm1
	movaps	%xmm1,  -7 * SIZE(X)

	movaps	 -3 * SIZE(X), %xmm0
	movaps	  0 * SIZE(Y), %xmm1

	movss	%xmm0, %xmm2
	shufps	$0x93, %xmm0, %xmm2
	movaps	%xmm2,  -4 * SIZE(Y)
	movss	%xmm1, %xmm3
	shufps	$0x39, %xmm3, %xmm3
	movaps	%xmm3,  -3 * SIZE(X)

	subq	$-32 * SIZE, X
	subq	$-32 * SIZE, Y

	decq	%rax
	jg	.L41
	ALIGN_3

.L43:
	testq	$16, M
	jle	.L44

	movaps	-31 * SIZE(X), %xmm2
	movaps	-28 * SIZE(Y), %xmm3

	movss	%xmm2, %xmm0
	shufps	$0x93, %xmm2, %xmm0
	movaps	%xmm0, -32 * SIZE(Y)
	movss	%xmm3, %xmm1
	shufps	$0x39, %xmm1, %xmm1
	movaps	%xmm1, -31 * SIZE(X)

	movaps	-27 * SIZE(X), %xmm0
	movaps	-24 * SIZE(Y), %xmm1

	movss	%xmm0, %xmm2
	shufps	$0x93, %xmm0, %xmm2
	movaps	%xmm2, -28 * SIZE(Y)
	movss	%xmm1, %xmm3
	shufps	$0x39, %xmm3, %xmm3
	movaps	%xmm3, -27 * SIZE(X)

	movaps	-23 * SIZE(X), %xmm2
	movaps	-20 * SIZE(Y), %xmm3

	movss	%xmm2, %xmm0
	shufps	$0x93, %xmm2, %xmm0
	movaps	%xmm0, -24 * SIZE(Y)
	movss	%xmm3, %xmm1
	shufps	$0x39, %xmm1, %xmm1
	movaps	%xmm1, -23 * SIZE(X)

	movaps	-19 * SIZE(X), %xmm0
	movaps	-16 * SIZE(Y), %xmm1

	movss	%xmm0, %xmm2
	shufps	$0x93, %xmm0, %xmm2
	movaps	%xmm2, -20 * SIZE(Y)
	movss	%xmm1, %xmm3
	shufps	$0x39, %xmm3, %xmm3
	movaps	%xmm3, -19 * SIZE(X)

	addq	$16 * SIZE, X
	addq	$16 * SIZE, Y
	ALIGN_3

.L44:
	testq	$8, M
	jle	.L45

	movaps	-31 * SIZE(X), %xmm2
	movaps	-28 * SIZE(Y), %xmm3

	movss	%xmm2, %xmm0
	shufps	$0x93, %xmm2, %xmm0
	movaps	%xmm0, -32 * SIZE(Y)
	movss	%xmm3, %xmm1
	shufps	$0x39, %xmm1, %xmm1
	movaps	%xmm1, -31 * SIZE(X)

	movaps	-27 * SIZE(X), %xmm0
	movaps	-24 * SIZE(Y), %xmm1

	movss	%xmm0, %xmm2
	shufps	$0x93, %xmm0, %xmm2
	movaps	%xmm2, -28 * SIZE(Y)
	movss	%xmm1, %xmm3
	shufps	$0x39, %xmm3, %xmm3
	movaps	%xmm3, -27 * SIZE(X)

	addq	$8 * SIZE, X
	addq	$8 * SIZE, Y
	ALIGN_3

.L45:
	testq	$4, M
	jle	.L46

	movaps	-31 * SIZE(X), %xmm2
	movaps	-28 * SIZE(Y), %xmm3

	movss	%xmm2, %xmm0
	shufps	$0x93, %xmm2, %xmm0
	movaps	%xmm0, -32 * SIZE(Y)
	movss	%xmm3, %xmm1
	shufps	$0x39, %xmm1, %xmm1
	movaps	%xmm1, -31 * SIZE(X)

	movaps	%xmm2, %xmm0
	movaps	%xmm3, %xmm1

	addq	$4 * SIZE, X
	addq	$4 * SIZE, Y
	ALIGN_3

.L46:
	movsd	-31 * SIZE(X), %xmm2

	pshufd	$0x39, %xmm1, %xmm1
	movlps	%xmm1, -31 * SIZE(X)

	pshufd	$0xff, %xmm0, %xmm0

	movss	%xmm0, -32 * SIZE(Y)
	movlps	%xmm2, -31 * SIZE(Y)

	addq	$3 * SIZE, X
	addq	$3 * SIZE, Y

	testq	$2, M
	jle	.L47

	movsd	-32 * SIZE(X), %xmm0
	movsd	-32 * SIZE(Y), %xmm1

	movlps	%xmm0, -32 * SIZE(Y)
	movlps	%xmm1, -32 * SIZE(X)

	addq	$2 * SIZE, X
	addq	$2 * SIZE, Y
	ALIGN_3

.L47:
	testq	$1, M
	jle	.L49

	movss	-32 * SIZE(X), %xmm0
	movss	-32 * SIZE(Y), %xmm1

	movss	%xmm0, -32 * SIZE(Y)
	movss	%xmm1, -32 * SIZE(X)
	ALIGN_3

.L49:
	xorq	%rax,%rax

	RESTOREREGISTERS

#ifdef WINDOWS_ABI
	popq	%rbx
#endif

	ret
	ALIGN_3

.L50:
	movq	M,  %rax
	sarq	$2, %rax
	jle	.L55
	ALIGN_3

.L51:
	movsd	(X), %xmm0
	movsd	(Y), %xmm1

	movlps	%xmm1, (X)
	addq	INCX, X
	movlps	%xmm0, (Y)
	addq	INCY, Y

	movsd	(X), %xmm0
	movsd	(Y), %xmm1

	movlps	%xmm1, (X)
	addq	INCX, X
	movlps	%xmm0, (Y)
	addq	INCY, Y

	movsd	(X), %xmm0
	movsd	(Y), %xmm1

	movlps	%xmm1, (X)
	addq	INCX, X
	movlps	%xmm0, (Y)
	addq	INCY, Y

	movsd	(X), %xmm0
	movsd	(Y), %xmm1

	movlps	%xmm1, (X)
	addq	INCX, X
	movlps	%xmm0, (Y)
	addq	INCY, Y

	decq	%rax
	jg	.L51
	ALIGN_3

.L55:
	movq	M,  %rax
	andq	$3, %rax
	jle	.L57
	ALIGN_3

.L56:
	movsd	(X), %xmm0
	movsd	(Y), %xmm1

	movlps	%xmm1, (X)
	addq	INCX, X
	movlps	%xmm0, (Y)
	addq	INCY, Y

	decq	%rax
	jg	.L56
	ALIGN_3

.L57:
	xorq	%rax, %rax

	RESTOREREGISTERS

#ifdef WINDOWS_ABI
	popq	%rbx
#endif

	ret
	ALIGN_3

	EPILOGUE
