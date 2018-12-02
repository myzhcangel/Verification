//Fischer’s algorithm for the critical section problem
#define N 6 
#define DELAY1 2 
#define DELAY2 3

byte turn = 0; 
byte timer[N] = 0;

active [N] proctype P() { 
	start:
	do
	:: atomic {
		turn == 0 -> timer[_pid] = DELAY1
	}
	atomic { 
		if
		:: timer[_pid] > 0 ->
			turn = _pid+1;
			timer[_pid] = DELAY2 
		:: else -> goto start
		fi
	}
	atomic {
		timer[_pid] == 0 -> 
			if
			:: turn == _pid+1
			:: else -> goto start 
			fi
		}
		atomic {
       /* Critical section */
			turn = 0 
		}
	od
}








// //Mutual exclusion verification  
// // add variable critical

// #define N 6 
// #define DELAY1 2 
// #define DELAY2 3

// byte turn = 0; 
// byte timer[N] = 0;
// int critical = 0;

// active [N] proctype P() { 
// 	start:
// 	do
// 	:: atomic {
// 		turn == 0 -> timer[_pid] = DELAY1
// 	}
// 	atomic { 
// 		if
// 		:: timer[_pid] > 0 ->
// 			turn = _pid+1;
// 			timer[_pid] = DELAY2 
// 		:: else -> goto start
// 		fi
// 	}
// 	atomic {
// 		timer[_pid] == 0 ->
// 			if
// 				:: (turn == _pid+1) -> critical++;
// 				:: else -> goto start
// 				fi
// 	}

// 	atomic {
// 		assert (critical <= 1); 
// 		critical--;
// 		turn = 0
// 	}
// 	od
// }
