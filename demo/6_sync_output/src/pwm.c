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

#define M_PI                                          (3.14159265358f)
#define M_2PI                                         (6.28318530716f)
#define ONE_BY_SQRT3                                  (0.57735026919f)
#define TWO_BY_SQRT3                                  (2.0f * 0.57735026919f)
#define SQRT3_BY_2                                    (0.86602540378f)

#define SQ(x)                                         ((x) * (x))
#define ABS(x)                                        ((x) > 0 ? (x) : -(x))
#define MAX(x, y)                                     (((x) > (y)) ? (x) : (y))
#define MIN(x, y)                                     (((x) < (y)) ? (x) : (y))
#define CLAMP(x, lower, upper)                        (MIN(upper, MAX(x, lower)))
#define FLOAT_EQU(floatA, floatB)                     ((ABS((floatA) - (floatB))) < 0.000001f)
#define UTILS_LP_FAST(value, sample, filter_constant) (value -= (filter_constant) * ((value) - (sample)

#define SIN_TABLE_SIZE 512

static const float sinTable_f32[SIN_TABLE_SIZE + 1]
    = {0.00000000f,  0.01227154f,  0.02454123f,  0.03680722f,  0.04906767f,  0.06132074f,  0.07356456f,  0.08579731f,
       0.09801714f,  0.11022221f,  0.12241068f,  0.13458071f,  0.14673047f,  0.15885814f,  0.17096189f,  0.18303989f,
       0.19509032f,  0.20711138f,  0.21910124f,  0.23105811f,  0.24298018f,  0.25486566f,  0.26671276f,  0.27851969f,
       0.29028468f,  0.30200595f,  0.31368174f,  0.32531029f,  0.33688985f,  0.34841868f,  0.35989504f,  0.37131719f,
       0.38268343f,  0.39399204f,  0.40524131f,  0.41642956f,  0.42755509f,  0.43861624f,  0.44961133f,  0.46053871f,
       0.47139674f,  0.48218377f,  0.49289819f,  0.50353838f,  0.51410274f,  0.52458968f,  0.53499762f,  0.54532499f,
       0.55557023f,  0.56573181f,  0.57580819f,  0.58579786f,  0.59569930f,  0.60551104f,  0.61523159f,  0.62485949f,
       0.63439328f,  0.64383154f,  0.65317284f,  0.66241578f,  0.67155895f,  0.68060100f,  0.68954054f,  0.69837625f,
       0.70710678f,  0.71573083f,  0.72424708f,  0.73265427f,  0.74095113f,  0.74913639f,  0.75720885f,  0.76516727f,
       0.77301045f,  0.78073723f,  0.78834643f,  0.79583690f,  0.80320753f,  0.81045720f,  0.81758481f,  0.82458930f,
       0.83146961f,  0.83822471f,  0.84485357f,  0.85135519f,  0.85772861f,  0.86397286f,  0.87008699f,  0.87607009f,
       0.88192126f,  0.88763962f,  0.89322430f,  0.89867447f,  0.90398929f,  0.90916798f,  0.91420976f,  0.91911385f,
       0.92387953f,  0.92850608f,  0.93299280f,  0.93733901f,  0.94154407f,  0.94560733f,  0.94952818f,  0.95330604f,
       0.95694034f,  0.96043052f,  0.96377607f,  0.96697647f,  0.97003125f,  0.97293995f,  0.97570213f,  0.97831737f,
       0.98078528f,  0.98310549f,  0.98527764f,  0.98730142f,  0.98917651f,  0.99090264f,  0.99247953f,  0.99390697f,
       0.99518473f,  0.99631261f,  0.99729046f,  0.99811811f,  0.99879546f,  0.99932238f,  0.99969882f,  0.99992470f,
       1.00000000f,  0.99992470f,  0.99969882f,  0.99932238f,  0.99879546f,  0.99811811f,  0.99729046f,  0.99631261f,
       0.99518473f,  0.99390697f,  0.99247953f,  0.99090264f,  0.98917651f,  0.98730142f,  0.98527764f,  0.98310549f,
       0.98078528f,  0.97831737f,  0.97570213f,  0.97293995f,  0.97003125f,  0.96697647f,  0.96377607f,  0.96043052f,
       0.95694034f,  0.95330604f,  0.94952818f,  0.94560733f,  0.94154407f,  0.93733901f,  0.93299280f,  0.92850608f,
       0.92387953f,  0.91911385f,  0.91420976f,  0.90916798f,  0.90398929f,  0.89867447f,  0.89322430f,  0.88763962f,
       0.88192126f,  0.87607009f,  0.87008699f,  0.86397286f,  0.85772861f,  0.85135519f,  0.84485357f,  0.83822471f,
       0.83146961f,  0.82458930f,  0.81758481f,  0.81045720f,  0.80320753f,  0.79583690f,  0.78834643f,  0.78073723f,
       0.77301045f,  0.76516727f,  0.75720885f,  0.74913639f,  0.74095113f,  0.73265427f,  0.72424708f,  0.71573083f,
       0.70710678f,  0.69837625f,  0.68954054f,  0.68060100f,  0.67155895f,  0.66241578f,  0.65317284f,  0.64383154f,
       0.63439328f,  0.62485949f,  0.61523159f,  0.60551104f,  0.59569930f,  0.58579786f,  0.57580819f,  0.56573181f,
       0.55557023f,  0.54532499f,  0.53499762f,  0.52458968f,  0.51410274f,  0.50353838f,  0.49289819f,  0.48218377f,
       0.47139674f,  0.46053871f,  0.44961133f,  0.43861624f,  0.42755509f,  0.41642956f,  0.40524131f,  0.39399204f,
       0.38268343f,  0.37131719f,  0.35989504f,  0.34841868f,  0.33688985f,  0.32531029f,  0.31368174f,  0.30200595f,
       0.29028468f,  0.27851969f,  0.26671276f,  0.25486566f,  0.24298018f,  0.23105811f,  0.21910124f,  0.20711138f,
       0.19509032f,  0.18303989f,  0.17096189f,  0.15885814f,  0.14673047f,  0.13458071f,  0.12241068f,  0.11022221f,
       0.09801714f,  0.08579731f,  0.07356456f,  0.06132074f,  0.04906767f,  0.03680722f,  0.02454123f,  0.01227154f,
       0.00000000f,  -0.01227154f, -0.02454123f, -0.03680722f, -0.04906767f, -0.06132074f, -0.07356456f, -0.08579731f,
       -0.09801714f, -0.11022221f, -0.12241068f, -0.13458071f, -0.14673047f, -0.15885814f, -0.17096189f, -0.18303989f,
       -0.19509032f, -0.20711138f, -0.21910124f, -0.23105811f, -0.24298018f, -0.25486566f, -0.26671276f, -0.27851969f,
       -0.29028468f, -0.30200595f, -0.31368174f, -0.32531029f, -0.33688985f, -0.34841868f, -0.35989504f, -0.37131719f,
       -0.38268343f, -0.39399204f, -0.40524131f, -0.41642956f, -0.42755509f, -0.43861624f, -0.44961133f, -0.46053871f,
       -0.47139674f, -0.48218377f, -0.49289819f, -0.50353838f, -0.51410274f, -0.52458968f, -0.53499762f, -0.54532499f,
       -0.55557023f, -0.56573181f, -0.57580819f, -0.58579786f, -0.59569930f, -0.60551104f, -0.61523159f, -0.62485949f,
       -0.63439328f, -0.64383154f, -0.65317284f, -0.66241578f, -0.67155895f, -0.68060100f, -0.68954054f, -0.69837625f,
       -0.70710678f, -0.71573083f, -0.72424708f, -0.73265427f, -0.74095113f, -0.74913639f, -0.75720885f, -0.76516727f,
       -0.77301045f, -0.78073723f, -0.78834643f, -0.79583690f, -0.80320753f, -0.81045720f, -0.81758481f, -0.82458930f,
       -0.83146961f, -0.83822471f, -0.84485357f, -0.85135519f, -0.85772861f, -0.86397286f, -0.87008699f, -0.87607009f,
       -0.88192126f, -0.88763962f, -0.89322430f, -0.89867447f, -0.90398929f, -0.90916798f, -0.91420976f, -0.91911385f,
       -0.92387953f, -0.92850608f, -0.93299280f, -0.93733901f, -0.94154407f, -0.94560733f, -0.94952818f, -0.95330604f,
       -0.95694034f, -0.96043052f, -0.96377607f, -0.96697647f, -0.97003125f, -0.97293995f, -0.97570213f, -0.97831737f,
       -0.98078528f, -0.98310549f, -0.98527764f, -0.98730142f, -0.98917651f, -0.99090264f, -0.99247953f, -0.99390697f,
       -0.99518473f, -0.99631261f, -0.99729046f, -0.99811811f, -0.99879546f, -0.99932238f, -0.99969882f, -0.99992470f,
       -1.00000000f, -0.99992470f, -0.99969882f, -0.99932238f, -0.99879546f, -0.99811811f, -0.99729046f, -0.99631261f,
       -0.99518473f, -0.99390697f, -0.99247953f, -0.99090264f, -0.98917651f, -0.98730142f, -0.98527764f, -0.98310549f,
       -0.98078528f, -0.97831737f, -0.97570213f, -0.97293995f, -0.97003125f, -0.96697647f, -0.96377607f, -0.96043052f,
       -0.95694034f, -0.95330604f, -0.94952818f, -0.94560733f, -0.94154407f, -0.93733901f, -0.93299280f, -0.92850608f,
       -0.92387953f, -0.91911385f, -0.91420976f, -0.90916798f, -0.90398929f, -0.89867447f, -0.89322430f, -0.88763962f,
       -0.88192126f, -0.87607009f, -0.87008699f, -0.86397286f, -0.85772861f, -0.85135519f, -0.84485357f, -0.83822471f,
       -0.83146961f, -0.82458930f, -0.81758481f, -0.81045720f, -0.80320753f, -0.79583690f, -0.78834643f, -0.78073723f,
       -0.77301045f, -0.76516727f, -0.75720885f, -0.74913639f, -0.74095113f, -0.73265427f, -0.72424708f, -0.71573083f,
       -0.70710678f, -0.69837625f, -0.68954054f, -0.68060100f, -0.67155895f, -0.66241578f, -0.65317284f, -0.64383154f,
       -0.63439328f, -0.62485949f, -0.61523159f, -0.60551104f, -0.59569930f, -0.58579786f, -0.57580819f, -0.56573181f,
       -0.55557023f, -0.54532499f, -0.53499762f, -0.52458968f, -0.51410274f, -0.50353838f, -0.49289819f, -0.48218377f,
       -0.47139674f, -0.46053871f, -0.44961133f, -0.43861624f, -0.42755509f, -0.41642956f, -0.40524131f, -0.39399204f,
       -0.38268343f, -0.37131719f, -0.35989504f, -0.34841868f, -0.33688985f, -0.32531029f, -0.31368174f, -0.30200595f,
       -0.29028468f, -0.27851969f, -0.26671276f, -0.25486566f, -0.24298018f, -0.23105811f, -0.21910124f, -0.20711138f,
       -0.19509032f, -0.18303989f, -0.17096189f, -0.15885814f, -0.14673047f, -0.13458071f, -0.12241068f, -0.11022221f,
       -0.09801714f, -0.08579731f, -0.07356456f, -0.06132074f, -0.04906767f, -0.03680722f, -0.02454123f, -0.01227154f,
       -0.00000000f};

