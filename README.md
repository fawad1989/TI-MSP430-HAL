## Day1

### 14/09/2025
Created folder structure

**root**

    ```
    touch CMakeLists.txt README.md
    ```
**Application + common utilities (portable)**

    ```
    mkdir -p app/{Inc,Src}
    touch app/Inc/.gitkeep app/Src/.gitkeep
    mkdir -p common
    touch common/.gitkeep
    ```
**MCU-specific (TI MSP430 only for now)**

    ```
    mkdir -p mcu/msp430/{ll,drivers,hal}
    touch mcu/msp430/ll/.gitkeep
    touch mcu/msp430/drivers/.gitkeep
    touch mcu/msp430/hal/.gitkeep
    ```
**Boards (TI LaunchPad, etc.)**

    ```
    mkdir -p boards/ti/launchpad_g2553
    touch boards/ti/launchpad_g2553/.gitkeep
    ```
**Toolchain & build**

    ```
    mkdir -p toolchain/{cmake,linker,startup}
    touch toolchain/cmake/.gitkeep
    touch toolchain/linker/.gitkeep
    touch toolchain/startup/.gitkeep
    ```
**Tests, scripts, docs**

    ```
    mkdir -p tests scripts docs
    touch tests/.gitkeep scripts/.gitkeep docs/.gitkeep
    ```
    The final structure would look like as follows
    ```    
    TI-MSP430-HAL/
    ├─ app/
    │  ├─ Inc/
    │  └─ Src/
    ├─ common/
    ├─ mcu/
    │  └─ msp430/
    │     ├─ ll/
    │     ├─ drivers/
    │     └─ hal/
    ├─ boards/
    │  └─ ti/
    │     └─ launchpad_g2553/
    ├─ toolchain/
    │  ├─ cmake/
    │  ├─ linker/
    │  └─ startup/
    ├─ tests/
    ├─ scripts/
    ├─ docs/
    ├─ CMakeLists.txt
    └─ README.md
    ```
## Day2
### 27/09/2025
1. Download GCC Toolchain for the TI-MSP430G2553
    1. Download the following tool chain from TI. 
        1. https://dr-download.ti.com/software-development/ide-configuration-compiler-or-debugger/MD-LlCjWuAbzH/9.3.1.2/msp430-gcc-9.3.1.11_linux64.tar.bz2 
        
            --> Mitto Systems GCC 64-bit Linux - toolchain only
        2. https://dr-download.ti.com/software-development/ide-configuration-compiler-or-debugger/MD-LlCjWuAbzH/9.3.1.2/msp430-gcc-support-files-1.212.zip 
        
            --> Header and Support Files
        or Download the toolchain which is fit for the project's need but only from TI. 
    2. Unzip and move to the 
        ```
        /<BASE-PROJECT-PATH>/TI-MSP430-HAL/toolchain/MSP430 folder
        ```

