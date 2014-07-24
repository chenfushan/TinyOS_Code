#ifndef RSSIFROMRADIO
#define RSSIFROMRADIO 

enum  { 
	AM_DATA_MSG = 3,
	TIMER_PERIOD_MLLI = 500,
	SET_POWER = 31
 };

typedef nx_struct DATA_MSG{
	nx_uint16_t fromnodeid;
	nx_uint16_t tonodeid;
	nx_uint8_t power;
	nx_int8_t rssi;
	nx_uint8_t lqi;
}DATA_MSG;
#endif