#define PWM_PERIOD_IN_MS (36)

uint32_t reload, freq;
uint8_t reload_flag = 0;
float phase = 0.0f;
float dtc_a,dtc_b,dtc_c;
float g_alpha,g_beta;
uint8_t trig_adc_channel[] = {0u,10u,13u};
uint8_t current_cycle_bit;
__IO uint8_t trig_complete_flag;

void FOC_voltage(float Vd_set, float Vq_set, float phase);

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

    pwmv2_set_shadow_val(PWM, PWMV2_SHADOW_INDEX(7), reload -2, 0, false);
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
    pwmv2_channel_enable_output(PWM, PWM_OUTPUT_PIN4);
    pwmv2_channel_enable_output(PWM, PWM_OUTPUT_PIN5);
    pwmv2_channel_enable_output(PWM, PWM_OUTPUT_PIN6);


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

    status = adc16_get_status_flags(BOARD_APP_ADC16_BASE);

    /* Clear status */
    adc16_clear_status_flags(BOARD_APP_ADC16_BASE, status);

    if (ADC16_INT_STS_TRIG_CMPT_GET(status)) {
        /* Set flag to read memory data */
        trig_complete_flag = 1;
        /* Process data */
        //process_pmt_data(pmt_buff, APP_ADC16_PMT_TRIG_CH * sizeof(adc16_pmt_dma_data_t), sizeof(trig_adc_channel));
        phase+=0.01f;
        if(phase > (M_PI * 2.0f))
          phase = 0.0f;

        FOC_voltage(0.5f, 0.0f, phase);
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
        gpio_toggle_pin(BOARD_LED_GPIO_CTRL, BOARD_LED_GPIO_INDEX,
        BOARD_LED_GPIO_PIN);

        pwmv2_channel_enable_output(PWM, pwm_counter_0);
        pwmv2_channel_enable_output(PWM, pwm_counter_1);
        pwmv2_channel_enable_output(PWM, pwm_counter_2);
    }

    if (status & (1u << 16)) 
    {
        gpio_clear_pin_interrupt_flag(BOARD_KEYB_GPIO_CTRL, BOARD_KEYB_GPIO_INDEX,
                        BOARD_KEYB_GPIO_PIN);
        gpio_toggle_pin(BOARD_LED_GPIO_CTRL, BOARD_LED_GPIO_INDEX,
        BOARD_LED_GPIO_PIN);
        
        pwmv2_channel_disable_output(PWM, pwm_counter_0);
        pwmv2_channel_disable_output(PWM, pwm_counter_1);
        pwmv2_channel_disable_output(PWM, pwm_counter_2);
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

    //board_delay_ms(1000);
    //pwm_sync_clean();
    //printf("\n\n>> Phase different P%d P%d P%d is 45 degrees 135 degrees\n", PWM_OUTPUT_PIN1, PWM_OUTPUT_PIN2, PWM_OUTPUT_PIN3);
    //printf("P%d is a reference\n", PWM_OUTPUT_PIN1);
    //pwm_start_different_phase();
    //printf("test done\n");
    while (1) {
    adc16_pmt_dma_data_t *dma_data = (adc16_pmt_dma_data_t *)pmt_buff;
    printf("%d,%d,%d\n",dma_data[0].result,dma_data[1].result,dma_data[2].result);

    board_delay_ms(1);

    }
    return 0;
}

