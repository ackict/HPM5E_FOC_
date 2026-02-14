/*
 * Copyright (c) 2024 HPMicro
 *
 * SPDX-License-Identifier: BSD-3-Clause
 *
 */

#include "board.h"
#include <stdio.h>
#include "hpm_debug_console.h"
#include "hpm_pwmv2_drv.h"
#include "hpm_adc16_drv.h"
#include "hpm_gpio_drv.h"
#include "hpm_trgm_drv.h"
#include "hpm_clock_drv.h"
#include "hpm_synt_drv.h"
#include <math.h>
#include "spi.h"
#include "usb_config.h"
#include "vofa.h"
#include "util.h"
#include "foc.h"
#include "mc_task.h"
#include "pwm_curr.h"
#include "usr_config.h"
#include "controller.h"
#include "encoder.h"

#ifndef APP_ADC16_CORE
#define APP_ADC16_CORE BOARD_RUNNING_CORE
#endif

#define APP_ADC16_CLOCK_BUS  BOARD_APP_ADC16_CLK_BUS

#define APP_ADC16_CH_SAMPLE_CYCLE            (20U)
#define APP_ADC16_CH_WDOG_EVENT              (1 << BOARD_APP_ADC16_CH_1)

#define APP_ADC16_SEQ_START_POS              (0U)
#define APP_ADC16_SEQ_DMA_BUFF_LEN_IN_4BYTES (1024U)
#define APP_ADC16_SEQ_IRQ_EVENT              adc16_event_seq_single_complete

#ifndef ADC_SOC_NO_HW_TRIG_SRC
#define APP_ADC16_HW_TRIG_SRC_PWM_REFCH_A    (8U)
#define APP_ADC16_HW_TRIG_SRC                BOARD_APP_ADC16_HW_TRIG_SRC
#define APP_ADC16_HW_TRGM                    BOARD_APP_ADC16_HW_TRGM
#define APP_ADC16_HW_TRGM_IN                 BOARD_APP_ADC16_HW_TRGM_IN
#define APP_ADC16_HW_TRGM_OUT_SEQ            BOARD_APP_ADC16_HW_TRGM_OUT_SEQ
#define APP_ADC16_HW_TRGM_OUT_PMT            BOARD_APP_ADC16_HW_TRGM_OUT_PMT
#if defined(HPMSOC_HAS_HPMSDK_PWMV2)
#define APP_ADC16_HW_TRGM_SRC_OUT_CH         (0U)
#endif
#endif

#define APP_ADC16_PMT_TRIG_CH                BOARD_APP_ADC16_PMT_TRIG_CH
#define APP_ADC16_PMT_DMA_BUFF_LEN_IN_4BYTES ADC_SOC_PMT_MAX_DMA_BUFF_LEN_IN_4BYTES
#define APP_ADC16_PMT_IRQ_EVENT              adc16_event_trig_complete

#ifndef APP_ADC16_TRIG_SRC_FREQUENCY
#define APP_ADC16_TRIG_SRC_FREQUENCY         (20000U)
#endif

ATTR_PLACE_AT_NONCACHEABLE_WITH_ALIGNMENT(ADC_SOC_DMA_ADDR_ALIGNMENT) uint32_t seq_buff[APP_ADC16_SEQ_DMA_BUFF_LEN_IN_4BYTES];
ATTR_PLACE_AT_NONCACHEABLE_WITH_ALIGNMENT(ADC_SOC_DMA_ADDR_ALIGNMENT) uint32_t pmt_buff[APP_ADC16_PMT_DMA_BUFF_LEN_IN_4BYTES];


#ifndef PWM
#define PWM BOARD_APP_PWM
#define PWM_CLOCK_NAME BOARD_APP_PWM_CLOCK_NAME
#define PWM_OUTPUT_PIN1 BOARD_APP_PWM_OUT1
#define PWM_OUTPUT_PIN2 BOARD_APP_PWM_OUT2
#define PWM_OUTPUT_PIN3 BOARD_APP_PWM_OUT3
#define PWM_OUTPUT_PIN4 BOARD_APP_PWM_OUT4
#define PWM_OUTPUT_PIN5 BOARD_APP_PWM_OUT5
#define PWM_OUTPUT_PIN6 BOARD_APP_PWM_OUT6
#define TRGM BOARD_APP_TRGM
#endif

#define PWM_PERIOD_IN_MS (36)

uint32_t reload, freq;
uint8_t reload_flag = 0;
float phase = 0.0f;
float phase_enc = 0.0f;
float dtc_a,dtc_b,dtc_c;
float g_alpha,g_beta;
uint32_t mt6816_count = 0;
uint8_t trig_adc_channel[] = {0u,10u,13u};
uint8_t current_cycle_bit;
__IO uint8_t trig_complete_flag;

