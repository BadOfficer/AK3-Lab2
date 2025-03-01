SDK_PREFIX?=arm-none-eabi-
CC = $(SDK_PREFIX)gcc
LD = $(SDK_PREFIX)ld
SIZE = $(SDK_PREFIX)size
OBJCOPY = $(SDK_PREFIX)objcopy
QEMU = $(QEMU_SYSTEM_GNUARMECLIPSE)
BOARD ?= STM32F4-Discovery
MCU=STM32F407VG
TARGET=firmware
CPU_CC=cortex-m4 # Target CPU architecture
TCP_ADDR=1234 # TCP address for debugging
# List of dependencies
deps = \
	start.S \
	lab2.S \
	lscript.ld

# Default target
all: target

# Build target
target:
	$(CC) -x assembler-with-cpp -c -O0 -g3 -mcpu=$(CPU_CC) -Wall start.S -o start.o
	$(CC) -x assembler-with-cpp -c -O0 -g3 -mcpu=$(CPU_CC) -Wall lab2.S -o lab2.o

	$(CC) start.o lab2.o -mcpu=$(CPU_CC) -Wall --specs=nosys.specs -nostdlib -lgcc -T ./lscript.ld -o $(TARGET).elf
	$(OBJCOPY) -O binary -F elf32-littlearm $(TARGET).elf $(TARGET).bin

# Run the firmware in QEMU for debugging
qemu:
	$(QEMU) --verbose --verbose --board $(BOARD) --mcu $(MCU) -d unimp,guest_errors --image $(TARGET).bin --semihosting-config enable=on,target=native -gdb tcp::$(TCP_ADDR) -S

# Clean up generated files
clean:
	-rm *.o
	-rm *.elf
	-rm *.bin
