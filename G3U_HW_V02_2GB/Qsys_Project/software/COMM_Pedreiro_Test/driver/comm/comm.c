#include "comm.h"

extern volatile alt_u8 int_cnt = 0;

//! [private function prototypes]
static void write_reg(alt_u32 *address, alt_u32 offset, alt_u32 data);
static alt_u32 read_reg(alt_u32 *address, alt_u32 offset);
//! [private function prototypes]

//! [data memory public global variables]
//! [data memory public global variables]

//! [program memory public global variables]
//! [program memory public global variables]

//! [data memory private global variables]
// A variable to hold the context of interrupt
static volatile int channel_a_hold_context;
static volatile int channel_b_hold_context;
static volatile int channel_c_hold_context;
static volatile int channel_d_hold_context;
static volatile int channel_e_hold_context;
static volatile int channel_f_hold_context;
static volatile int channel_g_hold_context;
static volatile int channel_h_hold_context;
//! [data memory private global variables]

//! [program memory private global variables]
//! [program memory private global variables]

//! [public functions]

void comm_channel_a_handle_irq(void* context) {
	// Cast context to hold_context's type. It is important that this be
	// declared volatile to avoid unwanted compiler optimization.
	volatile int* hold_context_ptr = (volatile int*) context;
	// Use context value according to your app logic...
	//*hold_context_ptr = ...;
	// if (*hold_context_ptr == '0') {}...
	// App logic sequence...
	int_cnt++;
	comm_channel_a_int_flag_clear_buffer_empty();
}

void comm_channel_b_handle_irq(void* context) {
	// Cast context to hold_context's type. It is important that this be
	// declared volatile to avoid unwanted compiler optimization.
	volatile int* hold_context_ptr = (volatile int*) context;
	// Use context value according to your app logic...
	//*hold_context_ptr = ...;
	// if (*hold_context_ptr == '0') {}...
	// App logic sequence...
	comm_channel_b_int_flag_clear_buffer_empty();
}

void comm_channel_c_handle_irq(void* context) {
	// Cast context to hold_context's type. It is important that this be
	// declared volatile to avoid unwanted compiler optimization.
	volatile int* hold_context_ptr = (volatile int*) context;
	// Use context value according to your app logic...
	//*hold_context_ptr = ...;
	// if (*hold_context_ptr == '0') {}...
	// App logic sequence...
	comm_channel_c_int_flag_clear_buffer_empty();
}

void comm_channel_d_handle_irq(void* context) {
	// Cast context to hold_context's type. It is important that this be
	// declared volatile to avoid unwanted compiler optimization.
	volatile int* hold_context_ptr = (volatile int*) context;
	// Use context value according to your app logic...
	//*hold_context_ptr = ...;
	// if (*hold_context_ptr == '0') {}...
	// App logic sequence...
	comm_channel_d_int_flag_clear_buffer_empty();
}

void comm_channel_e_handle_irq(void* context) {
	// Cast context to hold_context's type. It is important that this be
	// declared volatile to avoid unwanted compiler optimization.
	volatile int* hold_context_ptr = (volatile int*) context;
	// Use context value according to your app logic...
	//*hold_context_ptr = ...;
	// if (*hold_context_ptr == '0') {}...
	// App logic sequence...
	comm_channel_e_int_flag_clear_buffer_empty();
}

void comm_channel_f_handle_irq(void* context) {
	// Cast context to hold_context's type. It is important that this be
	// declared volatile to avoid unwanted compiler optimization.
	volatile int* hold_context_ptr = (volatile int*) context;
	// Use context value according to your app logic...
	//*hold_context_ptr = ...;
	// if (*hold_context_ptr == '0') {}...
	// App logic sequence...
	comm_channel_f_int_flag_clear_buffer_empty();
}

void comm_channel_g_handle_irq(void* context) {
	// Cast context to hold_context's type. It is important that this be
	// declared volatile to avoid unwanted compiler optimization.
	volatile int* hold_context_ptr = (volatile int*) context;
	// Use context value according to your app logic...
	//*hold_context_ptr = ...;
	// if (*hold_context_ptr == '0') {}...
	// App logic sequence...
	comm_channel_g_int_flag_clear_buffer_empty();
}

