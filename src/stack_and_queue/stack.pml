#define N 5

chan flag = [N] of {bit};
int concurrent_stack[N];
int output[N];
int data = 0;
int top = 0;
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

active [N] proctype push() {
    get_lock();
    concurrent_stack[top] = data;
    top++;
    data++;
    flag!0;
    release_lock();
}

active [N] proctype pop() {
    get_lock();
    wait();

    assert(top > 0);
    top--;
    int value = concurrent_stack[top];
    concurrent_stack[top] = 0;
    output[value] = N;
    release_lock();
}

active proctype monitor() {
    int i = 0;
    do
    :: i < N -> output[i] == N -> i++;
    :: else -> break
    od
}