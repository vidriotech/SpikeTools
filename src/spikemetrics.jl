module SpikeMetrics

import ..Datasets: probe, recordings, samplerate, trials
import ..Datasets: Annotation, clusters, clustertimes, dataset, nclusters, nspikes,
                   spikeclusters, spikecounts, spiketimes
import ..Datasets: JRCLUSTAnnotation
import ..Datasets: TemplateAnnotation, KilosortAnnotation, amplitudes,
                   similartemplates, spiketemplates, templates

export isifraction

include("spikemetrics/groundtruth.jl")
include("spikemetrics/biophysical.jl")
include("spikemetrics/quality.jl")

end # module
