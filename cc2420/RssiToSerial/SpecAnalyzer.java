/*
* author chenfushan
* write in 2014/05/06
*/

import net.tinyos.message.Message;
import net.tinyos.message.MessageListener;
import net.tinyos.message.MoteIF;
import net.tinyos.message.SerialPacket;
import net.tinyos.packet.BuildSource;
import net.tinyos.packet.PhoenixSource;
import net.tinyos.util.PrintStreamMessenger;

public class SpecAnalyzer implements MessageListener {
	private MoteIF mote;
	/* Communication with the mote */

	public static final short TOS_BCAST_ADDR = (short) oxffff;
	// Broadcast Address

	private RssiSerialMsg rssiMsg;
	// the message from the mote

	private int lastCharsWritten = 0;
	//the total number of characters written last time

	private static final int MAX_CHARACTERS = 50;
	//the maximum size of the bar on the command line, in characters

	//Constructor
	public SpecAnalyzer(MoteIF mote){
		try{
			System.out.println("Connecting to serial forwarder ...");
			this.mote = mote;
			this.mote.registerListener(new RssiSerialMsg(), this);
		}catch(Exception e){
			System.err.println("Couldn't contact serial forwarder");
		}
	}

	//receive message from the mote
	synchronized public void messageReceived(int dest, Message m){
		rssiMsg = (RssiSerialMsg) m;
		updateSpectrum(rssiMsg.get_rssiLargestValue(), rssiMsg.get_rssiAvgValue());
	}


	//overwrite the current command line prompt with blank space
	void clearSpectrum(){
		for (int i = 0; i < lastCharsWritten; i++) {
			System.out.print('\b');
		}
	}

	






















}