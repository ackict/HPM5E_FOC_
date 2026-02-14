/*
    Copyright 2021 codenocold codenocold@qq.com
    Address : https://github.com/codenocold/dgm
    This file is part of the dgm firmware.
    The dgm firmware is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.
    The dgm firmware is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#include "pwm_curr.h"
#include "board.h"
#include "hpm_pwmv2_drv.h"

uint16_t adc_vbus[1];
int32_t  phase_a_adc_offset = 0;
int32_t  phase_b_adc_offset = 0;
int32_t  phase_c_adc_offset = 0;

void PWMC_init(void)
{
    /* Set all duty to 50% */
    uint16_t duty_a = (uint16_t)(PWM_PERIOD_CYCLES>>1);
    uint16_t duty_b = (uint16_t)(PWM_PERIOD_CYCLES>>1);
    uint16_t duty_c = (uint16_t)(PWM_PERIOD_CYCLES>>1);

    pwmv2_shadow_register_unlock(BOARD_APP_PWM);
    pwmv2_set_shadow_val(BOARD_APP_PWM, PWMV2_SHADOW_INDEX(1), (PWM_PERIOD_CYCLES - duty_a) >> 1, 0, false);
    pwmv2_set_shadow_val(BOARD_APP_PWM, PWMV2_SHADOW_INDEX(2), (PWM_PERIOD_CYCLES + duty_a) >> 1, 0, false);
    pwmv2_set_shadow_val(BOARD_APP_PWM, PWMV2_SHADOW_INDEX(3), (PWM_PERIOD_CYCLES - duty_b) >> 1, 0, false);
    pwmv2_set_shadow_val(BOARD_APP_PWM, PWMV2_SHADOW_INDEX(4), (PWM_PERIOD_CYCLES + duty_b) >> 1, 0, false);
    pwmv2_set_shadow_val(BOARD_APP_PWM, PWMV2_SHADOW_INDEX(5), (PWM_PERIOD_CYCLES - duty_c) >> 1, 0, false);
    pwmv2_set_shadow_val(BOARD_APP_PWM, PWMV2_SHADOW_INDEX(6), (PWM_PERIOD_CYCLES + duty_c) >> 1, 0, false);
    pwmv2_shadow_register_lock(BOARD_APP_PWM);
    pwmv2_channel_enable_output(BOARD_APP_PWM, BOARD_APP_PWM_OUT1);
    pwmv2_channel_enable_output(BOARD_APP_PWM, BOARD_APP_PWM_OUT2);
    pwmv2_channel_enable_output(BOARD_APP_PWM, BOARD_APP_PWM_OUT3);
    pwmv2_channel_enable_output(BOARD_APP_PWM, BOARD_APP_PWM_OUT4);
    pwmv2_channel_enable_output(BOARD_APP_PWM, BOARD_APP_PWM_OUT5);
    pwmv2_channel_enable_output(BOARD_APP_PWM, BOARD_APP_PWM_OUT6);
}

void PWMC_SwitchOnPWM(void)
{
    /* Set all duty to 50% */
    uint16_t duty_a = (uint16_t)(PWM_PERIOD_CYCLES>>1);
    uint16_t duty_b = (uint16_t)(PWM_PERIOD_CYCLES>>1);
    uint16_t duty_c = (uint16_t)(PWM_PERIOD_CYCLES>>1);

    pwmv2_shadow_register_unlock(BOARD_APP_PWM);
    pwmv2_set_shadow_val(BOARD_APP_PWM, PWMV2_SHADOW_INDEX(1), (PWM_PERIOD_CYCLES - duty_a) >> 1, 0, false);
    pwmv2_set_shadow_val(BOARD_APP_PWM, PWMV2_SHADOW_INDEX(2), (PWM_PERIOD_CYCLES + duty_a) >> 1, 0, false);
    pwmv2_set_shadow_val(BOARD_APP_PWM, PWMV2_SHADOW_INDEX(3), (PWM_PERIOD_CYCLES - duty_b) >> 1, 0, false);
    pwmv2_set_shadow_val(BOARD_APP_PWM, PWMV2_SHADOW_INDEX(4), (PWM_PERIOD_CYCLES + duty_b) >> 1, 0, false);
    pwmv2_set_shadow_val(BOARD_APP_PWM, PWMV2_SHADOW_INDEX(5), (PWM_PERIOD_CYCLES - duty_c) >> 1, 0, false);
    pwmv2_set_shadow_val(BOARD_APP_PWM, PWMV2_SHADOW_INDEX(6), (PWM_PERIOD_CYCLES + duty_c) >> 1, 0, false);
    pwmv2_shadow_register_lock(BOARD_APP_PWM);
    pwmv2_channel_enable_output(BOARD_APP_PWM, BOARD_APP_PWM_OUT1);
    pwmv2_channel_enable_output(BOARD_APP_PWM, BOARD_APP_PWM_OUT2);
    pwmv2_channel_enable_output(BOARD_APP_PWM, BOARD_APP_PWM_OUT3);
    pwmv2_channel_enable_output(BOARD_APP_PWM, BOARD_APP_PWM_OUT4);
    pwmv2_channel_enable_output(BOARD_APP_PWM, BOARD_APP_PWM_OUT5);
    pwmv2_channel_enable_output(BOARD_APP_PWM, BOARD_APP_PWM_OUT6);
}

