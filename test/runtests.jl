using SpikeTools
using Test

using DotEnv

DotEnv.config()

using Dates
using Glob

include("testdatasets.jl")
include("testannotations.jl")
