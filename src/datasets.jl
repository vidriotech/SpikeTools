module Datasets

import NPZ: npzread

export Probe, probefromphy, probefromspikeglx, channelmap, channelpositions, nchannels
export readspikeglxmeta, recfromspikeglx

include("datasets/probe.jl")
include("datasets/recording.jl")
include("datasets/trials.jl")
include("datasets/sorting.jl")
include("datasets/dataset.jl")

end # module
