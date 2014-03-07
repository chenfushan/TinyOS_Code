/*
* Author: Alps1992
* 2014/03/07
* test tinyos 
*/ 

configuration AlpsApp
{
}
implementation
{
	components MainC, Alps, LedsC;
	components new TimerMilliC() as Timer0;
/*
	components new TimerMilliC() as Timer1;
	components new TimerMilliC() as Timer3;
*/

	Alps-> MainC.Boot;

	Alps.Timer0 -> Timer0;
/*
	Alps.Timer1 -> Timer1;
	Alps.Timer3 -> Timer3;
*/
	Alps.Leds -> LedsC;
}