void pwm_fault_async(void)
{
    pwmv2_async_fault_source_config_t fault_cfg;

    fault_cfg.async_signal_from_pad_index = BOARD_APP_PWM_FAULT_PIN;
    fault_cfg.fault_async_pad_level = pad_fault_active_high;
    pwmv2_config_async_fault_source(PWM, PWM_OUTPUT_PIN1, &fault_cfg);
    pwmv2_config_async_fault_source(PWM, PWM_OUTPUT_PIN2, &fault_cfg);
    pwmv2_config_async_fault_source(PWM, PWM_OUTPUT_PIN3, &fault_cfg);
    pwmv2_set_fault_mode(PWM, PWM_OUTPUT_PIN1, pwm_fault_output_0);
    pwmv2_set_fault_mode(PWM, PWM_OUTPUT_PIN2, pwm_fault_output_0);
    pwmv2_set_fault_mode(PWM, PWM_OUTPUT_PIN3, pwm_fault_output_0);
    pwmv2_enable_async_fault(PWM, PWM_OUTPUT_PIN1);
    pwmv2_enable_async_fault(PWM, PWM_OUTPUT_PIN2);
    pwmv2_enable_async_fault(PWM, PWM_OUTPUT_PIN3);
}

static void init_synt_timebase(void)
{
    synt_reset_counter(HPM_SYNT);
    synt_set_reload(HPM_SYNT, reload);
    synt_set_comparator(HPM_SYNT, SYNT_CMP_0, (reload >> 3));
    synt_set_comparator(HPM_SYNT, SYNT_CMP_1, (reload >> 2));
    synt_set_comparator(HPM_SYNT, SYNT_CMP_2, (reload >> 1));
}

static void sync_start(void)
{
    synt_enable_counter(HPM_SYNT, true);
}

static void sync_stop(void)
{
    synt_enable_counter(HPM_SYNT, false);
    synt_reset_counter(HPM_SYNT);
}

static void init_start_trgm_connect(void)
{
    trgm_output_t trgm0_io_config0 = {0};
    trgm0_io_config0.invert = 0;
    trgm0_io_config0.type = trgm_output_pulse_at_input_rising_edge;
    trgm0_io_config0.input = HPM_TRGM0_INPUT_SRC_SYNT_CH00;
    trgm_output_config(HPM_TRGM0, BOARD_APP_TRGM_PWM_OUTPUT, &trgm0_io_config0);

    trgm_output_t trgm0_io_config1 = {0};
    trgm0_io_config1.invert = 0;
    trgm0_io_config1.type = trgm_output_pulse_at_input_rising_edge;
    trgm0_io_config1.input = HPM_TRGM0_INPUT_SRC_SYNT_CH00;
    trgm_output_config(HPM_TRGM0, BOARD_APP_TRGM_PWM_OUTPUT1, &trgm0_io_config1);

    trgm_output_t trgm0_io_config2 = {0};
    trgm0_io_config2.invert = 0;
    trgm0_io_config2.type = trgm_output_pulse_at_input_rising_edge;
    trgm0_io_config2.input = HPM_TRGM0_INPUT_SRC_SYNT_CH00;
    trgm_output_config(HPM_TRGM0, BOARD_APP_TRGM_PWM_OUTPUT2, &trgm0_io_config2);
}

static void init_phase_trgm_connect(void)
{
    trgm_output_t trgm0_io_config0 = {0};
    trgm0_io_config0.invert = 0;
    trgm0_io_config0.type = trgm_output_pulse_at_input_rising_edge;
    trgm0_io_config0.input = HPM_TRGM0_INPUT_SRC_SYNT_CH00;
    trgm_output_config(HPM_TRGM0, BOARD_APP_TRGM_PWM_OUTPUT, &trgm0_io_config0);

    trgm_output_t trgm0_io_config1 = {0};
    trgm0_io_config1.invert = 0;
    trgm0_io_config1.type = trgm_output_pulse_at_input_rising_edge;
    trgm0_io_config1.input = HPM_TRGM0_INPUT_SRC_SYNT_CH01;
    trgm_output_config(HPM_TRGM0, BOARD_APP_TRGM_PWM_OUTPUT1, &trgm0_io_config1);

    trgm_output_t trgm0_io_config2 = {0};
    trgm0_io_config2.invert = 0;
    trgm0_io_config2.type = trgm_output_pulse_at_input_rising_edge;
    trgm0_io_config2.input = HPM_TRGM0_INPUT_SRC_SYNT_CH02;
    trgm_output_config(HPM_TRGM0, BOARD_APP_TRGM_PWM_OUTPUT2, &trgm0_io_config2);
}

