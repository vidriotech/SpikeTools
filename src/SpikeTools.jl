module SpikeTools

export ProbeTools

include("probetools.jl")

import .ProbeTools: Probe
export Probe

end # module
