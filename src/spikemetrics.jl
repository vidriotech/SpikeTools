module SpikeMetrics

import ..Annotations: Annotation, clusters, clustertimes, nclusters, nspikes, probe,
                      spikeclusters, spikecounts, spiketimes
import ..Annotations: KilosortAnnotation, amplitudes, similartemplates,
                      spiketemplates, templates

export isi

include("spikemetrics/groundtruth.jl")
include("spikemetrics/biophysical.jl")
include("spikemetrics/quality.jl")

end # module