static void pwm_sync_three_submodules_handware_config(void)
{

    pwmv2_enable_shadow_lock_feature(PWM);
    pwmv2_shadow_register_unlock(PWM);
    pwmv2_set_shadow_val(PWM, PWMV2_SHADOW_INDEX(0), reload, 0, 0);
    pwmv2_set_shadow_val(PWM, PWMV2_SHADOW_INDEX(1), reload + 1, 0, 0);
    pwmv2_set_shadow_val(PWM, PWMV2_SHADOW_INDEX(2), reload, 0, 0);
    pwmv2_set_shadow_val(PWM, PWMV2_SHADOW_INDEX(3), reload + 1, 0, 0);
    pwmv2_set_shadow_val(PWM, PWMV2_SHADOW_INDEX(4), reload, 0, 0);
    pwmv2_set_shadow_val(PWM, PWMV2_SHADOW_INDEX(5), reload + 1, 0, 0);
    pwmv2_set_shadow_val(PWM, PWMV2_SHADOW_INDEX(6), reload, 0, 0);

    pwmv2_counter_select_data_offset_from_shadow_value(PWM, pwm_counter_0, PWMV2_SHADOW_INDEX(0));
    pwmv2_counter_select_data_offset_from_shadow_value(PWM, pwm_counter_1, PWMV2_SHADOW_INDEX(0));
    pwmv2_counter_select_data_offset_from_shadow_value(PWM, pwm_counter_2, PWMV2_SHADOW_INDEX(0));

    //UH
    pwmv2_select_cmp_source(PWM, PWMV2_CMP_INDEX(0), cmp_value_from_shadow_val, PWMV2_SHADOW_INDEX(1));
    pwmv2_select_cmp_source(PWM, PWMV2_CMP_INDEX(1), cmp_value_from_shadow_val, PWMV2_SHADOW_INDEX(2));
    //UL
    pwmv2_select_cmp_source(PWM, PWMV2_CMP_INDEX(6), cmp_value_from_shadow_val, PWMV2_SHADOW_INDEX(1));
    pwmv2_select_cmp_source(PWM, PWMV2_CMP_INDEX(7), cmp_value_from_shadow_val, PWMV2_SHADOW_INDEX(2));
    //VH
    pwmv2_select_cmp_source(PWM, PWMV2_CMP_INDEX(2), cmp_value_from_shadow_val, PWMV2_SHADOW_INDEX(3));
    pwmv2_select_cmp_source(PWM, PWMV2_CMP_INDEX(3), cmp_value_from_shadow_val, PWMV2_SHADOW_INDEX(4));
    //VL
    pwmv2_select_cmp_source(PWM, PWMV2_CMP_INDEX(8), cmp_value_from_shadow_val, PWMV2_SHADOW_INDEX(3));
    pwmv2_select_cmp_source(PWM, PWMV2_CMP_INDEX(9), cmp_value_from_shadow_val, PWMV2_SHADOW_INDEX(4));
    //WH
    pwmv2_select_cmp_source(PWM, PWMV2_CMP_INDEX(4), cmp_value_from_shadow_val, PWMV2_SHADOW_INDEX(5));
    pwmv2_select_cmp_source(PWM, PWMV2_CMP_INDEX(5), cmp_value_from_shadow_val, PWMV2_SHADOW_INDEX(6));
    //WL
    pwmv2_select_cmp_source(PWM, PWMV2_CMP_INDEX(10), cmp_value_from_shadow_val, PWMV2_SHADOW_INDEX(5));
    pwmv2_select_cmp_source(PWM, PWMV2_CMP_INDEX(11), cmp_value_from_shadow_val, PWMV2_SHADOW_INDEX(6));

    pwmv2_reload_select_input_trigger(PWM, pwm_counter_0, 0);
    pwmv2_reload_select_input_trigger(PWM, pwm_counter_1, 1);
    pwmv2_reload_select_input_trigger(PWM, pwm_counter_2, 2);

    pwmv2_set_reload_update_time(PWM, pwm_counter_0, pwm_reload_update_on_trigger);
    pwmv2_set_reload_update_time(PWM, pwm_counter_1, pwm_reload_update_on_trigger);
    pwmv2_set_reload_update_time(PWM, pwm_counter_2, pwm_reload_update_on_trigger);

    pwmv2_counter_burst_disable(PWM, pwm_counter_0);
    pwmv2_counter_burst_disable(PWM, pwm_counter_1);
    pwmv2_counter_burst_disable(PWM, pwm_counter_2);

    pwmv2_set_shadow_val(PWM, PWMV2_SHADOW_INDEX(7), reload - 5, 0, false);
    pwmv2_select_cmp_source(PWM, 16, cmp_value_from_shadow_val, PWMV2_SHADOW_INDEX(7));
    pwmv2_set_trigout_cmp_index(PWM, APP_ADC16_HW_TRGM_SRC_OUT_CH, 16);

    pwmv2_shadow_register_lock(PWM);

    pwmv2_disable_four_cmp(PWM, PWM_OUTPUT_PIN1);
    pwmv2_disable_four_cmp(PWM, PWM_OUTPUT_PIN2);
    pwmv2_disable_four_cmp(PWM, PWM_OUTPUT_PIN3);
    pwmv2_disable_four_cmp(PWM, PWM_OUTPUT_PIN4);
    pwmv2_disable_four_cmp(PWM, PWM_OUTPUT_PIN5);
    pwmv2_disable_four_cmp(PWM, PWM_OUTPUT_PIN6);

    //pwmv2_channel_enable_output(PWM, PWM_OUTPUT_PIN1);
    //pwmv2_channel_enable_output(PWM, PWM_OUTPUT_PIN2);
    //pwmv2_channel_enable_output(PWM, PWM_OUTPUT_PIN3);

    pwmv2_enable_output_invert(PWM, BOARD_APP_PWM_OUT4);
    pwmv2_enable_output_invert(PWM, BOARD_APP_PWM_OUT5);
    pwmv2_enable_output_invert(PWM, BOARD_APP_PWM_OUT6);
    //pwmv2_channel_enable_output(PWM, PWM_OUTPUT_PIN4);
    //pwmv2_channel_enable_output(PWM, PWM_OUTPUT_PIN5);
    //pwmv2_channel_enable_output(PWM, PWM_OUTPUT_PIN6);

    pwmv2_reset_counter(PWM, pwm_counter_0);
    pwmv2_reset_counter(PWM, pwm_counter_1);
    pwmv2_reset_counter(PWM, pwm_counter_2);
    pwmv2_enable_counter(PWM, pwm_counter_0);
    pwmv2_enable_counter(PWM, pwm_counter_1);
    pwmv2_enable_counter(PWM, pwm_counter_2);
    pwmv2_start_pwm_output(PWM, pwm_counter_0);
    pwmv2_start_pwm_output(PWM, pwm_counter_1);
    pwmv2_start_pwm_output(PWM, pwm_counter_2);
    //pwmv2_enable_reload_irq(PWM, pwm_counter_0);

    //intc_m_enable_irq_with_priority(BOARD_APP_PWM_IRQ, 1);

    //    pwmv2_shadow_register_unlock(PWM);
    //pwmv2_set_shadow_val(PWM, PWMV2_SHADOW_INDEX(1), (reload - 800) >> 1, 0, false);
    //pwmv2_set_shadow_val(PWM, PWMV2_SHADOW_INDEX(2), (reload + 800) >> 1, 0, false);
    //pwmv2_set_shadow_val(PWM, PWMV2_SHADOW_INDEX(3), (reload - 800) >> 1, 0, false);
    //pwmv2_set_shadow_val(PWM, PWMV2_SHADOW_INDEX(4), (reload + 800) >> 1, 0, false);
    //pwmv2_set_shadow_val(PWM, PWMV2_SHADOW_INDEX(5), (reload - 800) >> 1, 0, false);
    //pwmv2_set_shadow_val(PWM, PWMV2_SHADOW_INDEX(6), (reload + 800) >> 1, 0, false);
    //pwmv2_shadow_register_lock(PWM);
}

