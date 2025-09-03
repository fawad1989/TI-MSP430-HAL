# TI-MSP430-HAL
A layered embedded software stack: starting with raw register descriptions, building reusable drivers on top, and exposing a clean hardware abstraction layer (HAL) for application development.

## DAY#1 (03/09/2025)
Following commands were executed and the project folder structure was made.
### directories
```
mkdir -p cmake linker startup \
         include/{ll,drivers,hal,util} \
         drivers hal src scripts docs
```
### minimal placeholders 
```
touch CMakeLists.txt              
touch Makefile                    
touch cmake/toolchain-msp430-gcc.cmake
touch linker/README.md            
touch startup/README.md           
touch include/ll/gpio_ll.h
touch include/drivers/gpio.h
touch include/hal/board.h
touch include/util/compiler.h
touch drivers/gpio_ll.c
touch drivers/gpio.c
touch hal/board_init.c
touch src/main.c
touch scripts/flash.sh
touch docs/Doxyfile
```