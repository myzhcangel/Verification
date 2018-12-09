#define N 5    // Number of threads
int gate[N], last[N], count = 0;

active [N] proctype user()
{    
    int k;

    // Request lock
    k = 1;
    do
    :: k < N ->
        gate[_pid] = k;
        last[k] = _pid;
        int j = 0;
        do
        :: j < N ->
            !((j != _pid) && (gate[j] >= k) && (last[k] == _pid));
            j++;
        :: else -> break
        od;
        k++
    :: else -> break
    od;

    // Critical section
    count++;
    assert(count == 1);
    count--;

    // Release lock
    gate[_pid] = 0;
}