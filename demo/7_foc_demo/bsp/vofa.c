#include "vofa.h"
#include <math.h>
#include <string.h>
#include <stdlib.h>
#include "usbd_core.h"
#include "usbd_cdc_acm.h"
#include "mc_task.h"
#include "controller.h"
#include "foc.h"
// Union for different data representations
typedef union
{
	float f_val;
	uint32_t u32_val;
	int32_t i32_val;
	uint8_t u8_val[4];
} data_u;

#define MAX_BUFFER_SIZE 1024
USB_NOCACHE_RAM_SECTION USB_MEM_ALIGNX uint8_t send_buf[MAX_BUFFER_SIZE];
uint16_t cnt = 0;


/**
***********************************************************************
* @brief:      vofa_start(void)
* @param:	void
* @retval:     void
* @details:    
***********************************************************************
**/
//float adc_value[3];
//extern uint16_t adc1_buff[2];
//extern uint16_t adc2_buff[4];
void vofa_start(void)
{
	
	//vofa_send_data(1, pm.adc.ia);
	//vofa_send_data(2, pm.adc.ib);
	//vofa_send_data(3, pm.adc.ic);
	
	
	vofa_sendframetail();
}

/**
***********************************************************************
* @brief:      vofa_transmit(uint8_t* buf, uint16_t len)
* @param:		   void
* @retval:     void
* @details:    USARTUSB
***********************************************************************
**/
void vofa_transmit(uint8_t* buf, uint16_t len)
{
//	HAL_UART_Transmit(&huart3, (uint8_t *)buf, len, 0xFFFF);
	//CDC_Transmit_FS((uint8_t *)buf, len);

  cdc_acm_data_send_with_dtr(0,buf,len);
}
/**
***********************************************************************
* @brief:      vofa_send_data(float data)
* @param[in]:  num:  data:  
* @retval:     void
* @details:    
***********************************************************************
**/
void vofa_send_data(uint8_t num, float data) 
{
//	send_buf[cnt++] = byte0(data);
//	send_buf[cnt++] = byte1(data);
//	send_buf[cnt++] = byte2(data);
//	send_buf[cnt++] = byte3(data);
	
	data_u f;
	
	f.f_val = data;
	
	send_buf[cnt++] = f.u8_val[0];
	send_buf[cnt++] = f.u8_val[1];
	send_buf[cnt++] = f.u8_val[2];
	send_buf[cnt++] = f.u8_val[3];
}
/**
***********************************************************************
* @brief      vofa_sendframetail(void)
* @param      NULL 
* @retval     void
* @details:   
***********************************************************************
**/
void vofa_sendframetail(void) 
{
	send_buf[cnt++] = 0x00;
	send_buf[cnt++] = 0x00;
	send_buf[cnt++] = 0x80;
	send_buf[cnt++] = 0x7f;
	
	/*  */
	vofa_transmit((uint8_t *)send_buf, cnt);
	cnt = 0;// 
}
/**
***********************************************************************
* @brief      vofa_demo(void)
* @param      NULL 
* @retval     void
* @details:   demo
***********************************************************************
**/
void vofa_demo(void) 
{
	static float scnt = 0.0f;

	scnt += 0.01f;

	if(scnt >= 360.0f)
		scnt = 0.0f;

	float v1 = scnt;
	float v2 = sin((double)scnt / 180 * 3.14159) * 180 + 180;
	float v3 = sin((double)(scnt + 120) / 180 * 3.14159) * 180 + 180;
	float v4 = sin((double)(scnt + 240) / 180 * 3.14159) * 180 + 180;

	// Call the function to store the data in the buffer
	vofa_send_data(0, v1);
	vofa_send_data(1, v2);
	vofa_send_data(2, v3);
	vofa_send_data(3, v4);

	// Call the function to send the frame tail
	vofa_sendframetail();
}

/**
 * @brief Parse vofa cmd
 * @param cmdBuf
 * @return
 */
static float vofa_cmd_parse(uint8_t *cmdBuf, char *arg)
{
    return atof(cmdBuf + strlen(arg));
}

void vofa_receive_data(uint8_t *buff,uint16_t len) 
{

      if (strstr(buff, "calib"))
      {
          MCT_set_state(CALIBRATION);
      }
      else if (strstr(buff, "run="))
      {
          float val = vofa_cmd_parse(buff, "run=");
          if (val > 0)
              MCT_set_state(RUN);
          else
              MCT_set_state(IDLE);
      }
      else if (strstr(buff, "anticog"))
      {
          MCT_set_state(ANTICOGGING);
      }
      else if (strstr(buff, "rsetErr"))
      {
          MCT_reset_error();
      }
      else if (strstr(buff, "torque"))
      {
          float val = vofa_cmd_parse(buff, "torque=");
          Controller.input_torque_buffer = val;
          CONTROLLER_sync_callback();
      }
      else if (strstr(buff, "vel"))
      {
          float val = vofa_cmd_parse(buff, "vel=");
          Controller.input_velocity_buffer = val;
          CONTROLLER_sync_callback();
      }
      else if (strstr(buff, "pos"))
      {
          float val = vofa_cmd_parse(buff, "pos=");
          Controller.input_position_buffer = val;
          CONTROLLER_sync_callback();
      }
      else if (strstr(buff, "id"))
      {
          float val = vofa_cmd_parse(buff, "id=");
          Foc.i_d_set = val;
      }
      else
      {}


}











