#define NUM_OF_PROCESSES 2

byte counter = 0;
byte progress[NUM_OF_PROCESSES];

proctype incrementer(byte me)
{
	int temp;

	atomic {
		temp = counter;
		counter = temp + 1;
	}
	
	progress[me] = 1;
 }
 
init {
	int i = 0;
	int sum = 0;

 	atomic {
		i = 0;
		do
		:: i < NUM_OF_PROCESSES ->
			progress[i] = 0;
			run incrementer(i);
			i++
		:: i >= NUM_OF_PROCESSES -> break
		od
	}


    i = 0;
    bool flag = 1;
    do
    :: i < NUM_OF_PROCESSES ->
      	flag = flag & progress[i];
       	i++
    :: i >= NUM_OF_PROCESSES -> break
    od;

    assert(!flag || counter == NUM_OF_PROCESSES)
}

