configuration TaskApp
{
}
implementation
{
	components MainC, TaskC, LedsC;
	components new TimerMilliC() as Timer0;
	components new TimerMilliC() as Timer1;
	components new TimerMilliC() as Timer2;

	TaskC-> MainC.Boot;

	TaskC.Timer0 -> Timer0;
	TaskC.Timer1 -> Timer1;
	TaskC.Timer2 -> Timer2;
	TaskC.Leds -> LedsC;
}