void comm_channel_h_handle_irq(void* context) {
	// Cast context to hold_context's type. It is important that this be
	// declared volatile to avoid unwanted compiler optimization.
	volatile int* hold_context_ptr = (volatile int*) context;
	// Use context value according to your app logic...
	//*hold_context_ptr = ...;
	// if (*hold_context_ptr == '0') {}...
	// App logic sequence...
	comm_channel_h_int_flag_clear_buffer_empty();
}

void comm_channel_a_int_flag_clear_buffer_empty(void) {
	write_reg((alt_u32*) COMM_CHANNEL_A_BASE_ADDR,
	COMM_INTERRUPT_FLAG_REG_OFFSET, (alt_u32) COMM_INT_BUFFER_EMPTY_FLAG_MASK);
}

void comm_channel_b_int_flag_clear_buffer_empty(void) {
	write_reg((alt_u32*) COMM_CHANNEL_B_BASE_ADDR,
	COMM_INTERRUPT_FLAG_REG_OFFSET, (alt_u32) COMM_INT_BUFFER_EMPTY_FLAG_MASK);
}

void comm_channel_c_int_flag_clear_buffer_empty(void) {
	write_reg((alt_u32*) COMM_CHANNEL_C_BASE_ADDR,
	COMM_INTERRUPT_FLAG_REG_OFFSET, (alt_u32) COMM_INT_BUFFER_EMPTY_FLAG_MASK);
}

void comm_channel_d_int_flag_clear_buffer_empty(void) {
	write_reg((alt_u32*) COMM_CHANNEL_D_BASE_ADDR,
	COMM_INTERRUPT_FLAG_REG_OFFSET, (alt_u32) COMM_INT_BUFFER_EMPTY_FLAG_MASK);
}

void comm_channel_e_int_flag_clear_buffer_empty(void) {
	write_reg((alt_u32*) COMM_CHANNEL_E_BASE_ADDR,
	COMM_INTERRUPT_FLAG_REG_OFFSET, (alt_u32) COMM_INT_BUFFER_EMPTY_FLAG_MASK);
}

void comm_channel_f_int_flag_clear_buffer_empty(void) {
	write_reg((alt_u32*) COMM_CHANNEL_F_BASE_ADDR,
	COMM_INTERRUPT_FLAG_REG_OFFSET, (alt_u32) COMM_INT_BUFFER_EMPTY_FLAG_MASK);
}

void comm_channel_g_int_flag_clear_buffer_empty(void) {
	write_reg((alt_u32*) COMM_CHANNEL_G_BASE_ADDR,
	COMM_INTERRUPT_FLAG_REG_OFFSET, (alt_u32) COMM_INT_BUFFER_EMPTY_FLAG_MASK);
}

void comm_channel_h_int_flag_clear_buffer_empty(void) {
	write_reg((alt_u32*) COMM_CHANNEL_H_BASE_ADDR,
	COMM_INTERRUPT_FLAG_REG_OFFSET, (alt_u32) COMM_INT_BUFFER_EMPTY_FLAG_MASK);
}

bool comm_channel_a_int_flag_buffer_empty(void) {
	bool flag;

	if (read_reg((alt_u32*) COMM_CHANNEL_A_BASE_ADDR,
	COMM_INTERRUPT_FLAG_REG_OFFSET) & COMM_INT_BUFFER_EMPTY_FLAG_MASK) {
		flag = TRUE;
	} else {
		flag = FALSE;
	}

	return flag;
}

bool comm_channel_b_int_flag_buffer_empty(void) {
	bool flag;

	if (read_reg((alt_u32*) COMM_CHANNEL_B_BASE_ADDR,
	COMM_INTERRUPT_FLAG_REG_OFFSET) & COMM_INT_BUFFER_EMPTY_FLAG_MASK) {
		flag = TRUE;
	} else {
		flag = FALSE;
	}

	return flag;
}

bool comm_channel_c_int_flag_buffer_empty(void) {
	bool flag;

	if (read_reg((alt_u32*) COMM_CHANNEL_C_BASE_ADDR,
	COMM_INTERRUPT_FLAG_REG_OFFSET) & COMM_INT_BUFFER_EMPTY_FLAG_MASK) {
		flag = TRUE;
	} else {
		flag = FALSE;
	}

	return flag;
}

bool comm_channel_d_int_flag_buffer_empty(void) {
	bool flag;

	if (read_reg((alt_u32*) COMM_CHANNEL_D_BASE_ADDR,
	COMM_INTERRUPT_FLAG_REG_OFFSET) & COMM_INT_BUFFER_EMPTY_FLAG_MASK) {
		flag = TRUE;
	} else {
		flag = FALSE;
	}

	return flag;
}

