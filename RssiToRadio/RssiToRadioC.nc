#include "Timer.h"
#include "RssiToRadio.h"
#include "pr.h"

module RssiToRadioC{
	uses interface Boot;
	uses interface Leds;
	uses interface Timer<TMilli> as Timer0;
	uses interface Packet;

	uses interface AMSend;
//	uses interface Receive;
	uses interface SplitControl as AMControl;

	uses interface CC2420Packet;

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
			call Timer0.startPeriodic(TIMER_PERIOD_MLLI);
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
			DATA_MSG *dm = (DATA_MSG*)(call Packet.getPayload(&pkt, sizeof(DATA_MSG)));
			call CC2420Packet.setPower(&pkt, SET_POWER);
			dm->nodeid = TOS_NODE_ID;
			if (call AMSend.send(AM_BROADCAST_ADDR, &pkt, sizeof(DATA_MSG)) == SUCCESS)
			{
				pr("call send success!\n");
				busy = TRUE;
			}
		}
	}

	event void AMSend.sendDone(message_t* msg,error_t err){
		if(&pkt == msg){
			pr("send done!\n");
			busy = FALSE;
		}
	}


}