bits 32
global _start
extern kernel_early
extern main

section .text; Tell the compiler that the following lines will be the actual code that handles the processing.
    align 4; Directive that allows you to enforce alignment of the instruction or data immediately after the directive. Whatever number follows the align directive must be a power of 2 (i.e. 2, 4, 8, 16, 32, …) and must not be greater than the default alignment of the segment which we defined by saying that this should compile for a 32-bit system (i.e. "bits 32"). Since the system is expected to be 32 bits (i.e. 4 bytes), we must use alignment values that are less than or equal to 4.
    dd 0x1BADB002; Double-word (i.e. 4 bytes) that indicates a "magic" field that is required by GRUB.
    dd 0x00; Define "flags" that are needed by GRUB. Since we will not be needing any additional flags at this time, we will simply set this field to zero.
    dd - (0x1BADB002 + 0x00) ; Checksum that, when added to the values of the magic and flags fields, should always be equal to zero.

_start:
    cli; Disable (or CLear) Interrupts by using the "cli" command. This is done because other instructions such as the "hlt" (halt) instruction can awake the CPU, telling it to do other things – sometimes unintended.
    mov esp, stack; Allocate some memory for the stack and point the stack pointer (esp) to it. The stack itself is defined as the last function in the file (indicated by "stack:"). But, since there are no other instructions after it, this indicates that the function is currently empty. We are just allocating memory for it and mapping it to the stack pointer.
    call kernel_early; 
    call main; Tell the system that it should now execute the instructions found in our "main" function. This function will be provided by our kernel’s C code defined in a separate file.
    hlt; Tell the system to "halt" as defined by the "hlt" instruction as we have nothing left for the CPU to process. Later on we will omit this instruction because we will want the CPU to continue processing further commands (such as user input).

section .bss
resb 8192; Reserve 8KB of memory for our stack. The "res" part of the instruction represents "reserve" while the "b" part of the instruction represents "bytes". You could have just as easily used "resw" to reserve a "word", "resd" to reserve a "double", or "resq" to reserve an array of ten reals.
stack: