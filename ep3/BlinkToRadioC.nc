#include <Timer.h>
#include "BlinkToRadio.h"
#include "pr.h"

module BlinkToRadioC {
	uses{
		interface Boot;
		interface Leds;
		interface Timer<TMilli> as Timer0;
		interface Packet;
		interface AMSend;
		interface Receive;
		interface SplitControl as AMControl;
		interface CC2420Packet;
	}
}

implementation{

	message_t pkt;
	bool busy = FALSE;

	event void Boot.booted(){
		call AMControl.start();
	}

	event void AMControl.startDone(error_t err){
		if (err == SUCCESS)
		{
			call Timer0.startPeriodic(TIMER_PERIOD_MILLI);
			pr("start done!\n");
		}else{
			call AMControl.start();
		}
	}

	event void AMControl.stopDone(error_t err){
		pr("stop done!\n");
	}
	
	event void Timer0.fired(){
		if (!busy)
		{
			BlinkToRadioMsg* btrpkt = (BlinkToRadioMsg*)(call Packet.getPayload(&pkt, sizeof(BlinkToRadioMsg)));
			if (btrpkt == NULL)
			{
				pr("can not creatbtr");
				return;
			}
			btrpkt->nodeid = TOS_NODE_ID;
			btrpkt->power = (call CC2420Packet.setPower(&pkt,SET_POWER));
			if (call AMSend.send(AM_BROADCAST_ADDR, &pkt, sizeof(BlinkToRadioMsg)) == SUCCESS){
				pr("call send\n");
				busy = TRUE;
			}
		}
	}	

	event void AMSend.sendDone(message_t* msg, error_t err){
		if (&pkt == msg)
		{
			busy = FALSE;
		}
	}

}