#define N 10

int buffer[N];
int in_buffer = 0;
int out_buffer = 0;
int current_number = 0;
int data = 0;

active proctype producer() {
    int i = 0;
    do
    :: i < 100 -> (current_number < N);
        buffer[in_buffer] = data;
        data++;
        in_buffer = (in_buffer + 1) % N;
        current_number++;
        i++;
    :: else -> break
    od
}

active proctype consumer() {
    int i = 0;
    do
    :: i < 100 -> (current_number > 0);
        int value = buffer[out_buffer];
        out_buffer = (out_buffer + 1) % N;
        printf("Consume: %d\n", value);
        current_number--;
        i++;
    :: else -> break
    od
}

active proctype monitor() {
    assert(0 <= current_number);
    assert(current_number <= N);
}