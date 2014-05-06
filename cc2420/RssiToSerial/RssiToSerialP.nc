/*
* @author chenfushan
* write in 2014/05/06
*/

#include "Timer.h"
#include "RssiToSerial.h"

module RssiToSerialP{
	uses{
		interface Leds;
		interface Boot;
		interface AMSend;
		interface SplitControl as AMControl;
		interface SplitControl as SerialControl;
		interface Packet;
		interface Read<uint16_t> as ReadRssi;
		interface CC2420Config as Config;
	}
}

implementation{
	message_t packet;
	bool locked;
	uint32_t total;
	uint16_t largest;
	uint16_t reads;
	/*******************Global Variables *****************/

	task void readRssi();
	task void sendSerialMsg();
	/******************Declare Tasks ****************/

	event void Boot.booted(){
		call AMControl.start();
		total = 0;
		largest = 0;
		reads = 0;
		locked = FALSE;
	}
	/*************** Boot Events *****************/

	event void AMControl.startDone(error_t err){
		if (err == SUCCESS)
		{
			call SerialControl.start();
		}else{
			call AMControl.start();
		}
	}
	/*************** AMControl Events *****************/

	event void AMControl.stopDone(error_t err){
		// do nothing
	}

	event void SerialControl.startDone(error_t err){
		if (err == SUCCESS)
		{
			post readRssi();
		}else{
			call AMControl.start();
		}
	}
	/**************** SerialControl Events ***************/

	event void SerialControl.stopDone(error_t err){
		// do nothing
	}

	event void AMSend.sendDone(message_t* bufPacket, error_t err){
		if (&packet == bufPacket)
		{
			locked = FALSE;
		}
		// post readRssi();
	}
	/*************** AMSend Events **********************/

	event void ReadRssi.readDone(error_t result, uint16_t val){
		if (result != SUCCESS)
		{
			post readRssi();
			return;
		}

		atomic{
			total += val;
			reads ++;
			if (largest < val)
			{
				largest = val;
			}
		}
		if (reads == (1<<LOG2SAMPLES))
		{
			post sendSerialMsg();
		}

		post readRssi();
	}
	/************* ReadRssi Events ************************/

	event void Config.syncDone(error_t error){

	}
/**************************************************************/
	task void readRssi(){
		if (call ReadRssi.read() != SUCCESS)
		{
			post readRssi();
		}
	}

	task void sendSerialMsg(){
		if (locked)
		{
			return;
		}else{
			rssi_serial_msg_t* rsm = (rssi_serial_msg_t*)call Packet.getPayload(&packet, sizeof(rssi_serial_msg_t));

			if (call Packet.maxPayloadLength() < sizeof(rssi_serial_msg_t)){
				return;
			}
			atomic{
				rsm->rssiAVgValue = (total >> (LOG2SAMPLES));
				rsm->rssiLargestValue = largest;
				total = 0;
				largest = 0;
				reads = 0;
			}
			rsm->channel = call Config.getChannel();
			if (call AMSend.send(AM_BROADCAST_ADDR, &packet, sizeof(rssi_serial_msg_t)) == SUCCESS)
			{
				locked = TRUE;
			}
		}
	}
	/***************** TASKS **********************/


}