/* restore the initial state of pwmv2 */
void pwm_sync_clean(void)
{
/* clear the values of reload and compare working registers */
    pwmv2_shadow_register_unlock(PWM);
    pwmv2_set_shadow_val(PWM, PWMV2_SHADOW_INDEX(0), 0, 0, 0);
    pwmv2_set_shadow_val(PWM, PWMV2_SHADOW_INDEX(1), 0, 0, 0);
    pwmv2_set_shadow_val(PWM, PWMV2_SHADOW_INDEX(2), 0, 0, 0);
    pwmv2_shadow_register_lock(PWM);
    board_delay_ms(50);
    sync_stop();
    pwmv2_deinit(PWM);
}

void pwm_start_same_time(void)
{
    init_start_trgm_connect();
    pwm_sync_three_submodules_handware_config();
    board_delay_ms(2000);
    sync_start();
}

//SDK_DECLARE_EXT_ISR_M(BOARD_APP_PWM_IRQ, isr_pwm0)
//void isr_pwm0(void)
//{
// uint32_t status;

//  pwmv2_disable_reload_irq(PWM, pwm_counter_0);
// status = pwmv2_get_reload_irq_status(PWM);


//   phase+=0.01f;

//  if(phase > (M_PI * 2.0f))
//    phase = 0.0f;

