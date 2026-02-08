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
#include "oled.h"
#include "bmp.h"

int main(void)
{
    board_init();
    board_init_gpio_pins();
    printf("OLED test\n");
    OLED_Init();
    OLED_ColorTurn(0);    //0正常显示，1 反色显示
    OLED_DisplayTurn(0);  //0正常显示 1 屏幕翻转显示
    board_led_write(0);
    while (1)
    {
      OLED_ShowPicture(0,0,128,64,BMP1,1);
      OLED_Refresh();
      board_delay_ms(500);
      OLED_Clear();

      OLED_ShowString(20,0,"[LuckyCAT]",16,1);
      OLED_ShowString(20,16,"2025/07/15",16,1);
      OLED_ShowString(0,32,"DesignBy",16,1);  
      OLED_ShowString(70,32,"flose",16,1);  
      OLED_ShowString(0,48,"PowerBy",16,1);  
      OLED_ShowString(63,48,"HPMicro",16,1);
      OLED_Refresh();
      board_delay_ms(500);
      OLED_Clear();

      OLED_ShowChinese(0,0,0,16,1);  //16*16 中
      OLED_ShowChinese(16,0,0,24,1); //24*24 中
      OLED_ShowChinese(24,20,0,32,1);//32*32 中
      OLED_ShowChinese(64,0,0,64,1); //64*64 中
      OLED_Refresh();
      board_delay_ms(500);

      OLED_Clear();
      OLED_ShowString(0,0,"ABC",8,1);//6*8 “ABC”
      OLED_ShowString(0,8,"ABC",12,1);//6*12 “ABC”
      OLED_ShowString(0,20,"ABC",16,1);//8*16 “ABC”
      OLED_ShowString(0,36,"ABC",24,1);//12*24 “ABC”
      OLED_Refresh();
      board_delay_ms(500);
    }
}
