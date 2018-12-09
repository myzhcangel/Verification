import java.util.Arrays;

class PetersonN implements Lock { 
    int N;
    int[] gate;
    int[] last;
    public PetersonN(int numProc) {
        N = numProc;
        gate = new int[N];
        Arrays.fill(gate, 0);
        last = new int[N];
        Arrays.fill(last, 0);
    }
    public void requestCS(int i) { 
        for (int k = 1;k < N;k++) {
            gate[i] = k;
            last[k] = i;
            for (int j = 0; j < N; j++) {
                while (( j != i ) && (gate[j] >= k) && (last[k] == i)) {};
            } 
        } 
    }
    public void releaseCS(int i) {
        gate[i] = 0;
    }
}