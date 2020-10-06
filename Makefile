AVRDUDE_PATH = avrdude

SRC_DIR = ./src
INCLUDE_DIRS = -I./include -I/usr/lib/avr/include

CC = avr-gcc
OBJCOPY = avr-objcopy

AVRDUDE = $(AVRDUDE_PATH)
PORT = usb
PROGRAMMER = usbasp
MCU = attiny85
PART = t85

CFLAGS = -Os -DF_CPU=1000000UL $(INCLUDE_DIRS) -std=c11 -mmcu=$(MCU)
LDFLAGS = -L/usr/lib/avr/lib -mmcu=$(MCU)
OBJECTS = $(TARGET).o

TARGET = main

all: clean upload

$(TARGET).hex: $(TARGET).elf
	$(OBJCOPY) -O ihex -R .eeprom $< $@

$(TARGET).elf: $(OBJECTS)
	$(CC) $(LDFLAGS) -o $@ $^

%.o: $(SRC_DIR)/%.c
	$(CC) $(CFLAGS) -c $< -o $@

upload: $(TARGET).hex
	$(AVRDUDE) -v -c $(PROGRAMMER) -p $(PART) -P $(PORT) -U flash:w:$<:i -U lfuse:w:0x62:m -U hfuse:w:0xDF:m -Uefuse:w:0xFF:m

clean:
	-rm -f $(TARGET).hex $(TARGET).elf $(OBJECTS)
