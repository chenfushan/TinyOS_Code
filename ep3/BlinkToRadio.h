#ifndef BLINKTORADIO_H
#define BLINKTORADIO_H

enum{
	AM_BLINKTORADIO=6;
	TIMER_PERIOD_MILLI=500;
	SET_POWER=15;
};

typedef nx_struct BlinkToRadioMsg{
	nx_uint16_t node_id;
	nx_uint8_t power;
	nx_int8_t rssi;
	nx_uint8_t lqi;
} BlinkToRadioMsg;

#endif