float sin_f32(float x)
{
    float    sinVal, fract, in; /* Temporary variables for input, output */
    uint16_t index;             /* Index variable */
    float    a, b;              /* Two nearest output values */
    int32_t  n;
    float    findex;

    /* input x is in radians */
    /* Scale the input to [0 1] range from [0 2*PI] , divide input by 2*pi */
    in = x * 0.159154943092f;

    /* Calculation of floor value of input */
    n = (int32_t) in;

    /* Make negative values towards -infinity */
    if (x < 0.0f) {
        n--;
    }

    /* Map input value to [0 1] */
    in = in - (float) n;

    /* Calculation of index of the table */
    findex = (float) SIN_TABLE_SIZE * in;
    index  = (uint16_t) findex;

    /* when "in" is exactly 1, we need to rotate the index down to 0 */
    if (index >= SIN_TABLE_SIZE) {
        index = 0;
        findex -= (float) SIN_TABLE_SIZE;
    }

    /* fractional value calculation */
    fract = findex - (float) index;

    /* Read two nearest values of input value from the sin table */
    a = sinTable_f32[index];
    b = sinTable_f32[index + 1];

    /* Linear interpolation process */
    sinVal = (1.0f - fract) * a + fract * b;

    /* Return the output value */
    return (sinVal);
}

