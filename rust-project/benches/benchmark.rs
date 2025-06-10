// This file contains benchmarks for the project. It is used to measure the performance of specific functions or features.

#[cfg(test)]
mod benchmarks {
    use super::*;
    use criterion::{criterion_group, criterion_main, Criterion};

    fn benchmark_function(c: &mut Criterion) {
        c.bench_function("example_benchmark", |b| b.iter(|| {
            // Call the function you want to benchmark here
            // e.g., your_function();
        }));
    }

    criterion_group!(benches, benchmark_function);
    criterion_main!(benches);
}