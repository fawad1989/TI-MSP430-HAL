cmake_minimum_required(VERSION 3.16)
project(TI_MSP430_HAL C)

# Target device
set(MCU "msp430g2553" CACHE STRING "Target MSP430 MCU")

# Your app sources
add_executable(main.elf
  app/Src/main.c
)
include_directories(
  ${CMAKE_SOURCE_DIR}/toolchain/msp430-gcc-support-files/include/msp430.h
)

# Compile & link flags
target_compile_options(main.elf PRIVATE
  -mmcu=${MCU} -Os -ffunction-sections -fdata-sections -fno-builtin -std=c11
)
target_link_options(main.elf PRIVATE
  -Wl,-gc-sections -mmcu=${MCU}
)

# Create a HEX (optional)
find_program(MSP430_OBJCOPY NAMES msp430-elf-objcopy)
if(MSP430_OBJCOPY)
  add_custom_command(
    OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/main.hex
    COMMAND ${MSP430_OBJCOPY} -O ihex $<TARGET_FILE:main.elf> ${CMAKE_CURRENT_BINARY_DIR}/main.hex
    DEPENDS main.elf
    COMMENT "Generating main.hex"
  )
  add_custom_target(hex ALL DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/main.hex)
endif()

# Flash target (uses mspdebug; LaunchPad G2553 usually = 'rf2500')
set(MSPDEBUG_DRIVER "rf2500" CACHE STRING "mspdebug driver (rf2500 or tilib)")
add_custom_target(flash
  COMMAND mspdebug ${MSPDEBUG_DRIVER} "prog $<TARGET_FILE:main.elf>"
  DEPENDS main.elf
  USES_TERMINAL
  COMMENT "Flashing with mspdebug (${MSPDEBUG_DRIVER})"
)
