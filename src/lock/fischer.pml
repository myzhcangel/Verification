#define N 6 

int turn = -1; 
int num_block = 0;
int count = 0;

active [N] proctype P() { 
Start:
    // Request lock
    atomic {
        (turn == -1) -> num_block++
    }
    atomic {
        turn = _pid;
        num_block--
    }
    (num_block == 0);
    if
    :: atomic {turn == _pid -> count++;}
    :: else -> goto Start
    fi

    // Critical section
    assert(count == 1);
    count--;

    // Release lock
    turn = -1;
}