bool comm_channel_e_int_flag_buffer_empty(void) {
	bool flag;

	if (read_reg((alt_u32*) COMM_CHANNEL_E_BASE_ADDR,
	COMM_INTERRUPT_FLAG_REG_OFFSET) & COMM_INT_BUFFER_EMPTY_FLAG_MASK) {
		flag = TRUE;
	} else {
		flag = FALSE;
	}

	return flag;
}

bool comm_channel_f_int_flag_buffer_empty(void) {
	bool flag;

	if (read_reg((alt_u32*) COMM_CHANNEL_F_BASE_ADDR,
	COMM_INTERRUPT_FLAG_REG_OFFSET) & COMM_INT_BUFFER_EMPTY_FLAG_MASK) {
		flag = TRUE;
	} else {
		flag = FALSE;
	}

	return flag;
}

bool comm_channel_g_int_flag_buffer_empty(void) {
	bool flag;

	if (read_reg((alt_u32*) COMM_CHANNEL_G_BASE_ADDR,
	COMM_INTERRUPT_FLAG_REG_OFFSET) & COMM_INT_BUFFER_EMPTY_FLAG_MASK) {
		flag = TRUE;
	} else {
		flag = FALSE;
	}

	return flag;
}

bool comm_channel_h_int_flag_buffer_empty(void) {
	bool flag;

	if (read_reg((alt_u32*) COMM_CHANNEL_H_BASE_ADDR,
	COMM_INTERRUPT_FLAG_REG_OFFSET) & COMM_INT_BUFFER_EMPTY_FLAG_MASK) {
		flag = TRUE;
	} else {
		flag = FALSE;
	}

	return flag;
}

void comm_init_interrupt(alt_u8 spw_channel) {
	void* hold_context_ptr;
	switch (spw_channel) {
	case spacewire_channel_a:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		hold_context_ptr = (void*) &channel_a_hold_context;
		// Register the interrupt handler
		alt_irq_register(COMM_PEDREIRO_V1_01_A_IRQ, hold_context_ptr,
				comm_channel_a_handle_irq);
		break;
	case spacewire_channel_b:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		hold_context_ptr = (void*) &channel_b_hold_context;
		// Register the interrupt handler
		alt_irq_register(COMM_PEDREIRO_V1_01_B_IRQ, hold_context_ptr,
				comm_channel_b_handle_irq);
		break;
	case spacewire_channel_c:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		hold_context_ptr = (void*) &channel_c_hold_context;
		// Register the interrupt handler
		alt_irq_register(COMM_PEDREIRO_V1_01_C_IRQ, hold_context_ptr,
				comm_channel_c_handle_irq);
		break;
	case spacewire_channel_d:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		hold_context_ptr = (void*) &channel_d_hold_context;
		// Register the interrupt handler
		alt_irq_register(COMM_PEDREIRO_V1_01_D_IRQ, hold_context_ptr,
				comm_channel_d_handle_irq);
		break;
	case spacewire_channel_e:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		hold_context_ptr = (void*) &channel_e_hold_context;
		// Register the interrupt handler
		alt_irq_register(COMM_PEDREIRO_V1_01_E_IRQ, hold_context_ptr,
				comm_channel_e_handle_irq);
		break;
	case spacewire_channel_f:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		hold_context_ptr = (void*) &channel_f_hold_context;
		// Register the interrupt handler
		alt_irq_register(COMM_PEDREIRO_V1_01_F_IRQ, hold_context_ptr,
				comm_channel_f_handle_irq);
		break;
	case spacewire_channel_g:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		hold_context_ptr = (void*) &channel_g_hold_context;
		// Register the interrupt handler
		alt_irq_register(COMM_PEDREIRO_V1_01_G_IRQ, hold_context_ptr,
				comm_channel_g_handle_irq);
		break;
	case spacewire_channel_h:
		// Recast the hold_context pointer to match the alt_irq_register() function
		// prototype.
		hold_context_ptr = (void*) &channel_h_hold_context;
		// Register the interrupt handler
		alt_irq_register(COMM_PEDREIRO_V1_01_H_IRQ, hold_context_ptr,
				comm_channel_h_handle_irq);
		break;
	}
}

