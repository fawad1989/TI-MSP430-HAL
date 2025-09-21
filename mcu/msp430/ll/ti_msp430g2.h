/**
  ******************************************************************************
  * @file    msp430g2xx.h
  * @author  fawad1989 - https://github.com/fawad1989
  * @brief   CMSIS-style device header for Texas Instruments MSP430G2xx series.
  *
  * @attention
  *
  * This file provides:
  *   - Base addresses for all peripheral registers
  *   - Peripheral register structures (GPIO, Timer_A, USCI, etc.)
  *   - Type definitions and macros for low-level access
  *
  * @device   MSP430G2553 (representative G2xx device)
  * @origin   Derived from:
  *             - MSP430G2553 datasheet (SLAS735)
  *             - MSP430x2xx Family User Guide (SLAU144)
  * @date     2025-09-14
  * @version  v0.1
  *
  * @note
  *   This header is designed to mimic the style of STM32 CMSIS device headers
  *   (e.g. stm32wb55xx.h), to keep a consistent coding style across different
  *   MCUs (TI MSP430, STM32, Raspberry Pi RP2350).
  *
  ******************************************************************************
  */

/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef __MSP430G2XX_H
#define __MSP430G2XX_H

#ifdef __cplusplus
extern "C" {
#endif

/* Includes ------------------------------------------------------------------*/


/* IO qualifiers -------------------------------------------------------------*/
#define __I  volatile const    /*!< Defines 'read only' permissions   */
#define __O  volatile          /*!< Defines 'write only' permissions  */
#define __IO volatile          /*!< Defines 'read / write' permissions*/

/* ========================================================================== */
/* ===================== Base addresses for Memory Map ====================== */
/* ========================================================================== */

/**
  * @}
  */

/** @addtogroup Memory_map
  * @{
  */
/*!<Main memory map*/
#define BASE_ADDRESS                (0x00000UL) /*Memory Base Address*/
#define SPECIAL_FUNCTION_REGISTER   (BASE_ADDRESS) /*Special Function Register Base Address*/
#define 8_BIT_PERIPHERAL_MODULE     (SPECIAL_FUNCTION_REGISTER + 0x0000FUL) /*Special Function Register Base Address*/

#ifdef __cplusplus
}
#endif /* __cplusplus */