//  FOC_voltage(0.5f, 0.0f, phase);
//  reload_flag = 1;

// pwmv2_enable_reload_irq(PWM, pwm_counter_0);
// pwmv2_clear_reload_irq_status(PWM, status);
//}

SDK_DECLARE_EXT_ISR_M(BOARD_APP_ADC16_IRQn, isr_adc16)
void isr_adc16(void)
{
    uint32_t status;
    /* Calc ADC offset */
    static int adc_sum_a = 0;
    static int adc_sum_b = 0;
    static int adc_sum_c = 0;
    static bool isCalcAdcOffsetOvered = true;
    const int measCnt = 64;
    static int measCntCopy = measCnt;




    status = adc16_get_status_flags(BOARD_APP_ADC16_BASE);

    /* Clear status */
    adc16_clear_status_flags(BOARD_APP_ADC16_BASE, status);

    if (ADC16_INT_STS_TRIG_CMPT_GET(status)) {
        /* Set flag to read memory data */
        trig_complete_flag = 1;
        /* Process data */
        //process_pmt_data(pmt_buff, APP_ADC16_PMT_TRIG_CH * sizeof(adc16_pmt_dma_data_t), sizeof(trig_adc_channel));
        adc16_pmt_dma_data_t *dma_data = (adc16_pmt_dma_data_t *)pmt_buff;


        if (!isCalcAdcOffsetOvered)
        {
            adc_sum_a += dma_data[0].result;
            adc_sum_b += dma_data[1].result;
            adc_sum_c += dma_data[2].result;

            if (--measCntCopy <= 0)
            {
                phase_a_adc_offset = adc_sum_a / measCnt;
                phase_b_adc_offset = adc_sum_b / measCnt;
                phase_c_adc_offset = adc_sum_c / measCnt;

                isCalcAdcOffsetOvered = true;
            }
        }


        Foc.v_bus = 12.0f;//read_vbus();
        UTILS_LP_FAST(Foc.v_bus_filt, Foc.v_bus, 0.05f);
        phase_a_adc_offset = 32901;
        phase_b_adc_offset = 32285;
        phase_c_adc_offset = 33235;

        Foc.i_a = (dma_data[0].result - phase_a_adc_offset) * I_SCALE;
        Foc.i_b = (dma_data[1].result - phase_b_adc_offset) * I_SCALE;
        Foc.i_c = (dma_data[2].result - phase_c_adc_offset) * I_SCALE;

        //phase+=0.01f;
        //if(phase > (M_PI * 2.0f))
        //  phase = 0.0f;
        //mt6816_count = 16384- mt6816_read_reg();
        //phase_enc =  (mt6816_count / 16384.0f) * M_2PI * 7.0f;
        //phase_enc -= 4.51f;
        //while(phase_enc > M_2PI)
        // phase_enc -= M_2PI;
        //while(phase_enc < 0)
        // phase_enc += M_2PI;
        MCT_high_frequency_task();

       // FOC_voltage(0.0f, 0.5f, phase_enc);
        //FOC_current(0.0f,0.5f,phase_enc,0);
        //FOC_voltage(0.5f, 0.0f, phase);
       // printf("%0.4f,%0.4f,%0.4f,%0.4f\n",g_alpha,g_beta,dtc_c,phase);
        /* Clear memory */
        //memset(pmt_buff, 0x00, sizeof(pmt_buff));

        /* Clear the flag */
        trig_complete_flag = 0;

    }

}

