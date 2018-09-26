module Annotations

import NPZ: npzread
import ..Datasets: Probe, probefromphy, channelmap

# generic annotation
export Annotation, clusters, clustertimes, nclusters, nspikes, probe,
       spikeclusters, spikecounts, spiketimes
# kilosort annotation
export KilosortAnnotation, kilosortfromphy, amplitudes, similartemplates,
       spiketemplates, templates

include("annotations/generic.jl")
include("annotations/jrclust.jl")
include("annotations/phy.jl")

end # module
