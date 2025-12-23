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
        1. https://dr-download.ti.com/software-development/ide-configuration-compiler-or-debugger/MD-LlCjWuAbzH/9.3.1.2/msp430-gcc-9.3.1.11_linux64.tar.bz2 --> Mitto Systems GCC 64-bit Linux - toolchain only
        2. https://dr-download.ti.com/software-development/ide-configuration-compiler-or-debugger/MD-LlCjWuAbzH/9.3.1.2/msp430-gcc-support-files-1.212.zip --> Header and Support Files
        or Download the toolchain which is fit for the project's need but only from TI. 
    2. Unzip and move to the 
    ```
    <BASE-PROJECT-PATH>/TI-MSP430-HAL/toolchain/MSP430 folder
    ```

## Day3
### 17/10/2025
 1. Making the toolchain work
    - Manual Compilation
        1. check version by the following command 
        ```
        <BASE-PROJECT-PATH>/TI-MSP430-HAL/toolchain/MS/GCC_source_files/msp430-gcc-9.3.1.11_linux64/bin/msp430-elf-gcc --version ---> msp430-elf-gcc (Mitto Systems Limited - msp430-gcc 9.3.1.11)

        ```
        2. Make the compiler available in the shell
        ```
        export PATH="$(<BASE-PROJECT-PATH>)/toolchain/MS/GCC_source_files/msp430-gcc-9.3.1.11_linux64/bin:$PATH"
        ```
        3. Verify 
        ```
        msp430-elf-gcc --version --> 
        
        msp430-elf-gcc (Mitto Systems Limited - msp430-gcc 9.3.1.11) 9.3.1
        Copyright (C) 2019 Free Software Foundation, Inc.
        This is free software; see the source for copying conditions.  There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
        ```
        4. Attempting a failed compilation 
            1. Go to the folder app/Src/blink.c
        ```
        msp430-elf-gcc -mmcu=msp430g2553 blink.c -o blinky.elf -->

        ```
        Returns 
        ``` 
        blink.c:1:10: fatal error: msp430.h: No such file or directory
        1 | #include <msp430.h>
          |          ^~~~~~~~~~
        compilation terminated.
        ```
        5. Locate required header
            1. Find the msp430.h header file in the tool chain. Move to the 
            ```
            find <BASE-PROJECT-PATH>/TI-MSP430-HAL/toolchain/MSP430/GCC_source_files -name msp430.h
            ```
            Returns a bunch of places but needed header file is in 
            ```
            <BASE-PROJECT-PATH>/TI-MSP430-HAL/toolchain/MSP430/GCC_source_files/msp430-gcc-support-files-1.212/msp430-gcc-support-files/include/msp430.h
            ```

        6. Compile the code
        Use the following code to compile the main.c (its blink.c in this case)
        ```
        msp430-elf-gcc \
        -mmcu=msp430g2553 \
        -I/<BASE-PROJECT-PATH>/TI-MSP430-HAL/toolchain/MSP430/GCC_source_files/msp430-gcc-support-files-1.212/msp430-gcc-support-files/include \
        -L/<BASE-PROJECT-PATH>/TI-MSP430-HAL/toolchain/MSP430/GCC_source_files/msp430-gcc-support-files-1.212/msp430-gcc-support-files/include \
        /<BASE-PROJECT-PATH>/TI-MSP430-HAL/app/Src/blink.c \
        -o  /<BASE-PROJECT-PATH>/TI-MSP430-HAL/app/Src/blink.elf

        ```