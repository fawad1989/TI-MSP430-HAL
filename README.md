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
### 20/09/2025
1. Install GCC Toolchain for the TImSP430G2553
    1. Download the following tool chain from TI. https://dr-download.ti.com/software-development/ide-configuration-compiler-or-debugger/MD-LlCjWuAbzH/9.3.1.2/msp430-gcc-9.3.1.11_linux64.tar.bz2 or Download the toolchain which is GCC 64bit Linux Toolchain only from TI.
    2. Move to the download folder- For this project the zip file for the tool chain is included on the path 
    
        ```TI-MSP430-HAL/toolchain/gcc_64bit_linux"```.

    3. Unpack the tool chain using the command as below

        ``` tar xvf msp430-gcc-9.3.1.11_linux64.tar.bz2 ```

    4. Change directory to 

        ``` cd msp430-gcc-9.3.1.11_linux64/bin ```

        This directory contains many files but most importantly a compiler.
2. Compile Blink from Command line
3. Write a MakeFile
4. Build an dFlash with the Make

