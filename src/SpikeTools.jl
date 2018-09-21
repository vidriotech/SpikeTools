module SpikeTools

export Annotations
export ProbeTools

include("probetools.jl")
include("annotations.jl")

import .Annotations: clusters, nclusters, nspikes, probe, spikeclusters, spiketimes
import .Annotations: KilosortAnnotation, loadkilosort, amplitudes, similartemplates,
                     spiketemplates, templates
export clusters, nclusters, nspikes, probe, spikeclusters, spiketimes
export KilosortAnnotation, loadkilosort, amplitudes, similartemplates,
       spiketemplates, templates

import .ProbeTools: Probe
export Probe

end # module
