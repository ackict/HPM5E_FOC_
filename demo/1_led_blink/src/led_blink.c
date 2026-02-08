/*
*********************************************************************************************************
*
*	模块名称 : LED闪烁例程
*	文件名称 : led_blink.c
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
#include "hpm_debug_console.h"

int main(void)
{
    board_init();
    board_init_led_pins();
    printf("led_blink test\n");
    while (1) {
      board_led_write(BOARD_LED_ON_LEVEL);
      printf("Board LED ON!\n");
      board_delay_ms(500);
      board_led_write(BOARD_LED_OFF_LEVEL);
      printf("Board LED OFF!\n");
      board_delay_ms(500);
    }
}