float cos_f32(float x)
{
    float    cosVal, fract, in; /* Temporary variables for input, output */
    uint16_t index;             /* Index variable */
    float    a, b;              /* Two nearest output values */
    int32_t  n;
    float    findex;

    /* input x is in radians */
    /* Scale the input to [0 1] range from [0 2*PI] , divide input by 2*pi, add 0.25 (pi/2) to read sine table */
    in = x * 0.159154943092f + 0.25f;

    /* Calculation of floor value of input */
    n = (int32_t) in;

    /* Make negative values towards -infinity */
    if (in < 0.0f) {
        n--;
    }

    /* Map input value to [0 1] */
    in = in - (float) n;

    /* Calculation of index of the table */
    findex = (float) SIN_TABLE_SIZE * in;
    index  = (uint16_t) findex;

    /* when "in" is exactly 1, we need to rotate the index down to 0 */
    if (index >= SIN_TABLE_SIZE) {
        index = 0;
        findex -= (float) SIN_TABLE_SIZE;
    }

    /* fractional value calculation */
    fract = findex - (float) index;

    /* Read two nearest values of input value from the cos table */
    a = sinTable_f32[index];
    b = sinTable_f32[index + 1];

    /* Linear interpolation process */
    cosVal = (1.0f - fract) * a + fract * b;

    /* Return the output value */
    return (cosVal);
}

