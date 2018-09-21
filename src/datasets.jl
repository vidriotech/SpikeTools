module Datasets

import NPZ: npzread

export Probe, probefromphy, channelmap, channelpositions, nchannels

include("datasets/probe.jl")
include("datasets/recording.jl")
include("datasets/trials.jl")
include("datasets/sorting.jl")
include("datasets/dataset.jl")

end # module