## Day3
### 23/12/2025
 1. Making the toolchain work
    - Manual Compilation
        1. check version by the following command 
            ```
            /<BASE-PROJECT-PATH>/TI-MSP430-HAL/toolchain/MS/GCC_source_files/msp430-gcc-9.3.1.11_linux64/bin/msp430-elf-gcc --version 
            ```
            return
            ``` msp430-elf-gcc (Mitto Systems Limited - msp430-gcc 9.3.1.11)

            ```
        2. Make the compiler available in the shell
            ```
            export PATH="$(/<BASE-PROJECT-PATH>)/toolchain/MS/GCC_source_files/msp430-gcc-9.3.1.11_linux64/bin:$PATH"
            ```
        3. Verify 
            ```
            msp430-elf-gcc --version 
            ```
            return
            ```            
            msp430-elf-gcc (Mitto Systems Limited - msp430-gcc 9.3.1.11) 9.3.1
            Copyright (C) 2019 Free Software Foundation, Inc.
            This is free software; see the source for copying conditions.  There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
            ```
        4. Attempting a failed compilation 
            1. Go to the folder app/Src/blink.c
                ```
                msp430-elf-gcc -mmcu=msp430g2553 blink.c -o blinky.elf

                ```
                return 
                ``` 
                blink.c:1:10: fatal error: msp430.h: No such file or directory
                1 | #include <msp430.h>
                |          ^~~~~~~~~~
                compilation terminated.
                ```
        5. Locate required header
            1. Find the msp430.h header file in the tool chain. Move to the 
                ```
                find /<BASE-PROJECT-PATH>/TI-MSP430-HAL/toolchain/MSP430/GCC_source_files -name msp430.h
                ```
                return a bunch of places but needed header file is in 
                ```
                /<BASE-PROJECT-PATH>/TI-MSP430-HAL/toolchain/MSP430/GCC_source_files/msp430-gcc-support-files-1.212/msp430-gcc-support-files/include/msp430.h
                ```

        6. Compile the code
            Use the following code to compile the main.c (its blink.c in this case)
                ```
                msp430-elf-gcc \
                -mmcu=msp430g2553 \
                -I//<BASE-PROJECT-PATH>/TI-MSP430-HAL/toolchain/MSP430/GCC_source_files/msp430-gcc-support-files-1.212/msp430-gcc-support-files/include \
                -L//<BASE-PROJECT-PATH>/TI-MSP430-HAL/toolchain/MSP430/GCC_source_files/msp430-gcc-support-files-1.212/msp430-gcc-support-files/include \
                //<BASE-PROJECT-PATH>/TI-MSP430-HAL/app/Src/blink.c \
                -o  //<BASE-PROJECT-PATH>/TI-MSP430-HAL/app/Src/blink.elf

                ```

        7. Git Considerations for Toolchain
            Since the MSP430 GCC toolchain is included in this repository, we want to prevent accidental commits of binaries and plugin files which can break the setup.

            Run the following command to mark all files in the GCC toolchain as "assume-unchanged":

            ```
            git ls-files toolchain/MSP430/GCC_source_files/msp430-gcc-9.3.1.11_linux64 | xargs git update-index --assume-unchanged
            ```

            This ensures that Git will ignore changes to all toolchain files while keeping them available for compilation.

            Important: Do **not** mark source files (`.c`, `.h`) as assume-unchanged, only the binary/plugin files inside the toolchain.

## Day4  
### 24/12/2025  

1. Device detection
    - Checked connected USB devices:

    ```
    lsusb
    ```
    shoud return (for example)
    ```
    Bus 003 Device 042: ID 2047:0013 Texas Instruments MSP eZ-FET lite
    ```
2. Attempted flashing with mspdebug
    ```
    sudo mspdebug tilib "erase" "prog blink.hex"
    ```
    - Error: tilib_api: can't find libmsp430.so
    - Verified toolchain libraries were missing: /usr/lib*/libmsp430.so
3. Installed MSP430 driver manually (Linux)
    - Download the zip file for linux from the link below
    ```
    https://e2e.ti.com/cfs-file/__key/communityserver-discussions-components-files/166/ti_5F00_msp430driver_5F00_setup_5F00_1.0.1.3_2D00_linux64.zip
    ```
    and unzip in a folder.
    - Install using the command below
    ```
    sudo ./ti_msp430driver_setup_1.0.1.1.bin
    ```
    in the folder 
    ```
    /opt/ti/fetdrivers
    ```
    and run 
    ```
    sudo ldconfig
    ```
    to register libraries.
4. Install Uniflash
    - Download Uniflash for linux from the link 
    ```
    https://dr-download.ti.com/software-development/software-programming-tool/MD-QeJBJLj8gq/9.4.0/uniflash_sl.9.4.0.5534.run
    ```
    - Installed dependencies (e.g., libgconf-2-4 workaround)
    - Run UniFlash CLI to flash MSP430:
    ```
    /opt/ti/uniflash_9.4.0/dslite.sh -c /mnt/.../MSP430G2553.ccxml -f blink.hex
    ```
    - Observed XML parsing errors when pointing to the wrong path
    - Fixed by providing correct CCXML from a msp430g2553 CCS project to location
    ```
    /<BASE-PROJECT-PATH>/TI-MSP430-HAL/toolchain/MSP430G2553.ccxml
    ```
    - Successfully flashed, but LED did not start immediately.
5. Verified the toolchain if the Blink project is correctly build.  The project build on Day 4 above was okay and it turned out that the board needs a power reset.
6. Make file creation
    - Created a make file to handle, cleaning, building and flashing the code.
    Notes:
    - -r 1 is required by UniFlash CLI for reset

    ```
    # ============================
    # Project configuration
    # ============================

    PROJECT_NAME := blink
    MCU          := msp430g2553

    # Project paths
    PROJECT_ROOT := $(dir $(THIS_MAKEFILE))
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

    ```
    - Command 
    ```
    make clean
    ```
    removes the the old hex and elf files.
    - Command 
    ```
    make
    ```
    build new code.
    - Command 
    ```
    make flash
    ```
    flashes the code to the microcontroller.

    NOTE: A power reset by unplugging the usb is necessary for the code to be executed.