void inverse_park(float mod_d, float mod_q, float Theta, float *mod_alpha, float *mod_beta)
{
    float s    = sin_f32(Theta);
    float c    = cos_f32(Theta);

    *mod_alpha = mod_d * c - mod_q * s;
    *mod_beta  = mod_d * s + mod_q * c;
}

/// @brief svpwm modulate
/// @param alpha Input   [-1~+1]
/// @param alpha Input   [-1~+1]
/// @param duty_a Output [0~1]
/// @param duty_b Output [0~1]
/// @param duty_c Output [0~1]
int svm(float alpha, float beta, float *duty_a, float *duty_b, float *duty_c)
{
    int Sextant;

    if (beta >= 0.0f) {
        if (alpha >= 0.0f) {
            //quadrant I
            if (ONE_BY_SQRT3 * beta > alpha)
                Sextant = 2; //sextant v2-v3
            else
                Sextant = 1; //sextant v1-v2

        } else {
            //quadrant II
            if (-ONE_BY_SQRT3 * beta > alpha)
                Sextant = 3; //sextant v3-v4
            else
                Sextant = 2; //sextant v2-v3
        }
    } else {
        if (alpha >= 0.0f) {
            //quadrant IV
            if (-ONE_BY_SQRT3 * beta > alpha)
                Sextant = 5; //sextant v5-v6
            else
                Sextant = 6; //sextant v6-v1
        } else {
            //quadrant III
            if (ONE_BY_SQRT3 * beta > alpha)
                Sextant = 4; //sextant v4-v5
            else
                Sextant = 5; //sextant v5-v6
        }
    }

    switch (Sextant) {
    // sextant v1-v2
    case 1: {
        // Vector on-times
        float t1 = alpha - ONE_BY_SQRT3 * beta;
        float t2 = TWO_BY_SQRT3 * beta;

        // PWM timings
        *duty_a = (1.0f - t1 - t2) * 0.5f;
        *duty_b = *duty_a + t1;
        *duty_c = *duty_b + t2;
    } break;

    // sextant v2-v3
    case 2: {
        // Vector on-times
        float t2 = alpha + ONE_BY_SQRT3 * beta;
        float t3 = -alpha + ONE_BY_SQRT3 * beta;

        // PWM timings
        *duty_b = (1.0f - t2 - t3) * 0.5f;
        *duty_a = *duty_b + t3;
        *duty_c = *duty_a + t2;
    } break;

    // sextant v3-v4
    case 3: {
        // Vector on-times
        float t3 = TWO_BY_SQRT3 * beta;
        float t4 = -alpha - ONE_BY_SQRT3 * beta;

        // PWM timings
        *duty_b = (1.0f - t3 - t4) * 0.5f;
        *duty_c = *duty_b + t3;
        *duty_a = *duty_c + t4;
    } break;

    // sextant v4-v5
    case 4: {
        // Vector on-times
        float t4 = -alpha + ONE_BY_SQRT3 * beta;
        float t5 = -TWO_BY_SQRT3 * beta;

        // PWM timings
        *duty_c = (1.0f - t4 - t5) * 0.5f;
        *duty_b = *duty_c + t5;
        *duty_a = *duty_b + t4;
    } break;

    // sextant v5-v6
    case 5: {
        // Vector on-times
        float t5 = -alpha - ONE_BY_SQRT3 * beta;
        float t6 = alpha - ONE_BY_SQRT3 * beta;

        // PWM timings
        *duty_c = (1.0f - t5 - t6) * 0.5f;
        *duty_a = *duty_c + t5;
        *duty_b = *duty_a + t6;
    } break;

    // sextant v6-v1
    case 6: {
        // Vector on-times
        float t6 = -TWO_BY_SQRT3 * beta;
        float t1 = alpha + ONE_BY_SQRT3 * beta;

        // PWM timings
        *duty_a = (1.0f - t6 - t1) * 0.5f;
        *duty_c = *duty_a + t1;
        *duty_b = *duty_c + t6;
    } break;
    }

    // if any of the results becomes NaN, result_valid will evaluate to false
    int result_valid = *duty_a >= 0.0f && *duty_a <= 1.0f && *duty_b >= 0.0f && *duty_b <= 1.0f && *duty_c >= 0.0f
                       && *duty_c <= 1.0f;

    return result_valid ? 0 : -1;
}

