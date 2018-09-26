module SpikeMetrics

import ..Datasets: Annotation, clusters, clustertimes, nclusters, nspikes,
                   spikeclusters, spikecounts, spiketimes
import ..Datasets: TemplateAnnotation, KilosortAnnotation, amplitudes,
                   similartemplates, spiketemplates, templates

export isi

include("spikemetrics/groundtruth.jl")
include("spikemetrics/biophysical.jl")
include("spikemetrics/quality.jl")

end # module
