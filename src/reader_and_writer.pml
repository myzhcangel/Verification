int num_readers = 0;
int num_writers = 0;
int lock_pid = -1;
int mutex_lock = -1;

inline get_lock() {
	atomic {
		(lock_pid == -1) -> lock_pid = _pid;
	}
}

inline release_lock() {
	atomic {
		lock_pid = -1;
	}
}

inline mutex_get_lock() {
	atomic {
		(mutex_lock == -1) -> mutex_lock = _pid;
	}
}

inline mutex_release_lock() {
	atomic {
		mutex_lock = -1;
	}
}

active [4] proctype read() {

	// Start reading
	mutex_get_lock();
	if
	:: (num_readers == 0) -> get_lock();
	:: else -> skip;
	fi
	num_readers++;
	mutex_release_lock();

	// Critical Section
	assert(num_readers > 0);
	assert(num_writers == 0);

	// End reading
	mutex_get_lock();
	num_readers--;
	if
	:: (num_readers == 0) -> release_lock();
	:: else ->skip;
	fi
	mutex_release_lock();
}

active [2] proctype write() {

	// Start writing
	get_lock();

	// Critical Section
	num_writers++;
	assert(num_writers == 1);
	assert(num_readers == 0);
	num_writers--;

	// End writing
	release_lock();
}