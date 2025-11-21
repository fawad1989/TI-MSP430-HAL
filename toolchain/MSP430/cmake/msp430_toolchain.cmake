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
