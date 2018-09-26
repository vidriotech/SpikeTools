module SpikeTools

export Datasets

include("datasets.jl")

import .Datasets: Probe, probefromjrclust, probefromphy, probefromrezfile, probefromspikeglx,
                  channelmap, channelpositions, modelname, nchannels

import .Datasets: Recording, recordingfromspikeglx, recordingfromrezfile, binarypath, fsizebytes,
                  nstoredchannels, recordedby, recordedon, samplerate

import .Datasets: Trial, trialfromspikeglx, trialfromrezfile, runtimesecs, starttimesecs

import .Datasets: Dataset, datasetfromspikeglx, recordings, trials

import .Datasets: clusters, clustertimes, nclusters, nspikes, spikeclusters,
                  spikecounts, spiketimes
import .Datasets: JRCLUSTAnnotation, jrclustfrommat
import .Datasets: TemplateAnnotation, KilosortAnnotation, kilosortfromphy, kilosortfromrezfile,
                  amplitudes, similartemplates, spiketemplates, templates

import .Datasets: Sorting, sortingfromjrclust, sortingfromrezfile, autoannotation, dataset,
                  programused, programversion, runtimesecs, sortedby, sortedon

export Probe, probefromjrclust, probefromphy, probefromrezfile, probefromspikeglx,
       channelmap, channelpositions, modelname, nchannels
export Recording, recordingfromspikeglx, recordingfromrezfile, binarypath, fsizebytes,
       nstoredchannels, recordedby, recordedon, samplerate
export Trial, trialfromspikeglx, trialfromrezfile, runtimesecs, starttimesecs
export Dataset, datasetfromspikeglx, recordings, trials
export Sorting, sortingfromjrclust, sortingfromrezfile, autoannotation, dataset,
       programused, programversion, runtimesecs, sortedby, sortedon
export clusters, clustertimes, nclusters, nspikes, spikeclusters, spiketimes
export JRCLUSTAnnotation, jrclustfrommat
export TemplateAnnotation, KilosortAnnotation, kilosortfromphy, kilosortfromrezfile,
       amplitudes, similartemplates, spiketemplates, templates

end # module
