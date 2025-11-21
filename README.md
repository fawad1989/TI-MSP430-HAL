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
1. Install GCC Toolchain for the TI-MSP430G2553
    1. Download the following tool chain from TI. 
        1. https://dr-download.ti.com/software-development/ide-configuration-compiler-or-debugger/MD-LlCjWuAbzH/9.3.1.2/msp430-gcc-support-files-1.212.zip
        2. https://dr-download.ti.com/software-development/ide-configuration-compiler-or-debugger/MD-LlCjWuAbzH/9.3.1.2/msp430-gcc-9.3.1.11-source-full.tar.bz2
        or Download the toolchain which is fit for the project's need but only from TI. 
    2. Unzip and move to the project_base/toolchain/MSP430 folder

## Day3
### 17/10/2025
 1. Making the toolchain work
 1. Making environemnt variables (Temporary for the current shell)
# from repo root
    export TOOLCHAIN_DIR="$PWD/toolchain/MSP430/GCC_source_files/msp430-gcc-9.3.1.11_linux64"
    export SUPPORT_DIR="$PWD/toolchain/MSP430/GCC_source_files/msp430-gcc-support-files-1.212/msp430-gcc-support-files"
    export PATH="$TOOLCHAIN_DIR/bin:$PATH"

    # quick checks
    which msp430-elf-gcc
    test -f "$SUPPORT_DIR/include/msp430.h" && echo "support headers ok" || echo "support headers NOT found"

    It should give the results as follows
    COMMAND: USER:~/ti/TI-MSP430-HAL$ export TOOLCHAIN_DIR="$PWD/toolchain/MSP430/GCC_source_files/msp430-gcc-9.3.1.11_linux64"

    COMMAND: USER:~/ti/TI-MSP430-HAL$ export SUPPORT_DIR="$PWD/toolchain/MSP430/GCC_source_files/msp430-gcc-support-files-1.212/msp430-gcc-support-files"

    COMMAND: USER:~/ti/TI-MSP430-HAL$ export PATH="$TOOLCHAIN_DIR/bin:$PATH"

    COMMAND: USER:~/ti/TI-MSP430-HAL$ which msp430-elf-gcc

    REPLY: USER-PATH/TI-MSP430-HAL/toolchain/MSP430/GCC_source_files/msp430-gcc-9.3.1.11_linux64/bin/msp430-elf-gcc

    COMMAND: USER:~/ti/TI-MSP430-HAL$ test -f "$SUPPORT_DIR/include/msp430.h" && echo "support headers ok" || echo "support headers NOT found"

    REPLY: support headers ok

2. Create a small CMake tool chain file - USING ALWAYS MSP430 GCC
 1. Create a file on the path -> toolchain/cmake/msp430_toolchain.cmake
 2. Paste the content in the file as below
    ```
    # toolchain/cmake/msp430_toolchain.cmake
    # Use this file with:
    #   cmake -DCMAKE_TOOLCHAIN_FILE=toolchain/cmake/msp430_toolchain.cmake -B build

    # Tell CMake we are cross-compiling for an embedded target
    set(CMAKE_SYSTEM_NAME Generic)
    set(CMAKE_SYSTEM_PROCESSOR msp430)

    # Path to the TI MSP430 GCC toolchain
    set(TOOLCHAIN_DIR "${CMAKE_SOURCE_DIR}/toolchain/MSP430/GCC_source_files/msp430-gcc-9.3.1.11_linux64" CACHE PATH "Path to MSP430 GCC toolchain")

    # Compiler and tools
    set(CMAKE_C_COMPILER "${TOOLCHAIN_DIR}/bin/msp430-elf-gcc")
    set(CMAKE_ASM_COMPILER "${TOOLCHAIN_DIR}/bin/msp430-elf-gcc")
    set(CMAKE_AR "${TOOLCHAIN_DIR}/bin/msp430-elf-ar")
    set(CMAKE_OBJCOPY "${TOOLCHAIN_DIR}/bin/msp430-elf-objcopy")
    set(CMAKE_OBJDUMP "${TOOLCHAIN_DIR}/bin/msp430-elf-objdump")
    set(CMAKE_RANLIB "${TOOLCHAIN_DIR}/bin/msp430-elf-ranlib")

    # MSP430 support headers (from the TI support package)
    set(MSP430_SUPPORT_DIR "${CMAKE_SOURCE_DIR}/toolchain/MSP430/GCC_source_files/msp430-gcc-support-files-1.212/msp430-gcc-support-files" CACHE PATH "Path to MSP430 support files")

    # Add the include paths for device headers
    include_directories(SYSTEM
        "${MSP430_SUPPORT_DIR}/include"
        "${TOOLCHAIN_DIR}/msp430-elf/include"
        "${TOOLCHAIN_DIR}/lib/gcc/msp430-elf/9.3.1/include"
    )

    # Add the toolchain bin folder to PATH (for subprocesses)
    set(ENV{PATH} "${TOOLCHAIN_DIR}/bin:$ENV{PATH}")

    # Optional: suppress system checks that don't apply to embedded targets
    set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)
    ```