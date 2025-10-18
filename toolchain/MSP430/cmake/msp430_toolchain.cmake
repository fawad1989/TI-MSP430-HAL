# toolchain/cmake/msp430_toolchain.cmake
# Use with: cmake -DCMAKE_TOOLCHAIN_FILE=toolchain/cmake/msp430_toolchain.cmake ...

# Path to the TI GCC bundle (adjust if you move it)
set(TOOLCHAIN_DIR "${CMAKE_SOURCE_DIR}/toolchain/MSP430/GCC_source_files/msp430-gcc-9.3.1.11_linux64" CACHE PATH "MSP430 toolchain dir")

# compiler
set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_C_COMPILER "${TOOLCHAIN_DIR}/bin/msp430-elf-gcc")
set(CMAKE_AR         "${TOOLCHAIN_DIR}/bin/msp430-elf-ar")
set(CMAKE_OBJCOPY    "${TOOLCHAIN_DIR}/bin/msp430-elf-objcopy")
set(CMAKE_OBJDUMP    "${TOOLCHAIN_DIR}/bin/msp430-elf-objdump")
set(CMAKE_RANLIB     "${TOOLCHAIN_DIR}/bin/msp430-elf-ranlib")

# Ensure the compiler can find the support headers at configure time
set(MSP430_SUPPORT_DIR "${CMAKE_SOURCE_DIR}/toolchain/MSP430/GCC_source_files/msp430-gcc-support-files-1.212/msp430-gcc-support-files" CACHE PATH "MSP430 support files")

# Put support headers in the system include search path (used by your CMakeLists)
include_directories(SYSTEM "${MSP430_SUPPORT_DIR}/include")
include_directories(SYSTEM "${TOOLCHAIN_DIR}/msp430-elf/include" "${TOOLCHAIN_DIR}/lib/gcc/msp430-elf/9.3.1/include")

# Make sure cmake uses the right tools by prefixing PATH during configure/build
set(ENV{PATH} "${TOOLCHAIN_DIR}/bin:$ENV{PATH}")
