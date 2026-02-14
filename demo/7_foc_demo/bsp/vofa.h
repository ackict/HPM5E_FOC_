#ifndef _VOFA_H
#define _VOFA_H
#include "board.h"

extern volatile bool dtr_enable;
void vofa_send_data(uint8_t num, float data);
void vofa_sendframetail(void);
void vofa_receive_data(uint8_t *buff,uint16_t len);
void cdc_acm_init(uint8_t busid, uint32_t reg_base);
void cdc_acm_data_send_with_dtr(uint8_t busid,uint8_t * tx_buffer,uint16_t len);
#endif