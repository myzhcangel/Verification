#define SIZE 6
#define MESSAGES 4
mtype = { message, marker };
chan ch = [SIZE] of { mtype, byte };
byte lastSent, lastReceived, messageAtRecord, messageAtMarker;
bool recorded;



active proctype Sender() {
	do
	:: lastSent < MESSAGES ->
            lastSent++;
            ch ! message(lastSent)
    :: ch ! marker(0) ->
    break
	od
}

active proctype Receiver() { 
	byte received;
	do
	:: ch ? message(received) ->
		assert (received == (lastReceived+1))  //added
		lastReceived = received 
	:: ch ? marker(_) ->
		messageAtMarker = lastReceived;
		if
		:: !recorded ->
			messageAtRecord = lastReceived
		:: else 
		fi; 
		break
	:: !recorded ->
		messageAtRecord = lastReceived; 
		recorded = true
	od
	assert (lastSent == messageAtMarker) //added
	assert (messageAtRecord <= messageAtMarker) //added
}

