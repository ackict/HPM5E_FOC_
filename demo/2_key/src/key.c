/*
*********************************************************************************************************
*
*	模块名称 : 按钮控制LED例程(轮询方式)
*	文件名称 : key.c
*	版    本 : V1.0
*	说    明 : 
*	修改记录 :
*		版本号  日期         作者       说明
*		V1.0    2025-07-15  astronG   正式发布
*
*	Copyright (C), 2018-2030, astronG
*
*********************************************************************************************************
*/

#include <stdio.h>
#include "board.h"
#include "hpm_gpio_drv.h"
#include "hpm_debug_console.h"

uint8_t i = 0;

int main(void)
{
    board_init();
    board_init_gpio_pins();
    printf("key test\n");
    while (1)
    {
      if (gpio_read_pin(BOARD_KEYA_GPIO_CTRL, BOARD_KEYA_GPIO_INDEX, BOARD_KEYA_GPIO_PIN) == BOARD_BUTTON_PRESSED_VALUE)
      {
        board_led_write(BOARD_LED_ON_LEVEL);
        printf("Board LED ON!\n");
      }

      if (gpio_read_pin(BOARD_KEYB_GPIO_CTRL, BOARD_KEYB_GPIO_INDEX, BOARD_KEYB_GPIO_PIN) == BOARD_BUTTON_PRESSED_VALUE)
      {
        board_led_write(BOARD_LED_OFF_LEVEL);
        printf("Board LED OFF!\n");
      }
    }
}
