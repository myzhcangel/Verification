public class Fischer implements Lock { 
    int N;
    int turn; 
    int delta;
    public Fischer (int numProc) { 
        N = numProc;
        turn = -1;
        delta = 5;
    }
    public void requestCS(int i) {
        while (true) {
            while (turn != -1) {};
            turn = i;
            try {
                Thread.sleep(delta);
            } catch (InterruptedException e) {};
            if (turn == i) return;
        }
    }
    public coid releaseCS(int i) {
        turn = -1;
    }
}