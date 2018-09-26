module Datasets

import NPZ: npzread

export Probe, probefromjrclust, probefromphy, probefromrezfile, probefromspikeglx,
       channelmap, channelpositions, modelname, nchannels
export Recording, recordingfromspikeglx, recordingfromrezfile, binarypath, fsizebytes,
       nstoredchannels, recordedby, recordedon, samplerate
export Trial, trialfromspikeglx, trialfromrezfile, runtimesecs, starttimesecs
export Dataset, datasetfromjrclust, datasetfromrezfile, datasetfromspikeglx, probe, recordings, trials
# generic annotation
export Annotation, clusters, clustertimes, dataset, nclusters, nspikes, spikeclusters,
       spikecounts, spiketimes
# jrclust annotation
export JRCLUSTAnnotation, jrclustfrommat
# kilosort/template annotation
export TemplateAnnotation, KilosortAnnotation, kilosortfromphy, kilosortfromrezfile,
       amplitudes, similartemplates, spiketemplates, templates
export Sorting, sortingfromjrclust, sortingfromrezfile, autoannotation,
       programused, programversion, runtimesecs, sortedby, sortedon

include("datasets/utils.jl")
include("datasets/probe.jl")
include("datasets/recording.jl")
include("datasets/trial.jl")
include("datasets/dataset.jl")
include("datasets/annotation.jl")
include("datasets/sorting.jl")

end # module