void PWMC_SwitchOffPWM(void)
{

    pwmv2_channel_disable_output(BOARD_APP_PWM, BOARD_APP_PWM_OUT1);
    pwmv2_channel_disable_output(BOARD_APP_PWM, BOARD_APP_PWM_OUT2);
    pwmv2_channel_disable_output(BOARD_APP_PWM, BOARD_APP_PWM_OUT3);
    pwmv2_channel_disable_output(BOARD_APP_PWM, BOARD_APP_PWM_OUT4);
    pwmv2_channel_disable_output(BOARD_APP_PWM, BOARD_APP_PWM_OUT5);
    pwmv2_channel_disable_output(BOARD_APP_PWM, BOARD_APP_PWM_OUT6);
}

void PWMC_TurnOnLowSides(void)
{
    ///* Set all duty to 0% */
    uint16_t duty_a = 0;
    uint16_t duty_b = 0;
    uint16_t duty_c = 0;

    pwmv2_shadow_register_unlock(BOARD_APP_PWM);
    pwmv2_set_shadow_val(BOARD_APP_PWM, PWMV2_SHADOW_INDEX(1), (PWM_PERIOD_CYCLES - duty_a) >> 1, 0, false);
    pwmv2_set_shadow_val(BOARD_APP_PWM, PWMV2_SHADOW_INDEX(2), (PWM_PERIOD_CYCLES + duty_a) >> 1, 0, false);
    pwmv2_set_shadow_val(BOARD_APP_PWM, PWMV2_SHADOW_INDEX(3), (PWM_PERIOD_CYCLES - duty_b) >> 1, 0, false);
    pwmv2_set_shadow_val(BOARD_APP_PWM, PWMV2_SHADOW_INDEX(4), (PWM_PERIOD_CYCLES + duty_b) >> 1, 0, false);
    pwmv2_set_shadow_val(BOARD_APP_PWM, PWMV2_SHADOW_INDEX(5), (PWM_PERIOD_CYCLES - duty_c) >> 1, 0, false);
    pwmv2_set_shadow_val(BOARD_APP_PWM, PWMV2_SHADOW_INDEX(6), (PWM_PERIOD_CYCLES + duty_c) >> 1, 0, false);
    pwmv2_shadow_register_lock(BOARD_APP_PWM);
    pwmv2_channel_enable_output(BOARD_APP_PWM, BOARD_APP_PWM_OUT1);
    pwmv2_channel_enable_output(BOARD_APP_PWM, BOARD_APP_PWM_OUT2);
    pwmv2_channel_enable_output(BOARD_APP_PWM, BOARD_APP_PWM_OUT3);
    pwmv2_channel_enable_output(BOARD_APP_PWM, BOARD_APP_PWM_OUT4);
    pwmv2_channel_enable_output(BOARD_APP_PWM, BOARD_APP_PWM_OUT5);
    pwmv2_channel_enable_output(BOARD_APP_PWM, BOARD_APP_PWM_OUT6);
}

int PWMC_CurrentReadingPolarization(void)
{
    int i         = 0;
    int adc_sum_a = 0;
    int adc_sum_b = 0;
    int adc_sum_c = 0;

    ///* Clear Update Flag */
    //timer_flag_clear(TIMER0, TIMER_FLAG_UP);
    ///* Wait until next update */
    //while (RESET == timer_flag_get(TIMER0, TIMER_FLAG_UP)) {
    //};
    ///* Clear Update Flag */
    //timer_flag_clear(TIMER0, TIMER_FLAG_UP);

    //while (i < 64) {
    //    if (timer_flag_get(TIMER0, TIMER_FLAG_UP) == SET) {
    //        timer_flag_clear(TIMER0, TIMER_FLAG_UP);

    //        i++;
    //        adc_sum_a += READ_IPHASE_A_ADC();
    //        adc_sum_b += READ_IPHASE_B_ADC();
    //        adc_sum_c += READ_IPHASE_C_ADC();
    //    }
    //}

    //phase_a_adc_offset = adc_sum_a / i;
    //phase_b_adc_offset = adc_sum_b / i;
    //phase_c_adc_offset = adc_sum_c / i;

    //// offset check
    //i                         = 0;
    //const int Vout            = 2122;
    //const int check_threshold = 200;
    //if (phase_a_adc_offset > (Vout + check_threshold) || phase_a_adc_offset < (Vout - check_threshold)) {
    //    i = -1;
    //}
    //if (phase_b_adc_offset > (Vout + check_threshold) || phase_b_adc_offset < (Vout - check_threshold)) {
    //    i = -1;
    //}
    //if (phase_c_adc_offset > (Vout + check_threshold) || phase_c_adc_offset < (Vout - check_threshold)) {
    //    i = -1;
    //}

    return i;
}
