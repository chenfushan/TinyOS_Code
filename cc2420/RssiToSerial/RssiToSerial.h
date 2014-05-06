/*
* @author chenfushan
*/

##ifndef RSSI_TO_SERIAL_H
#define RSSI_TO_SERIAL_H

typedef nx_struct rssi_serial_msg{
	nx_uint16_t rssiAvgValue;
	nx_uint16_t rssiLargestValue;
	nx_uint8_t channel;
}rssi_serial_msg_t;

enum  { 
	AM_RSSI_SERIAL_MSG = 134;
	WAIT_TIME = 256;
	LOG2SAMPLES = 7;
 };

#endif