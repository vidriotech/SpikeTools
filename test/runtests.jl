using SpikeTools
using Test

using DotEnv

DotEnv.config()

include("testprobe.jl")
include("testannotations.jl")