bool comm_config_int_control(comm_channel_t *channel) {
	bool status = FALSE;
	alt_u32 reg = 0;

	if (channel != NULL) {
		reg = read_reg(channel->channel_address,
		COMM_INTERRUPT_CONTROL_REG_OFFSET);

		if (channel->int_control.left_buffer_empty_en) {
			reg |= COMM_INT_LEFT_BUFFER_EMPTY_EN_MASK;
		} else {
			reg &= (~COMM_INT_LEFT_BUFFER_EMPTY_EN_MASK);
		}
		if (channel->int_control.right_buffer_empty_en) {
			reg |= COMM_INT_RIGHT_BUFFER_EMPTY_EN_MASK;
		} else {
			reg &= (~COMM_INT_RIGHT_BUFFER_EMPTY_EN_MASK);
		}

		write_reg(channel->channel_address, COMM_INTERRUPT_CONTROL_REG_OFFSET,
				reg);
		status = TRUE;
	}

	return status;
}

bool comm_update_int_control(comm_channel_t *channel) {
	bool status = FALSE;
	alt_u32 reg = 0;

	if (channel != NULL) {
		reg = read_reg(channel->channel_address,
		COMM_INTERRUPT_CONTROL_REG_OFFSET);

		if (reg & COMM_INT_LEFT_BUFFER_EMPTY_EN_MASK) {
			channel->int_control.left_buffer_empty_en = TRUE;
		} else {
			channel->int_control.left_buffer_empty_en = FALSE;
		}
		if (reg & COMM_INT_RIGHT_BUFFER_EMPTY_EN_MASK) {
			channel->int_control.right_buffer_empty_en = TRUE;
		} else {
			channel->int_control.right_buffer_empty_en = FALSE;
		}

		status = TRUE;
	}

	return status;
}

bool comm_update_int_flags(comm_channel_t *channel) {
	bool status = FALSE;
	alt_u32 reg = 0;

	if (channel != NULL) {
		reg = read_reg(channel->channel_address,
		COMM_INTERRUPT_FLAG_REG_OFFSET);

		if (reg & COMM_INT_BUFFER_EMPTY_FLAG_MASK) {
			channel->int_flag.buffer_empty_flag = TRUE;
		} else {
			channel->int_flag.buffer_empty_flag = FALSE;
		}

		status = TRUE;
	}

	return status;
}

bool comm_config_windowing(comm_channel_t *channel) {
	bool status = FALSE;
	alt_u32 reg = 0;

	if (channel != NULL) {
		reg = read_reg(channel->channel_address,
		COMM_WINDOWING_CONTROL_REG_OFFSET);

		if (channel->windowing_config.masking) {
			reg |= COMM_CONTROL_MASKING_EN_MASK;
		} else {
			reg &= (~COMM_CONTROL_MASKING_EN_MASK);
		}

		write_reg(channel->channel_address, COMM_WINDOWING_CONTROL_REG_OFFSET,
				reg);
		status = TRUE;
	}

	return status;
}

bool comm_update_windowing(comm_channel_t *channel) {
	bool status = FALSE;
	alt_u32 reg = 0;

	if (channel != NULL) {
		reg = read_reg(channel->channel_address,
		COMM_WINDOWING_CONTROL_REG_OFFSET);

		if (reg & COMM_CONTROL_MASKING_EN_MASK) {
			channel->windowing_config.masking = TRUE;
		} else {
			channel->windowing_config.masking = FALSE;
		}

		status = TRUE;
	}

	return status;
}

bool comm_config_link(comm_channel_t *channel) {
	bool status = FALSE;
	alt_u32 reg = 0;

	if (channel != NULL) {
		reg = read_reg(channel->channel_address,
		COMM_WINDOWING_CONTROL_REG_OFFSET);

		if (channel->link_config.autostart) {
			reg |= COMM_CONTROL_LINK_AUTOSTART_MASK;
		} else {
			reg &= (~COMM_CONTROL_LINK_AUTOSTART_MASK);
		}
		if (channel->link_config.start) {
			reg |= COMM_CONTROL_LINK_START_MASK;
		} else {
			reg &= (~COMM_CONTROL_LINK_START_MASK);
		}
		if (channel->link_config.disconnect) {
			reg |= COMM_CONTROL_LINK_DISCONNECT_MASK;
		} else {
			reg &= (~COMM_CONTROL_LINK_DISCONNECT_MASK);
		}

		write_reg(channel->channel_address, COMM_WINDOWING_CONTROL_REG_OFFSET,
				reg);
		status = TRUE;
	}

	return status;
}

