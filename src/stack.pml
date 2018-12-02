#define MAX_SIZE 5

chan flag = [MAX_SIZE] of {bit};
int concurrent_stack[MAX_SIZE];
int output[MAX_SIZE];
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

active [MAX_SIZE] proctype push() {
	get_lock();
	concurrent_stack[top] = data;
	top++;
	data++;
	flag!0;
	release_lock();
}

active [MAX_SIZE] proctype pop() {
	get_lock();
	wait();

	assert(top > 0);
	top--;
	int value = concurrent_stack[top];
	concurrent_stack[top] = 0;
	output[value] = MAX_SIZE;
	release_lock();
}

active proctype monitor() {
	int i = 0;
	do
	:: i < MAX_SIZE -> 
		output[i] == MAX_SIZE ->
			i++;
	:: else -> break
	od
}