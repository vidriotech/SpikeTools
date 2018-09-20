module ProbeTools

import NPZ: npzread, npzwrite

export Probe, fromphy, channelmap, channelpositions, nchannels

include("probetools/probe.jl")

end # module
