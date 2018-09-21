module Annotations

import NPZ: npzread
import ..ProbeTools: Probe, fromphy, channelmap

# generic annotation
export clusters, nclusters, nspikes, probe, spikeclusters, spiketimes
# kilosort annotation
export KilosortAnnotation, loadkilosort, amplitudes, similartemplates,
       spiketemplates, templates

include("annotations/generic.jl")
include("annotations/jrclust.jl")
include("annotations/phy.jl")

end # module
