# Copyright (c) 2021-2025 HPMicro
# SPDX-License-Identifier: BSD-3-Clause

cmake_minimum_required(VERSION 3.13)

if("${HPM_BUILD_TYPE}" STREQUAL "")
    SET(HPM_BUILD_TYPE flash_xip)
endif()

set(CONFIG_LWIP 1)
set(CONFIG_LWIP_IPERF 1)

set(CONFIG_ENET_PHY 1)
set(APP_USE_ENET_PORT_COUNT 1)
set(APP_USE_ENET_ITF_MII 1)
# set(APP_USE_ENET_ITF_RMII 1)


if(NOT DEFINED APP_USE_ENET_PORT_COUNT)
    message(FATAL_ERROR "APP_USE_ENET_PORT_COUNT is undefined!")
endif()

if(NOT APP_USE_ENET_PORT_COUNT EQUAL 1)
    message(FATAL_ERROR "This sample supports only one Ethernet port!")
endif()

if (NOT DEFINED APP_USE_ENET_ITF_MII AND NOT DEFINED APP_USE_ENET_ITF_RMII)
    message(FATAL_ERROR "This sample doesn't support more than one Ethernet phy!")
endif()


find_package(hpm-sdk REQUIRED HINTS $ENV{HPM_SDK_BASE})

if (APP_USE_ENET_ITF_RMII EQUAL 1)
    sdk_compile_definitions(-DRMII=1)
endif()

if (APP_USE_ENET_ITF_MII EQUAL 1)
    sdk_compile_definitions(-DMII=1)
endif()

sdk_compile_definitions(-D__DISABLE_AUTO_NEGO=0)
sdk_compile_definitions(-D__ENABLE_ENET_RECEIVE_INTERRUPT=0)
sdk_compile_definitions(-DLWIP_DHCP=1)
sdk_compile_definitions(-DUSE_LWIPOPTS_APP_H=1)
sdk_compile_definitions(-DREMOTE_IP_CONFIG=192.168.1.132)

project(lwip_iperf_example)
sdk_inc(../ports/baremetal/single)
sdk_inc(../ports/baremetal/single/arch)
sdk_inc(../common/single)
sdk_inc(inc)

sdk_app_src(../ports/baremetal/single/arch/sys_arch.c)
sdk_app_src(../ports/baremetal/single/ethernetif.c)
sdk_app_src(../common/single/common.c)
sdk_app_src(../common/single/netconf.c)
sdk_app_src(src/lwip.c)
generate_ide_projects()
