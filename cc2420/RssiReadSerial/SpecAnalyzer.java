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

	public static final short TOS_BCAST_ADDR = (short) 0xffff;
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

	/*
	* print the magnitude of the spectrum to stdoout
	* @param largest //the largest rssi value taken during the sample period
	* @param avg //the average rssi value taken during the sample period
	*/

	void updateSpectrum(int largest, int avg){
//		clearSpectrum();
		String bar="[";
		int size = (int) ((float) largest * (float) ((float) MAX_CHARACTERS/(float)(255)));

		for (int i = 0; i < size && i < MAX_CHARACTERS; i++) {
			bar += "+";
		}

		for (int i = 0; i < (MAX_CHARACTERS - size); i++) {
			bar +=" ";
		}
bar += "]";

		lastCharsWritten = bar.length();
//		System.out.print(bar);
		System.out.print(largest+"-"+size+"/");
	}

	private static void usage(){
		System.err.println("usage: SpecAnalyzer [-comm <source>]");
	}

	/*
	*Main Method
	* @param args
	*/
	public static void main(String[] args) {
		String source = null;
		if (args.length == 2) {
			if (!args[0].equals("-comm")) {
				usage();
				System.exit(1);
			}
			source = args[1];
		}else if (args.length != 0) {
			usage();
			System.exit(1);
		}

		PhoenixSource phoenix;

		if (source == null) {
			phoenix = BuildSource.makePhoenix(PrintStreamMessenger.err);
		}else{
			phoenix = BuildSource.makePhoenix(source, PrintStreamMessenger.err);
		}

		MoteIF mif = new MoteIF(phoenix);
		new SpecAnalyzer(mif);
	}
}
