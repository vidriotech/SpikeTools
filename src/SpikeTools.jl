module SpikeTools

export Annotations
export Datasets

include("datasets.jl")
include("annotations.jl")

import .Datasets: Probe, probefromphy, probefromspikeglx, channelmap, channelpositions, modelname, nchannels
import .Datasets: readspikeglxmeta, recfromspikeglx
export Probe, probefromphy, probefromspikeglx, channelmap, channelpositions, modelname, nchannels
export readspikeglxmeta, recfromspikeglx

import .Annotations: clusters, clustertimes, nclusters, nspikes, probe, spikeclusters,
                     spikecounts, spiketimes
import .Annotations: KilosortAnnotation, loadkilosort, amplitudes, similartemplates,
                     spiketemplates, templates
export clusters, clustertimes, nclusters, nspikes, probe, spikeclusters, spiketimes
export KilosortAnnotation, loadkilosort, amplitudes, similartemplates,
       spiketemplates, templates

end # module