void FOC_voltage(float Vd_set, float Vq_set, float phase)
{
    float v_to_mod = 1.5f / 12.0f; // = 1.0f / (Foc.v_bus_filt * 2.0f / 3.0f);
    float mod_vd   = Vd_set * v_to_mod;
    float mod_vq   = Vq_set * v_to_mod;

    // Vector modulation saturation, lock integrator if saturated
    float factor = 0.9f * SQRT3_BY_2 / sqrtf(SQ(mod_vd) + SQ(mod_vq));
    if (factor < 1.0f) {
        mod_vd *= factor;
        mod_vq *= factor;
    }

    // Inverse park transform
    float alpha, beta;
    float pwm_phase = phase;
    inverse_park(mod_vd, mod_vq, pwm_phase, &alpha, &beta);

    // SVM

    g_alpha = alpha;
    g_beta = beta;
    if (0 == svm(alpha, beta, &dtc_a, &dtc_b, &dtc_c)) {
        uint16_t duty_a = (uint16_t)(dtc_a * 20000.0f);
        uint16_t duty_b = (uint16_t)(dtc_b * 20000.0f);
        uint16_t duty_c = (uint16_t)(dtc_c * 20000.0f);

        pwmv2_shadow_register_unlock(PWM);
        pwmv2_set_shadow_val(PWM, PWMV2_SHADOW_INDEX(1), (reload - duty_a) >> 1, 0, false);
        pwmv2_set_shadow_val(PWM, PWMV2_SHADOW_INDEX(2), (reload + duty_a) >> 1, 0, false);
        pwmv2_set_shadow_val(PWM, PWMV2_SHADOW_INDEX(3), (reload - duty_b) >> 1, 0, false);
        pwmv2_set_shadow_val(PWM, PWMV2_SHADOW_INDEX(4), (reload + duty_b) >> 1, 0, false);
        pwmv2_set_shadow_val(PWM, PWMV2_SHADOW_INDEX(5), (reload - duty_c) >> 1, 0, false);
        pwmv2_set_shadow_val(PWM, PWMV2_SHADOW_INDEX(6), (reload + duty_c) >> 1, 0, false);
        pwmv2_shadow_register_lock(PWM);

    }
}
