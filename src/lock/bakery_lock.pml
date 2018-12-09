#define N 4 // Number of threads

bool choosing[N];
int number[N], count = 0;

active [N] proctype user() {
    // Request lock
    choosing[_pid] = 1;
    int i = 0;
    do
    :: i < N->
        if
        :: number[i] > number[_pid] -> number[_pid] = number[i];
        :: else -> skip
        fi
        i++
    :: else -> break
    od
    number[_pid]++;
    choosing[_pid] = 0;

    i = 0;
    do
    :: i < N ->
        (choosing[i] == 0)
        !((number[i] != 0) && (number[i] < number[_pid] || (number[i] == number[_pid] && i < _pid)))
        i++
    :: else -> break
    od

    // Critical Section
    count++;
    assert(count == 1);
    count--;

    // Release lcok
    number[_pid] = 0;
}