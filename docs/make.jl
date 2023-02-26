using ItemResponsePlots
using Documenter

format = Documenter.HTML(
    prettyurls=get(ENV, "CI", "false") == "true",
    canonical="https://JuliaPsychometricsBazzar.github.io/ItemResponsePlots.jl",
)

makedocs(;
    modules=[ItemResponsePlots],
    authors="Frankie Robertson",
    repo="https://github.com/JuliaPsychometricsBazzar/ItemResponsePlots.jl/blob/{commit}{path}#{line}",
    sitename="ItemResponsePlots.jl",
    format=format,
    pages=[
        "Getting started" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/JuliaPsychometricsBazzar/ItemResponsePlots.jl",
    devbranch="main",
)
