int turn = 1, count = 0, want_cs[2];

active [2] proctype user()
{
    assert(_pid == 0 || _pid == 1);
again:
    // Request lock
    want_cs[_pid] = 1;
    int j = 1 - _pid;
    turn = j;
    !(want_cs[j] == 1 && turn == j);

    // Critical section
    count++;
    assert(count == 1);
    count--;

    // Release lock
    want_cs[_pid] = 0;

    // Loop again
    goto again;   
}