bool comm_update_link(comm_channel_t *channel) {
	bool status = FALSE;
	alt_u32 reg = 0;

	if (channel != NULL) {
		reg = read_reg(channel->channel_address,
		COMM_WINDOWING_CONTROL_REG_OFFSET);

		if (reg & COMM_CONTROL_LINK_AUTOSTART_MASK) {
			channel->link_config.autostart = TRUE;
		} else {
			channel->link_config.autostart = FALSE;
		}
		if (reg & COMM_CONTROL_LINK_START_MASK) {
			channel->link_config.start = TRUE;
		} else {
			channel->link_config.start = FALSE;
		}
		if (reg & COMM_CONTROL_LINK_DISCONNECT_MASK) {
			channel->link_config.disconnect = TRUE;
		} else {
			channel->link_config.disconnect = FALSE;
		}

		status = TRUE;
	}

	return status;
}

bool comm_update_link_error(comm_channel_t *channel) {
	bool status = FALSE;
	alt_u32 reg = 0;

	if (channel != NULL) {
		reg = read_reg(channel->channel_address,
		COMM_WINDOWING_STATUS_REG_OFFSET);

		if (reg & COMM_STATUS_LINK_DISC_ERR_MASK) {
			channel->link_error.disconnect = TRUE;
		} else {
			channel->link_error.disconnect = FALSE;
		}
		if (reg & COMM_STATUS_LINK_PAR_ERR_MASK) {
			channel->link_error.parity = TRUE;
		} else {
			channel->link_error.parity = FALSE;
		}
		if (reg & COMM_STATUS_LINK_ESC_ERR_MASK) {
			channel->link_error.escape = TRUE;
		} else {
			channel->link_error.escape = FALSE;
		}
		if (reg & COMM_STATUS_LINK_CRED_ERR_MASK) {
			channel->link_error.credit = TRUE;
		} else {
			channel->link_error.credit = FALSE;
		}

		status = TRUE;
	}

	return status;
}

bool comm_update_link_status(comm_channel_t *channel) {
	bool status = FALSE;
	alt_u32 reg = 0;

	if (channel != NULL) {
		reg = read_reg(channel->channel_address,
		COMM_WINDOWING_STATUS_REG_OFFSET);

		if (reg & COMM_STATUS_LINK_STARTED_MASK) {
			channel->link_status.started = TRUE;
		} else {
			channel->link_status.started = FALSE;
		}
		if (reg & COMM_STATUS_LINK_CONNECTING_MASK) {
			channel->link_status.connecting = TRUE;
		} else {
			channel->link_status.connecting = FALSE;
		}
		if (reg & COMM_STATUS_LINK_RUNNING_MASK) {
			channel->link_status.running = TRUE;
		} else {
			channel->link_status.running = FALSE;
		}

		status = TRUE;
	}

	return status;
}

bool comm_update_timecode_rx(comm_channel_t *channel) {
	bool status = FALSE;
	alt_u32 reg = 0;

	if (channel != NULL) {
		reg = read_reg(channel->channel_address,
		COMM_TIMECODE_RX_REG_OFFSET);

		channel->timecode_rx.control = (alt_u8) ((reg
				& COMM_TIMECODE_RX_CONTROL_MASK) >> 7);
		channel->timecode_rx.counter = (alt_u8) ((reg
				& COMM_TIMECODE_RX_COUNTER_MASK) >> 1);
		if (reg & COMM_TIMECODE_RX_RECEIVED_MASK) {
			channel->timecode_rx.received = TRUE;
		} else {
			channel->timecode_rx.received = FALSE;
		}

		status = TRUE;
	}

	return status;
}

bool comm_clear_timecode_rx_received(comm_channel_t *channel) {
	bool status = FALSE;
	alt_u32 reg = 0;

	if (channel != NULL) {
		reg = COMM_TIMECODE_RX_RECEIVED_MASK;

		write_reg(channel->channel_address, COMM_TIMECODE_RX_REG_OFFSET, reg);
		status = TRUE;
	}

	return status;
}

bool comm_send_timecode_tx(comm_channel_t *channel) {
	bool status = FALSE;
	alt_u32 reg = 0;

	if (channel != NULL) {
		reg |= (alt_u32) (channel->timecode_tx.control << 7);
		reg |= (alt_u32) (channel->timecode_tx.counter << 1);
		if (channel->timecode_tx.send) {
			reg |= COMM_TIMECODE_TX_SEND_MASK;
		} else {
			reg &= (~COMM_TIMECODE_TX_SEND_MASK);
		}

		write_reg(channel->channel_address, COMM_TIMECODE_TX_REG_OFFSET, reg);
		status = TRUE;
	}

	return status;
}

