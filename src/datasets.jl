module Datasets

import NPZ: npzread

export Probe, probefromjrclust, probefromphy, probefromrezfile, probefromspikeglx,
       channelmap, channelpositions, modelname, nchannels
export Recording, recordingfromspikeglx, recordingfromrezfile, binarypath, fsizebytes,
       nstoredchannels, probe, recordedby, recordedon, samplerate
export Trial, trialfromspikeglx, trialfromrezfile, runtimesecs, starttimesecs
export Dataset, datasetfromspikeglx, recordings, trials
export Sorting, sortingfromjrclust, sortingfromrezfile, dataset, programused,
       programversion, runtimesecs, sortedby, sortedon

include("datasets/utils.jl")
include("datasets/probe.jl")
include("datasets/recording.jl")
include("datasets/trial.jl")
include("datasets/dataset.jl")
include("datasets/sorting.jl")

end # module
