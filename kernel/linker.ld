/* linker.ld — Kernel Linker Script */
ENTRY(kernel_main)

SECTIONS {
    . = 0x2000;

    .text : {
        *(.text)
    }

    .rodata : {
        *(.rodata)
    }

    .data : {
        *(.data)
    }

    .bss : {
        *(.bss)
    }
}
