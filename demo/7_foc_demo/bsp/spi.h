#ifndef _SPI_H
#define _SPI_H
#include "board.h"

void spi_master_init(void);
uint32_t mt6816_read_reg(void);
#endif