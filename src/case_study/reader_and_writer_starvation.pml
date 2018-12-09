#include "lock.model"

int num_readers = 0;
int num_writers = 0;
int writing_lock_pid = -1;
int mutex_lock_pid = -1;

inline writing_lock() {
	atomic {
		(writing_lock_pid == -1) -> writing_lock_pid = _pid;
	}
}

inline writing_unlock() {
	atomic {
		writing_lock_pid = -1;
	}
}

proctype read() {

	// Start reading
	starvation_lock();
	if
	:: (num_readers == 0) -> writing_lock();
	:: else -> skip;
	fi
	num_readers++;
	starvation_unlock();

	// Critical Section
	assert(num_readers > 0);
	assert(num_writers == 0);

	// End reading
	starvation_lock();
	num_readers--;
	if
	:: (num_readers == 0) -> writing_unlock();
	:: else ->skip;
	fi
	starvation_unlock();
}

proctype write() {

	// Start writing
	writing_lock();

	// Critical Section
	num_writers++;
	assert(num_writers == 1);
	assert(num_readers == 0);
	num_writers--;

	// End writing
	writing_unlock();
}

init {
	run read();
	run write();
	run write();
}