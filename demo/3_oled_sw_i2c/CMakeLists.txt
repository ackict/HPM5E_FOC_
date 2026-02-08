# Copyright (c) 2023 HPMicro
# SPDX-License-Identifier: BSD-3-Clause

cmake_minimum_required(VERSION 3.13)

find_package(hpm-sdk REQUIRED HINTS $ENV{HPM_SDK_BASE})

project(oled_sw_i2c)

sdk_app_inc(OLED)

sdk_app_src(src/oled_sw_i2c.c)
sdk_app_src(OLED/oled.c)
generate_ide_projects()
