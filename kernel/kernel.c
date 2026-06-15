/* kernel.c — Minimal kernel with VGA text output */

#define VGA_ADDRESS 0xB8000
#define VGA_WIDTH 80
#define VGA_HEIGHT 25

typedef unsigned char uint8_t;
typedef unsigned short uint16_t;
typedef unsigned int uint32_t;

// VGA color codes
enum vga_color {
    VGA_BLACK = 0,
    VGA_BLUE = 1,
    VGA_GREEN = 2,
    VGA_CYAN = 3,
    VGA_RED = 4,
    VGA_MAGENTA = 5,
    VGA_BROWN = 6,
    VGA_LIGHT_GREY = 7,
    VGA_WHITE = 15
};

static uint16_t* const vga_buffer = (uint16_t*) VGA_ADDRESS;
static int cursor_x = 0;
static int cursor_y = 0;

static inline uint16_t vga_entry(char c, uint8_t color) {
    return (uint16_t) c | (uint16_t) color << 8;
}

void clear_screen() {
    for (int i = 0; i < VGA_WIDTH * VGA_HEIGHT; i++) {
        vga_buffer[i] = vga_entry(' ', VGA_LIGHT_GREY);
    }
    cursor_x = 0;
    cursor_y = 0;
}

void print_char(char c, uint8_t color) {
    if (c == '\n') {
        cursor_x = 0;
        cursor_y++;
        return;
    }
    int offset = cursor_y * VGA_WIDTH + cursor_x;
    vga_buffer[offset] = vga_entry(c, color);
    cursor_x++;
    if (cursor_x >= VGA_WIDTH) {
        cursor_x = 0;
        cursor_y++;
    }
}

void print_string(const char* str, uint8_t color) {
    for (int i = 0; str[i] != '\0'; i++) {
        print_char(str[i], color);
    }
}

void kernel_main() {
    clear_screen();
    print_string("=================================\n", VGA_GREEN);
    print_string("  Welcome to MyOS v0.1           \n", VGA_WHITE);
    print_string("  Kernel loaded successfully!    \n", VGA_CYAN);
    print_string("=================================\n", VGA_GREEN);
    print_string("\n> Ready.\n", VGA_LIGHT_GREY);

    // Halt the CPU
    while(1) {
        __asm__ __volatile__("hlt");
    }
}