bool comm_update_timecode_tx(comm_channel_t *channel) {
	bool status = FALSE;
	alt_u32 reg = 0;

	if (channel != NULL) {
		reg = read_reg(channel->channel_address,
		COMM_TIMECODE_TX_REG_OFFSET);

		channel->timecode_tx.control = (alt_u8) ((reg
				& COMM_TIMECODE_TX_CONTROL_MASK) >> 7);
		channel->timecode_tx.counter = (alt_u8) ((reg
				& COMM_TIMECODE_TX_COUNTER_MASK) >> 1);
		if (reg & COMM_TIMECODE_TX_SEND_MASK) {
			channel->timecode_tx.send = TRUE;
		} else {
			channel->timecode_tx.send = FALSE;
		}

		status = TRUE;
	}

	return status;
}

bool comm_update_buffers_status(comm_channel_t *channel) {
	bool status = FALSE;
	alt_u32 reg = 0;

	if (channel != NULL) {
		reg = read_reg(channel->channel_address,
		COMM_WINDOWING_BUFFER_REG_OFFSET);

		if (reg & COMM_BUFFER_STATUS_LEFT_BUFFER_EMPTY_MASK) {
			channel->buffer_status.left_buffer_empty = TRUE;
		} else {
			channel->buffer_status.left_buffer_empty = FALSE;
		}
		if (reg & COMM_BUFFER_STATUS_RIGHT_BUFFER_EMPTY_MASK) {
			channel->buffer_status.right_buffer_empty = TRUE;
		} else {
			channel->buffer_status.right_buffer_empty = FALSE;
		}

		status = TRUE;
	}

	return status;
}

bool comm_init_channel(comm_channel_t *channel, alt_u8 spw_channel) {
	bool status = FALSE;

	if (channel != NULL) {
		status = TRUE;

		switch (spw_channel) {
		case spacewire_channel_a:
			channel->channel_address = (alt_u32 *) COMM_CHANNEL_A_BASE_ADDR;
			break;
		case spacewire_channel_b:
			channel->channel_address = (alt_u32 *) COMM_CHANNEL_B_BASE_ADDR;
			break;
		case spacewire_channel_c:
			channel->channel_address = (alt_u32 *) COMM_CHANNEL_C_BASE_ADDR;
			break;
		case spacewire_channel_d:
			channel->channel_address = (alt_u32 *) COMM_CHANNEL_D_BASE_ADDR;
			break;
		case spacewire_channel_e:
			channel->channel_address = (alt_u32 *) COMM_CHANNEL_E_BASE_ADDR;
			break;
		case spacewire_channel_f:
			channel->channel_address = (alt_u32 *) COMM_CHANNEL_F_BASE_ADDR;
			break;
		case spacewire_channel_g:
			channel->channel_address = (alt_u32 *) COMM_CHANNEL_G_BASE_ADDR;
			break;
		case spacewire_channel_h:
			channel->channel_address = (alt_u32 *) COMM_CHANNEL_H_BASE_ADDR;
			break;
		default:
			status = FALSE;
			break;
		}

		if (status) {
			if (!comm_update_windowing(channel)) {
				status = FALSE;
			}
			if (!comm_update_link(channel)) {
				status = FALSE;
			}
			if (!comm_update_link_error(channel)) {
				status = FALSE;
			}
			if (!comm_update_link_status(channel)) {
				status = FALSE;
			}
			if (!comm_update_timecode_rx(channel)) {
				status = FALSE;
			}
			if (!comm_update_timecode_tx(channel)) {
				status = FALSE;
			}
			if (!comm_update_int_control(channel)) {
				status = FALSE;
			}
			if (!comm_update_int_flags(channel)) {
				status = FALSE;
			}
			if (!comm_update_buffers_status(channel)) {
				status = FALSE;
			}
		}
	}
	return status;
}
//! [public functions]

//! [private functions]
static void write_reg(alt_u32 *address, alt_u32 offset, alt_u32 value) {
	*(address + offset) = value;
}

static alt_u32 read_reg(alt_u32 *address, alt_u32 offset) {
	alt_u32 value;

	value = *(address + offset);
	return value;
}
//! [private functions]

