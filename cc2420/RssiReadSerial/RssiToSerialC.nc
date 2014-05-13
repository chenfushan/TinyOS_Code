/*
* @author chenfushan
* write in 2014/05/06
*/

#include "RssiToSerial.h"

configuration RssiToSerialC {}

implementation {
	components MainC, RssiToSerialP as App, LedsC;
	components new TimerMilliC();
	components SerialActiveMessageC as AM;
	components ActiveMessageC;
	components CC2420ControlC;
	components new AMReceiverC(AM_RADIO_COUNT_MSG);
	components CC2420ActiveMessageC;

	App.Boot -> MainC.Boot;
	App.SerialControl -> AM;
//	App.AMSend -> AM.AMSend[AM_RSSI_SERIAL_MSG];
	App.AMControl -> ActiveMessageC;
	App.Leds -> LedsC;
	App.Packet -> AM;
	App.ReadRssi -> CC2420ControlC.ReadRssi;
	App.Config -> CC2420ControlC.CC2420Config;
	App.Receive -> AMReceiverC;
	App.CC2420Packet -> CC2420ActiveMessageC;
}