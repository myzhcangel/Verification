#define NUM_OF_PROCESSES 4

bool choosing[NUM_OF_PROCESSES];
int number[NUM_OF_PROCESSES];
int count = 0;

proctype bakery_lock() {
	int id = _pid - 1;
	choosing[id] = 1;
	int i = 0;
	do
	:: i < NUM_OF_PROCESSES ->
		if
		:: number[i] > number[id] -> number[id] = number[i];
		:: else -> skip
		fi
		i++
	:: else -> break
	od
	number[id]++;
	choosing[id] = 0;

	i = 0;
	do
	:: i < NUM_OF_PROCESSES ->
		(choosing[i] == 0)
		!((number[i] != 0) && (number[i] < number[id] || (number[i] == number[id] && i < id)))
		i++
	:: else -> break
	od

	count++;
	assert(count == 1);
	count--;

	number[id] = 0;
}

init {
	atomic {
		int i = 0;
		do
		:: i < NUM_OF_PROCESSES -> 
			choosing[i] = 0;
			number[i] = 0;
			i++
		:: else -> break
		od
	}

	int i = 0;
	do
	:: i < NUM_OF_PROCESSES ->
		run bakery_lock();
		i++
	:: else -> break
	od
}