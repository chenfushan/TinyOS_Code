COMPONENT=BlinkToRadioAppC
CFLAGS += -DCC2420_DEF_CHANNEL=23
CFLAGS += -DCC2420_DEF_RFPOWER=31
BUILD_EXTRA_DEPS += RssiFromRadio.class
CLEAN_EXTRA = *.class RssiFromRadioMsg.java

CFLAGS += -I$(TOSDIR)/lib/T2Hack

RssiFromRadio.class: $(wildcard *.java) RssiFromRadioMsg.java
	javac -target 1.4 -source 1.4 *.java
RssiFromRadioMsg.java:
	mig java -target=null $(CFLAGS) -java-classname=RssiFromRadioMsg RssiFromRadio.h RssiFromRadioMsg -o $@
include $(MAKERULES)

