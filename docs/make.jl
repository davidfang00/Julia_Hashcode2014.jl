using Julia_Hashcode2014
using Documenter

DocMeta.setdocmeta!(
    Julia_Hashcode2014, :DocTestSetup, :(using Julia_Hashcode2014); recursive=true
)

makedocs(;
    modules=[Julia_Hashcode2014],
    authors="David Fang and contributors",
    repo="https://github.com/davidfang/Julia_Hashcode2014.jl/blob/{commit}{path}#{line}",
    sitename="Julia_Hashcode2014.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true", edit_link="main", assets=String[]
    ),
    pages=["Home" => "index.md"],
)
