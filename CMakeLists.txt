cmake_minimum_required(VERSION 3.16)

# Project name
project(TI_MSP430_HAL C)

# Target MCU (change if needed)
set(MCU msp430g2553)

# Tell CMake to use our custom toolchain
set(CMAKE_TOOLCHAIN_FILE "${CMAKE_SOURCE_DIR}/toolchain/cmake/msp430_toolchain.cmake")

# Source files (your blink example)
add_executable(blink.elf
    app/Src/blink.c
)

# Compiler options
target_compile_options(blink.elf PRIVATE 
    -mmcu=${MCU}
    -Os
    -ffunction-sections
    -fdata-sections
    -Wall
)

# Linker options
target_link_options(blink.elf PRIVATE
    -mmcu=${MCU}
    -Wl,-gc-sections
)

# Optional: generate a HEX file
find_program(MSP430_OBJCOPY NAMES msp430-elf-objcopy)
if(MSP430_OBJCOPY)
  add_custom_command(
    OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/blink.hex
    COMMAND ${MSP430_OBJCOPY} -O ihex $<TARGET_FILE:blink.elf> ${CMAKE_CURRENT_BINARY_DIR}/blink.hex
    DEPENDS blink.elf
    COMMENT "Generating blink.hex"
  )
  add_custom_target(hex ALL DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/blink.hex)
endif()
