/*
* Author "Alps1992"
* 2014/03/07
* use for test the task
*/

#include "Timer.h"

module TaskC @safe()
{
	uses interface Timer<TMilli> as Timer0;
	uses interface Timer<TMilli> as Timer1;
	uses interface Timer<TMilli> as Timer2;
	uses interface Leds;
	uses interface Boot;
}

implementation
{
	event void Boot.booted()
	{
		call Timer0.startPeriodic( 250 );
		call Timer1.startPeriodic( 500 );
		call Timer2.startPeriodic( 1000 );
	}

	uint32_t i = 0;
	task void computeTask()
	{
	uint32_t tmp = i;
		for(;i<tmp+5000&&i<400001; i++)
		{
/*		call Leds.led1Toggle(); */
			if(i > 400000)
			{
				i=0;
			}else{
			post computeTask();
			}
		}
	}

	event void Timer0.fired()
	{
/*		for(i = 0;i<5000; i++)*/
		call Leds.led0Toggle();
		post computeTask();

	}

	event void Timer1.fired()
	{
		call Leds.led1Toggle();
	}

	event void Timer2.fired()
	{
		call Leds.led2Toggle();
	}


}
