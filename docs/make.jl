using SU2
using Documenter

DocMeta.setdocmeta!(SU2, :DocTestSetup, :(using SU2); recursive=true)

makedocs(;
    modules=[SU2],
    authors="Paulo José Saiz Jabardo",
    repo="https://github.com/pjabardo/SU2.jl/blob/{commit}{path}#{line}",
    sitename="SU2.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)
