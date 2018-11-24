using Pkg
println("Active project: ", Base.active_project())
Pkg.develop("https://github.com/TuringLang/Turing.jl")
Pkg.activate(splitdir(@__DIR__)[1])
Pkg.instantiate()

using HTTP, JSON, TuringBenchmarks

using TuringBenchmarks: snipsha, getturingpath, LOG_URL

juliaexe_path = joinpath(Sys.BINDIR, Base.julia_exename())
shas_filepath = abspath(joinpath("..", "src", "bench_shas.txt"))
if isfile(shas_filepath) && length(readlines(shas_filepath)) > 0
    shas = strip.(readlines(shas_filepath))
    branch_name = join(snipsha.(shas), "_")
    HTTP.open("POST", LOG_URL) do io
        write(io, JSON.json(Dict("start" => branch_name)))
    end
    for sha in shas
        cd(getturingpath()) do 
            run(`git checkout $sha`)
        end
        run(`$(juliaexe_path) -e 'include("benchmarks.jl"); runbenchmarks(send=true)'`)
    end
    HTTP.open("POST", LOG_URL) do io
        write(io, JSON.json(Dict("finish" => branch_name)))
    end
else
    run(`$(juliaexe_path) -e 'include("benchmarks.jl"); runbenchmarks(send=false)'`)
end