SDK_DECLARE_EXT_ISR_M(BOARD_KEYA_GPIO_IRQ, isr_gpio)
void isr_gpio(void)
{

    uint32_t status = gpio_get_port_interrupt_flags(BOARD_KEYA_GPIO_CTRL, BOARD_KEYA_GPIO_INDEX);


    if (status & (1u << 8)) 
     {
        gpio_clear_pin_interrupt_flag(BOARD_KEYA_GPIO_CTRL, BOARD_KEYA_GPIO_INDEX,
                        BOARD_KEYA_GPIO_PIN);
        gpio_write_pin(BOARD_LED_GPIO_CTRL, BOARD_LED_GPIO_INDEX, BOARD_LED_GPIO_PIN, 0);
        pwmv2_channel_enable_output(PWM, PWM_OUTPUT_PIN1);
        pwmv2_channel_enable_output(PWM, PWM_OUTPUT_PIN2);
        pwmv2_channel_enable_output(PWM, PWM_OUTPUT_PIN3);
        pwmv2_channel_enable_output(PWM, PWM_OUTPUT_PIN4);
        pwmv2_channel_enable_output(PWM, PWM_OUTPUT_PIN5);
        pwmv2_channel_enable_output(PWM, PWM_OUTPUT_PIN6);
    }

    if (status & (1u << 16)) 
    {
        gpio_clear_pin_interrupt_flag(BOARD_KEYB_GPIO_CTRL, BOARD_KEYB_GPIO_INDEX,
                        BOARD_KEYB_GPIO_PIN);
        gpio_write_pin(BOARD_LED_GPIO_CTRL, BOARD_LED_GPIO_INDEX, BOARD_LED_GPIO_PIN, 1);
        
        pwmv2_channel_disable_output(PWM, PWM_OUTPUT_PIN1);
        pwmv2_channel_disable_output(PWM, PWM_OUTPUT_PIN2);
        pwmv2_channel_disable_output(PWM, PWM_OUTPUT_PIN3);
        pwmv2_channel_disable_output(PWM, PWM_OUTPUT_PIN4);
        pwmv2_channel_disable_output(PWM, PWM_OUTPUT_PIN5);
        pwmv2_channel_disable_output(PWM, PWM_OUTPUT_PIN6);
    }
}

void pwm_start_different_phase(void)
{
    init_phase_trgm_connect();
    pwm_sync_three_submodules_handware_config();
    board_delay_ms(2000);
    sync_start();
}

void init_trigger_source(PWMV2_Type *ptr)
{
    int mot_clock_freq;

    mot_clock_freq =  clock_get_frequency(BOARD_APP_ADC16_HW_TRIG_SRC_CLK_NAME);

    pwmv2_shadow_register_unlock(ptr);
    //pwmv2_set_reload_update_time(ptr, pwm_counter_0, pwm_reload_update_on_reload);
    //pwmv2_set_shadow_val(ptr, PWMV2_SHADOW_INDEX(0), (mot_clock_freq/APP_ADC16_TRIG_SRC_FREQUENCY) - 1, 0, false);
    pwmv2_set_shadow_val(ptr, PWMV2_SHADOW_INDEX(7), reload-2, 0, false);
    pwmv2_select_cmp_source(ptr, 16, cmp_value_from_shadow_val, PWMV2_SHADOW_INDEX(7));
    pwmv2_shadow_register_lock(ptr);

    //pwmv2_counter_select_data_offset_from_shadow_value(ptr, pwm_counter_0, PWMV2_SHADOW_INDEX(0));
    //pwmv2_counter_burst_disable(ptr, pwm_counter_0);

    pwmv2_set_trigout_cmp_index(ptr, APP_ADC16_HW_TRGM_SRC_OUT_CH, 16);
    //pwmv2_enable_counter(ptr, pwm_counter_0);
}

void stop_trigger_source(PWMV2_Type *ptr)
{
    pwmv2_disable_counter(ptr, pwm_counter_0);
}

void start_trigger_source(PWMV2_Type *ptr)
{
    pwmv2_enable_counter(ptr, pwm_counter_0);
}

void init_trigger_mux(TRGM_Type *ptr, uint8_t input, uint8_t output)
{
    trgm_output_t trgm_output_cfg;

    trgm_output_cfg.invert = false;
    trgm_output_cfg.type = trgm_output_same_as_input;

    trgm_output_cfg.input  = input;
    trgm_output_config(ptr, output, &trgm_output_cfg);
}

void init_trigger_target(ADC16_Type *ptr, uint8_t trig_ch)
{
    adc16_pmt_config_t pmt_cfg;

    pmt_cfg.trig_len = sizeof(trig_adc_channel);
    pmt_cfg.trig_ch = trig_ch;

    for (int i = 0; i < pmt_cfg.trig_len; i++) {
        pmt_cfg.adc_ch[i] = trig_adc_channel[i];
        pmt_cfg.inten[i] = false;
    }

    pmt_cfg.inten[pmt_cfg.trig_len - 1] = true;

    adc16_set_pmt_config(ptr, &pmt_cfg);
    adc16_enable_pmt_queue(ptr, trig_ch);
}

hpm_stat_t init_common_config(adc16_conversion_mode_t conv_mode)
{
    adc16_config_t cfg;

    /* initialize an ADC instance */
    adc16_get_default_config(&cfg);

    cfg.res            = adc16_res_16_bits;
    cfg.conv_mode      = conv_mode;
    cfg.adc_clk_div    = adc16_clock_divider_4;
    cfg.sel_sync_ahb   = (APP_ADC16_CLOCK_BUS == clock_get_source(BOARD_APP_ADC16_CLK_NAME)) ? true : false;

    if (cfg.conv_mode == adc16_conv_mode_sequence ||
        cfg.conv_mode == adc16_conv_mode_preemption) {
        cfg.adc_ahb_en = true;
    }

    /* adc16 initialization */
    if (adc16_init(BOARD_APP_ADC16_BASE, &cfg) == status_success) {
        /* enable irq */
        intc_m_enable_irq_with_priority(BOARD_APP_ADC16_IRQn, 1);
        return status_success;
    } else {
        printf("%s initialization failed!\n", BOARD_APP_ADC16_NAME);
        return status_fail;
    }
}

