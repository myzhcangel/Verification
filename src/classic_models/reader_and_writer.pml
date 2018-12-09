#define READER_NUM 4
#define WRITER_NUM 2

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

inline mutex_lock() {
    atomic {
        (mutex_lock_pid == -1) -> mutex_lock_pid = _pid;
    }
}

inline mutex_unlock() {
    atomic {
        mutex_lock_pid = -1;
    }
}

active [READER_NUM] proctype read() {

    // Start reading
    mutex_lock();
    if
    :: (num_readers == 0) -> writing_lock();
    :: else -> skip;
    fi
    num_readers++;
    mutex_unlock();

    // Critical Section
    assert(num_readers > 0);
    assert(num_writers == 0);

    // End reading
    mutex_lock();
    num_readers--;
    if
    :: (num_readers == 0) -> writing_unlock();
    :: else ->skip;
    fi
    mutex_unlock();
}

active [WRITER_NUM] proctype write() {

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