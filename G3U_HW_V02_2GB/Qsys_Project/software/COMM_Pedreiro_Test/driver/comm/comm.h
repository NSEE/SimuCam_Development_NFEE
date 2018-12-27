/*
 * comm.h
 *
 *  Created on: 18/12/2018
 *      Author: rfranca
 */

#ifndef COMM_H_
#define COMM_H_

#include "../../utils/meb_includes.h"

//! [constants definition]
// address
#define COMM_CHANNEL_A_BASE_ADDR          COMM_PEDREIRO_V1_01_A_BASE
#define COMM_CHANNEL_B_BASE_ADDR          COMM_PEDREIRO_V1_01_B_BASE
#define COMM_CHANNEL_C_BASE_ADDR          COMM_PEDREIRO_V1_01_C_BASE
#define COMM_CHANNEL_D_BASE_ADDR          COMM_PEDREIRO_V1_01_D_BASE
#define COMM_CHANNEL_E_BASE_ADDR          COMM_PEDREIRO_V1_01_E_BASE
#define COMM_CHANNEL_F_BASE_ADDR          COMM_PEDREIRO_V1_01_F_BASE
#define COMM_CHANNEL_G_BASE_ADDR          COMM_PEDREIRO_V1_01_G_BASE
#define COMM_CHANNEL_H_BASE_ADDR          COMM_PEDREIRO_V1_01_H_BASE
#define COMM_WINDOWING_CONTROL_REG_OFFSET 0
#define COMM_WINDOWING_STATUS_REG_OFFSET  1
#define COMM_TIMECODE_RX_REG_OFFSET       2
#define COMM_TIMECODE_TX_REG_OFFSET       3
#define COMM_INTERRUPT_CONTROL_REG_OFFSET 4
#define COMM_INTERRUPT_FLAG_REG_OFFSET    5
#define COMM_WINDOWING_BUFFER_REG_OFFSET  6

// bit masks
#define COMM_CONTROL_MASKING_EN_MASK               (1 << 8)
#define COMM_CONTROL_LINK_AUTOSTART_MASK           (1 << 2)
#define COMM_CONTROL_LINK_START_MASK               (1 << 1)
#define COMM_CONTROL_LINK_DISCONNECT_MASK          (1 << 0)

#define COMM_STATUS_LINK_DISC_ERR_MASK             (1 << 11)
#define COMM_STATUS_LINK_PAR_ERR_MASK              (1 << 10)
#define COMM_STATUS_LINK_ESC_ERR_MASK              (1 << 9)
#define COMM_STATUS_LINK_CRED_ERR_MASK             (1 << 8)
#define COMM_STATUS_LINK_STARTED_MASK              (1 << 2)
#define COMM_STATUS_LINK_CONNECTING_MASK           (1 << 1)
#define COMM_STATUS_LINK_RUNNING_MASK              (1 << 0)

#define COMM_TIMECODE_RX_CONTROL_MASK              (0b11     << 7)
#define COMM_TIMECODE_RX_COUNTER_MASK              (0b111111 << 1)
#define COMM_TIMECODE_RX_RECEIVED_MASK             (1        << 0)

#define COMM_TIMECODE_TX_CONTROL_MASK              (0b11     << 7)
#define COMM_TIMECODE_TX_COUNTER_MASK              (0b111111 << 1)
#define COMM_TIMECODE_TX_SEND_MASK                 (1        << 0)

#define COMM_INT_LEFT_BUFFER_EMPTY_EN_MASK         (1 << 8)
#define COMM_INT_RIGHT_BUFFER_EMPTY_EN_MASK        (1 << 0)

#define COMM_INT_BUFFER_EMPTY_FLAG_MASK            (1 << 0)

#define COMM_BUFFER_STATUS_LEFT_BUFFER_EMPTY_MASK  (1 << 8)
#define COMM_BUFFER_STATUS_RIGHT_BUFFER_EMPTY_MASK (1 << 0)
//! [constants definition]