void init_preemption_config(void)
{
    adc16_channel_config_t ch_cfg;

    /* get a default channel config */
    adc16_get_channel_default_config(&ch_cfg);

    /* initialize an ADC channel */
    ch_cfg.sample_cycle = APP_ADC16_CH_SAMPLE_CYCLE;

    for (uint32_t i = 0; i < sizeof(trig_adc_channel); i++) {
        ch_cfg.ch = trig_adc_channel[i];
        adc16_init_channel(BOARD_APP_ADC16_BASE, &ch_cfg);
    }

    /* Trigger target initialization */
    init_trigger_target(BOARD_APP_ADC16_BASE, APP_ADC16_PMT_TRIG_CH);

    /* Set DMA start address for preemption mode */
    adc16_init_pmt_dma(BOARD_APP_ADC16_BASE, core_local_mem_to_sys_address(APP_ADC16_CORE, (uint32_t)pmt_buff));

    /* Enable trigger complete interrupt */
    adc16_enable_interrupts(BOARD_APP_ADC16_BASE, APP_ADC16_PMT_IRQ_EVENT);

#if !defined(ADC_SOC_NO_HW_TRIG_SRC) && !defined(__ADC16_USE_SW_TRIG)
    /* Trigger mux initialization */
    init_trigger_mux(APP_ADC16_HW_TRGM, APP_ADC16_HW_TRGM_IN, APP_ADC16_HW_TRGM_OUT_PMT);

    /* Trigger source initialization */
    //init_trigger_source(APP_ADC16_HW_TRIG_SRC);
#endif
}

hpm_stat_t process_pmt_data(uint32_t *buff, int32_t start_pos, uint32_t len)
{
    adc16_pmt_dma_data_t *dma_data = (adc16_pmt_dma_data_t *)buff;

    if (ADC16_IS_PMT_DMA_BUFF_LEN_INVLAID(len)) {
        return status_invalid_argument;
    }

    current_cycle_bit = 1;

    for (uint32_t i = start_pos; i < start_pos + len; i++) {
        printf("Preemption Mode - %s - ", BOARD_APP_ADC16_NAME);
        printf("Trigger Channel: %02d - ", dma_data[i].trig_ch);
        printf("Cycle Bit: %02d - ", dma_data[i].cycle_bit);
        printf("Sequence Number: %02d - ", dma_data[i].seq_num);
        printf("ADC Channel: %02d - ", dma_data[i].adc_ch);
        printf("Result: 0x%04x\n", dma_data[i].result);

        if (dma_data[i].cycle_bit == current_cycle_bit) {
            dma_data[i].cycle_bit = 0;
        } else {
            printf("Error: Cycle bit is not expected value[%d]!\n", current_cycle_bit);
            while (1) {

            }
        }
    }

    return status_success;
}

void preemption_handler(void)
{
#if defined(ADC_SOC_NO_HW_TRIG_SRC) || defined(__ADC16_USE_SW_TRIG)
    /* SW trigger */
    adc16_trigger_pmt_by_sw(BOARD_APP_ADC16_BASE, APP_ADC16_PMT_TRIG_CH);
#endif

    /* Wait for a complete of conversion */
    while (trig_complete_flag == 0) {

    }

#if !defined(ADC_SOC_NO_HW_TRIG_SRC) && !defined(__ADC16_USE_SW_TRIG)
    /* Stop the trigger source output */
    stop_trigger_source(APP_ADC16_HW_TRIG_SRC);
#endif

    /* Process data */
    process_pmt_data(pmt_buff, APP_ADC16_PMT_TRIG_CH * sizeof(adc16_pmt_dma_data_t), sizeof(trig_adc_channel));

    /* Clear memory */
    memset(pmt_buff, 0x00, sizeof(pmt_buff));

    /* Clear the flag */
    trig_complete_flag = 0;

#if !defined(ADC_SOC_NO_HW_TRIG_SRC) && !defined(__ADC16_USE_SW_TRIG)
    /* Start the trigger source output */
     start_trigger_source(APP_ADC16_HW_TRIG_SRC);
#endif
}

