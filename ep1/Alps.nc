#include "Timer.h"

module Alps @safe()
{
	uses interface Timer<TMilli> as Timer0;
/*
	uses interface Timer<TMilli> as Timer1;
	uses interface Timer<TMilli> as Timer3;
*/
	uses interface Leds;
	uses interface Boot;
}
implementation
{
	event void Boot.booted()
	{
		call Timer0.startPeriodic( 1600 );
/*		call Timer1.startPeriodic( 800 );
		call Timer3.startPeriodic( 400 );
*/
	}
	uint32_t i = 0;
	uint32_t j = 0;
	event void Timer0.fired()
	{
		call Leds.led0Toggle();
		if(i > 0)
		{
			call Leds.led1Toggle();
			i = 0;
		}else{
			i=i+1;
		}
		if(j > 2){
			call Leds.led2Toggle();
			j = 0;
		}else{
			j=j+1;
		}	
	}
/*
	event void Timer1.fired()
	{
		call Leds.led1Toggle();
	}
	event void Timer3.fired()
	{
		call Leds.led2Toggle();
	}
*/
}

