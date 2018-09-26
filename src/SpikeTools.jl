module SpikeTools

export Datasets

include("datasets.jl")
include("spikemetrics.jl")

import .Datasets: Probe, probefromjrclust, probefromphy, probefromrezfile, probefromspikeglx,
                  channelmap, channelpositions, modelname, nchannels

import .Datasets: Recording, recordingfromspikeglx, recordingfromrezfile, binarypath, fsizebytes,
                  nstoredchannels, recordedby, recordedon, samplerate

import .Datasets: Trial, trialfromspikeglx, trialfromrezfile, runtimesecs, starttimesecs

import .Datasets: Dataset, datasetfromjrclust, datasetfromrezfile, datasetfromspikeglx,
                  probe, recordings, trials

import .Datasets: Annotation, clusters, clustertimes, nclusters, nspikes, spikeclusters,
                  spikecounts, spiketimes
import .Datasets: JRCLUSTAnnotation, jrclustfrommat
import .Datasets: TemplateAnnotation, KilosortAnnotation, kilosortfromphy, kilosortfromrezfile,
                  amplitudes, similartemplates, spiketemplates, templates

import .Datasets: Sorting, sortingfromjrclust, sortingfromrezfile, autoannotation, dataset,
                  programused, programversion, runtimesecs, sortedby, sortedon

import .SpikeMetrics: isifraction

export Probe, probefromjrclust, probefromphy, probefromrezfile, probefromspikeglx,
       channelmap, channelpositions, modelname, nchannels
export Recording, recordingfromspikeglx, recordingfromrezfile, binarypath, fsizebytes,
       nstoredchannels, recordedby, recordedon, samplerate
export Trial, trialfromspikeglx, trialfromrezfile, runtimesecs, starttimesecs
export Dataset, datasetfromjrclust, datasetfromrezfile, datasetfromspikeglx, probe, recordings, trials
export Annotation, TemplateAnnotation, JRCLUSTAnnotation, KilosortAnnotation, clusters, clustertimes,
       nclusters, nspikes, spikeclusters, spikecounts, spiketimes, jrclustfrommat, kilosortfromphy,
       kilosortfromrezfile, amplitudes, similartemplates, spiketemplates, templates
export Sorting, sortingfromjrclust, sortingfromrezfile, autoannotation, dataset,
       programused, programversion, runtimesecs, sortedby, sortedon

export isifraction

end # module
