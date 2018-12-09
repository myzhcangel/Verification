# Verification on Multi-threaded Programs

In the original_models folder, we put all the original algorithms or models here. Our SPIN models are bulit based on these original algorithms.

In the src folder, we put all the SPIN models that we bulit here.

1) src/lock includes several lock models: Peterson's lock, PetersonN's lock, Lamport's bakery lock and Fischer's lock.
2) src/stack_and_queue includes concurrent lock-based stack and queue models.
3) classic_models includes: ReaderAndWriter, DiningPhilosophers and ProducerAndConsumer models.
4) case_study includes some experiments related to deadlock, starvation and combination verification.

## How to run

In macOS, using homebrew to install SPIN
```
brew install spin
```
Then for each pml model file, run it using
```
spin -run file_name.pml
```
To trace the counter-example, run
```
spin -p -t file_name.pml
```