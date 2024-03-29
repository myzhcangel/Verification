#define N 5

chan flag = [N] of {bit};
int queue[N];
int head = 0;
int tail = 0;
int data = 0;
int output = 0;
int lock_pid = -1;

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

inline wait() {
    assert(lock_pid == _pid);
    atomic {
        release_lock();
        flag?0;
    }
    get_lock();
}

active [N] proctype enqueue() {
    get_lock();
    queue[tail] = data;
    tail++;
    data++;
    flag!0;
    release_lock();
}

active [N] proctype dequeue() {
    get_lock();
    wait();

    int value = queue[head];
    queue[head] = 0;
    head++;
    assert(value == output);
    output++;
    release_lock();
}