void gpio_input_interrupt(void)
{
    gpio_interrupt_trigger_t trigger;

    gpio_set_pin_input(BOARD_KEYA_GPIO_CTRL, BOARD_KEYA_GPIO_INDEX,
                           BOARD_KEYA_GPIO_PIN);
    gpio_set_pin_input(BOARD_KEYB_GPIO_CTRL, BOARD_KEYB_GPIO_INDEX,
                           BOARD_KEYB_GPIO_PIN);
    trigger = gpio_interrupt_trigger_edge_rising;

    gpio_config_pin_interrupt(BOARD_KEYA_GPIO_CTRL, BOARD_KEYA_GPIO_INDEX,
                           BOARD_KEYA_GPIO_PIN, trigger);
    gpio_enable_pin_interrupt(BOARD_KEYA_GPIO_CTRL, BOARD_KEYA_GPIO_INDEX,
                           BOARD_KEYA_GPIO_PIN);

    gpio_config_pin_interrupt(BOARD_KEYB_GPIO_CTRL, BOARD_KEYB_GPIO_INDEX,
                           BOARD_KEYA_GPIO_PIN, trigger);
    gpio_enable_pin_interrupt(BOARD_KEYB_GPIO_CTRL, BOARD_KEYB_GPIO_INDEX,
                           BOARD_KEYB_GPIO_PIN);
    intc_m_enable_irq_with_priority(BOARD_KEYA_GPIO_IRQ, 1);
}

int main(void)
{
    board_init();
    board_init_gpio_pins();

    board_init_usb((USB_Type *)CONFIG_HPM_USBD_BASE);
    intc_set_irq_priority(CONFIG_HPM_USBD_IRQn, 2);
    cdc_acm_init(0, CONFIG_HPM_USBD_BASE);

    spi_master_init();
    init_pwm_pins(PWM);
    board_init_adc16_pins();
    board_init_adc_clock(BOARD_APP_ADC16_BASE, true);
    gpio_input_interrupt();
    init_common_config(adc16_conv_mode_preemption);
    //adc16_conv_mode_preemption:
    init_preemption_config();

    printf("pwmv2 three pwm submodule synchronous example\n");
    printf("choose PWM output channel [P%d P%d P%d]\n", PWM_OUTPUT_PIN1, PWM_OUTPUT_PIN2, PWM_OUTPUT_PIN3);
/* set period 36ms */
    freq = clock_get_frequency(PWM_CLOCK_NAME);
    reload = freq / 10000;//1000 * PWM_PERIOD_IN_MS;
    init_synt_timebase();

    pwm_fault_async();
    printf("\n\n>> P%d P%d P%d generate waveform at same time\n", PWM_OUTPUT_PIN1, PWM_OUTPUT_PIN2, PWM_OUTPUT_PIN3);
    printf("P%d is a reference\n", PWM_OUTPUT_PIN1);




    pwm_start_same_time();
    USR_CONFIG_set_default_config();
    MCT_init();
    FOC_init();
    PWMC_init();
    ENCODER_init();
    CONTROLLER_init();
    board_delay_ms(100);
    MCT_set_state(IDLE);
    //pwm_sync_clean();
    //printf("\n\n>> Phase different P%d P%d P%d is 45 degrees 135 degrees\n", PWM_OUTPUT_PIN1, PWM_OUTPUT_PIN2, PWM_OUTPUT_PIN3);
    //printf("P%d is a reference\n", PWM_OUTPUT_PIN1);
    //pwm_start_different_phase();
    //printf("test done\n");
    while (1) {
     adc16_pmt_dma_data_t *dma_data = (adc16_pmt_dma_data_t *)pmt_buff;
    if(1)
    { 
      vofa_send_data(0,dma_data[0].result);
      vofa_send_data(1,dma_data[1].result);
      vofa_send_data(2,dma_data[2].result);
      vofa_send_data(3,Foc.i_a);
      vofa_send_data(4,Foc.i_b);
      vofa_send_data(5,Foc.i_c);
      vofa_send_data(6,Foc.i_d);
      vofa_send_data(7,Foc.i_q);
      vofa_send_data(8,Encoder.pos);
      vofa_send_data(9,Encoder.vel);
      vofa_send_data(10,Controller.pos_setpoint);
      vofa_send_data(11,Controller.vel_setpoint);
      vofa_send_data(12,Controller.torque_setpoint);
      vofa_send_data(13,Foc.i_d_set);
      vofa_send_data(14,Foc.i_q_set);


      vofa_sendframetail();

    }
   

   
    //printf("%d,%d,%d,%f,%f\n",dma_data[0].result,dma_data[1].result,dma_data[2].result,phase,phase_enc);

    //board_delay_ms(1);

    }
    return 0;
}

