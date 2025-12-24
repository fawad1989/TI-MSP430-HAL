# ============================
# Project configuration
# ============================

PROJECT_NAME := blink
MCU          := msp430g2553

# Project paths
PROJECT_ROOT := /mnt/8A0C7A920C7A7951/Project/ti/TI-MSP430-HAL
SRC_DIR      := $(PROJECT_ROOT)/app/Src
TOOLCHAIN    := $(PROJECT_ROOT)/toolchain

# TI MSP430 GCC toolchain (explicit)
TOOLCHAIN_BIN := $(TOOLCHAIN)/MSP430/GCC_source_files/msp430-gcc-9.3.1.11_linux64/bin

# Support files (headers, linker scripts, etc.)
SUPPORT_DIR := $(TOOLCHAIN)/MSP430/GCC_source_files/msp430-gcc-support-files-1.212/msp430-gcc-support-files
INCLUDES    := -I$(SUPPORT_DIR)/include
LIBS        := -L$(SUPPORT_DIR)/include

# UniFlash / CCS configuration
CCXML    := $(TOOLCHAIN)/MSP430G2553.ccxml
UNIFLASH := /opt/ti/uniflash_9.4.0/dslite.sh

# Tools
CC      := $(TOOLCHAIN_BIN)/msp430-elf-gcc
OBJCOPY := $(TOOLCHAIN_BIN)/msp430-elf-objcopy

# Files
SRC := $(SRC_DIR)/blink.c
ELF := $(SRC_DIR)/$(PROJECT_NAME).elf
HEX := $(SRC_DIR)/$(PROJECT_NAME).hex

# Compiler flags
CFLAGS  := -mmcu=$(MCU) -Os $(INCLUDES)
LDFLAGS := $(LIBS)

# ============================
# Targets
# ============================

all: build

build: $(HEX)

$(ELF): $(SRC)
	$(CC) $(CFLAGS) $< -o $@ $(LDFLAGS)

$(HEX): $(ELF)
	$(OBJCOPY) -O ihex $< $@

flash: $(HEX)
	$(UNIFLASH) -c $(CCXML) -f $(HEX) -r 1


clean:
	rm -f $(ELF) $(HEX)

.PHONY: all build flash clean
