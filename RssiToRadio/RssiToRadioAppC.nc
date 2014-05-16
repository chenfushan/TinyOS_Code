#include <Timer.h>
#include "RssiToRadio.h"

configuration RssiToRadioAppC {
}
implementation {
	components MainC;
//	components Leds;
	components RssiToRadioC as App;
	components new TimerMilliC() as Timer0;
	components ActiveMessageC;
	components new AMSenderC(AM_DATA_MSG);
//	components new AMReceiver(AM_DATA_MSG);
	components CC2420ActiveMessageC;

	App.Boot -> MainC;
//	App.Leds -> Leds;
	App.Timer0 -> Timer0;
	App.Packet -> AMSenderC;
	App.AMPacket -> AMSenderC;

	App.AMControl -> ActiveMessageC;
	App.AMSend -> AMSenderC;
//	App.AMReceive -> AMReceiverC;
	App.CC2420Packet -> CC2420ActiveMessageC;
}
