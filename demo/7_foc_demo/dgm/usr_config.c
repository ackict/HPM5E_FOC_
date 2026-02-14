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

#include "usr_config.h"
#include "controller.h"
#include "util.h"
#include <string.h>

tUsrConfig   UsrConfig;
tCoggingMap *pCoggingMap = NULL;

void USR_CONFIG_set_default_config(void)
{
    // Motor
    UsrConfig.invert_motor_dir       = 0;
    UsrConfig.inertia                = 0.0001f;
    UsrConfig.torque_constant        = 1.0f;//0.051274;
    UsrConfig.motor_pole_pairs       = 7;
    UsrConfig.motor_phase_resistance = 0.11247408f;
    UsrConfig.motor_phase_inductance = 0.00002567f;
    UsrConfig.current_limit          = 4;
    UsrConfig.velocity_limit         = 100;

    // Encoder
    UsrConfig.calib_current = 5.0f;
    UsrConfig.calib_voltage = 3.0f;

    // Anticogging
    UsrConfig.anticogging_enable = 1;

    // Controller
    UsrConfig.control_mode           = CONTROL_MODE_POSITION_PROFILE;
    UsrConfig.pos_gain               = 100.0f;
    UsrConfig.vel_gain               = 0.008f;
    UsrConfig.vel_integrator_gain    = 0.05f;
    UsrConfig.current_ctrl_bw        = 800;
    UsrConfig.sync_target_enable     = 0;
    UsrConfig.target_velcity_window  = 0.05f;
    UsrConfig.target_position_window = 0.025f;
    UsrConfig.torque_ramp_rate       = 0.1f;
    UsrConfig.velocity_ramp_rate     = 100.0f;
    UsrConfig.position_filter_bw     = 2;
    UsrConfig.profile_velocity       = 60;
    UsrConfig.profile_accel          = 80;
    UsrConfig.profile_decel          = 80;

    // Protect
    UsrConfig.protect_under_voltage = 12;
    UsrConfig.protect_over_voltage  = 30;
    UsrConfig.protect_over_current  = 8;
    UsrConfig.protect_i_bus_max     = 5;

    // CAN
    UsrConfig.node_id               = 1;
    UsrConfig.can_baudrate          = CAN_BAUDRATE_500K;
    UsrConfig.heartbeat_consumer_ms = 0;
    UsrConfig.heartbeat_producer_ms = 0;

    // Encoder
    UsrConfig.calib_valid = 1;
    UsrConfig.encoder_offset = 1680;
}