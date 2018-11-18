# TuringBenchmarks 

This package has some benchmarking scripts for Turing. All models used here can be found in the `models` folder, all data can be found in the `data` folder, and all benchmarking scripts are in the `benchmarks` folder. 

Some data is generated via simulations found in the `simulations` folder. This data is generated when the package is built. When the package is built, `cmdstan` is also downloaded and setup where the URL can be accessed using `TuringBenchmarks.CMDSTAN_HOME`.

## How to contribute to TuringBenchmarks?

There are a number of ways to contribute to `TuringBenchmarks`:
1. Fix broken benchmarks.
2. Activate the inactive benchmarks by logging their results and using `send_log` to send the results to `TuringBot`.
3. Fix and activate the Stan benchmarks, any file in [benchmarks directory](https://github.com/TuringLang/TuringBenchmarks/tree/master/benchmarks) with `stan` in its name.
4. Add new benchmarks.

Both the broken and inactive benchmark file names can be found in https://github.com/TuringLang/TuringBenchmarks/blob/master/test/benchmarks.jl. The actual files can be found in https://github.com/TuringLang/TuringBenchmarks/tree/master/benchmarks.

## Guidelines for new benchmarks

1. Every benchmark makes a `log` `Dict` object which as the following mandatory keys:
 - `"name"`,
 - `"engine"`, and
 - "turing", where `log["turing"]` must have the key `"elapsed"`.
2. The `name`-`engine` combination must be unique for every benchmark.
3. The `log` `Dict` must be sent using the `send_log` function to activate the benchmark, otherwise results are not saved.
4. Every benchmark file must be runnable in its own Julia session. Any files which need to be executed first should be included in the benchmark file.
5. Since each benchmark is run in its own Julia session, any warm up runs should be included in the benchmark file to avoid counting the compilation time.
