#include "single_lock.model"
bool writing = false;
short readers = 0;
short writersWaiting = 0;

proctype reader() {
	/* startRead */
	synchronized();
	do
	:: (writing || writersWaiting>0) -> wait();
	:: else -> break;
	od
	readers = readers + 1;
	exit_synchronized();

	assert(readers > 0); // Assertion RW.1
	assert(!writing); // Assertion RW.2

	/* endRead */
	synchronized();
	readers = readers - 1;
	if
	:: (readers == 0) -> notifyAll();
	:: else -> skip;
	fi;
	exit_synchronized();
}

proctype writer() {
	/* startWrite */
	synchronized();
	writersWaiting = writersWaiting + 1;
	do
	:: (writing || readers != 0) -> wait();
	:: else -> break;
	od
	writing = true;
	writersWaiting = writersWaiting - 1;
	exit_synchronized();

	assert(writing); // Assertion RW.3
	assert(readers == 0); // Assertion RW.4

	/* endWrite */
	synchronized();
	writing = false;
	notifyAll();
	exit_synchronized();
}

// system
init {
	run reader(); run reader();
	run writer(); run writer();
}