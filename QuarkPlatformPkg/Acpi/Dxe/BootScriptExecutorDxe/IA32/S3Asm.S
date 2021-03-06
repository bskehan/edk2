## @file
#
# Copyright (c) 2013-2015 Intel Corporation.
#
# SPDX-License-Identifier: BSD-2-Clause-Patent

#-----------------------------------------
#VOID
#AsmTransferControl (
#  IN   UINT32           S3WakingVector,
#  IN   UINT32           AcpiLowMemoryBase
#  );
#-----------------------------------------

ASM_GLOBAL ASM_PFX(AsmTransferControl)
ASM_PFX(AsmTransferControl):
    # S3WakingVector    :DWORD
    # AcpiLowMemoryBase :DWORD
    pushl %ebp
    movl  %esp,%ebp
    leal  LABLE, %eax
    pushl $0x28             # CS
    pushl %eax
    movl  8(%ebp),%ecx
    shrdl $20,%ecx,%ebx
    andl  $0xf,%ecx
    movw  %cx,%bx
    movl  %ebx, jmp_addr
    lret
LABLE:
    .byte 0xb8,0x30,0       # mov ax, 30h as selector
    movw  %ax,%ds
    movw  %ax,%es
    movw  %ax,%fs
    movw  %ax,%gs
    movw  %ax,%ss
    movl  %cr0, %eax        # Get control register 0
    .byte 0x66
    .byte 0x83,0xe0,0xfe    # and    eax, 0fffffffeh  ; Clear PE bit (bit #0)
    .byte 0xf,0x22,0xc0     # mov    cr0, eax         ; Activate real mode
    .byte 0xea              # jmp far @jmp_addr
jmp_addr:
    .long    0

