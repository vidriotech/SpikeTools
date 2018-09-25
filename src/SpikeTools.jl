module SpikeTools

export Annotations
export Datasets

include("datasets.jl")
include("annotations.jl")

import .Datasets: Probe, probefromjrclust, probefromphy, probefromrezfile, probefromspikeglx,
                  channelmap, channelpositions, modelname, nchannels
import .Datasets: Recording, recordingfromspikeglx, recordingfromrezfile, binarypath, fsizebytes,
                  nstoredchannels, recordedby, recordedon, samplerate
import .Datasets: Trial, trialfromspikeglx, trialfromrezfile, runtimesecs, starttimesecs
import .Datasets: Dataset, datasetfromspikeglx, recordings, trials
import .Datasets: Sorting, sortingfromjrclust, sortingfromrezfile, dataset, programused,
                  programversion, runtimesecs, sortedby, sortedon

import .Annotations: clusters, clustertimes, nclusters, nspikes, spikeclusters,
                     spikecounts, spiketimes
import .Annotations: KilosortAnnotation, loadkilosort, amplitudes, similartemplates,
                     spiketemplates, templates

export Probe, probefromjrclust, probefromphy, probefromrezfile, probefromspikeglx,
       channelmap, channelpositions, modelname, nchannels
export Recording, recordingfromspikeglx, recordingfromrezfile, binarypath, fsizebytes,
       nstoredchannels, recordedby, recordedon, samplerate
export Trial, trialfromspikeglx, trialfromrezfile, runtimesecs, starttimesecs
export Dataset, datasetfromspikeglx, recordings, trials
export Sorting, sortingfromjrclust, sortingfromrezfile, dataset, programused,
       programversion, runtimesecs, sortedby, sortedon

export clusters, clustertimes, nclusters, nspikes, spikeclusters, spiketimes
export KilosortAnnotation, loadkilosort, amplitudes, similartemplates,
       spiketemplates, templates

end # module
