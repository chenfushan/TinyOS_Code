/*
* @author chenfushan
* write in 2014/05/06
*/

#include "RssiTOSerial.h"

configuration RssiToSerialC {}

implementation {
	components MainC, RssiToSerialP as App, LedsC;
	components new TimerMilliC();
	components SerialActiveMessageC as AM;
	components ActiveMessageC;
	components CC2420ControlC;

	App.Boot -> MainC.Boot;
	App.SerialControl -> AM;
	App.AMSend -> AM.AMSend[AM_RSSI_SERIAL_MSG];
	App.AMControl -> ActiveMessageC;
	App.Leds -> LedsC;
	App.Packet -> AM;
	App.ReadRssi -> CC2420ControlC.ReadRssi;
	App.Config -> CC2420ControlC.CC2420Config;
}