//! [public module structs definition]
enum comm_spw_channel_t {
	spacewire_channel_a = 1,
	spacewire_channel_b = 2,
	spacewire_channel_c = 3,
	spacewire_channel_d = 4,
	spacewire_channel_e = 5,
	spacewire_channel_f = 6,
	spacewire_channel_g = 7,
	spacewire_channel_h = 8
} comm_spw_channel_t;

typedef struct comm_windowing_config_t {
	bool masking;
} comm_windowing_config_t;

typedef struct comm_link_config_t {
	bool autostart;
	bool start;
	bool disconnect;
} comm_link_config_t;

typedef struct comm_link_error_t {
	bool disconnect;
	bool parity;
	bool escape;
	bool credit;
} comm_link_error_t;

typedef struct comm_link_status_t {
	bool started;
	bool connecting;
	bool running;
} comm_link_status_t;

typedef struct comm_timecode_rx_t {
	alt_u8 control;
	alt_u8 counter;
	bool received;
} comm_timecode_rx_t;

typedef struct comm_timecode_tx_t {
	alt_u8 control;
	alt_u8 counter;
	bool send;
} comm_timecode_tx_t;

typedef struct comm_int_control_t {
	bool left_buffer_empty_en;
	bool right_buffer_empty_en;
} comm_int_control_t;

typedef struct comm_int_flag_t {
	bool buffer_empty_flag;
} comm_int_flag_t;

typedef struct comm_buffer_status_t {
	bool left_buffer_empty;
	bool right_buffer_empty;
} comm_buffer_status_t;

typedef struct comm_channel_t {
	alt_u32 *channel_address;
	comm_windowing_config_t windowing_config;
	comm_link_config_t link_config;
	comm_link_error_t link_error;
	comm_link_status_t link_status;
	comm_timecode_rx_t timecode_rx;
	comm_timecode_tx_t timecode_tx;
	comm_int_control_t int_control;
	comm_int_flag_t int_flag;
	comm_buffer_status_t buffer_status;
} comm_channel_t;
//! [public module structs definition]

//! [public function prototypes]
void comm_channel_a_handle_irq(void* context);
void comm_channel_b_handle_irq(void* context);
void comm_channel_c_handle_irq(void* context);
void comm_channel_d_handle_irq(void* context);
void comm_channel_e_handle_irq(void* context);
void comm_channel_f_handle_irq(void* context);
void comm_channel_g_handle_irq(void* context);
void comm_channel_h_handle_irq(void* context);

void comm_init_interrupt(alt_u8 spw_channel);

bool comm_config_int_control(comm_channel_t *channel);
bool comm_update_int_control(comm_channel_t *channel);
bool comm_update_int_flags(comm_channel_t *channel);

bool comm_int_flag_clear_buffer_empty(comm_channel_t *channel);
bool comm_int_flag_buffer_empty(comm_channel_t *channel, bool *flag);

bool comm_config_windowing(comm_channel_t *channel);
bool comm_update_windowing(comm_channel_t *channel);
bool comm_config_link(comm_channel_t *channel);
bool comm_update_link(comm_channel_t *channel);
bool comm_update_link_error(comm_channel_t *channel);
bool comm_update_link_status(comm_channel_t *channel);
bool comm_update_timecode_rx(comm_channel_t *channel);
bool comm_clear_timecode_rx_received(comm_channel_t *channel);
bool comm_send_timecode_tx(comm_channel_t *channel);
bool comm_update_timecode_tx(comm_channel_t *channel);
bool comm_update_buffers_status(comm_channel_t *channel);
bool comm_init_channel(comm_channel_t *channel, alt_u8 spw_channel);

extern volatile alt_u8 int_cnt;

//! [public function prototypes]

//! [data memory public global variables - use extern]
//! [data memory public global variables - use extern]

//! [flags]
//! [flags]

//! [program memory public global variables - use extern]
//! [program memory public global variables - use extern]

//! [macros]
//! [macros]

#endif /* COMM_H_ */
