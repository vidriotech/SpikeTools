using Glob

mutable struct Dataset
    probe::Probe                    # probe used in the recording
    recordings::Array{Recording, 1} # support multi-file recordings (single file in 1-element array)
    trials::Array{Trial, 1}         # trial data (can be empty)

    function Dataset(probe::Probe, recording::Recording, trial::Trial)
        new(probe, [recording], [trial])
    end

    function Dataset(probe::Probe, recordings::Array{Recording, 1}, trials::Array{Trial, 1})
        new(probe, recordings, trials)
    end
end

function datasetfromrezfile(rezfile::String; modelname::String="", recordedby::String="")
    probe = probefromrezfile(rezfile, modelname)
    recording = recordingfromrezfile(rezfile; recordedby=recordedby)
    trial = trialfromrezfile(rezfile)
    Dataset(probe, recording, trial)
end

"""
    datasetfromspikeglx(filename::String)

Construct a dataset from the SpikeGLX metafile representing it.
"""
function datasetfromspikeglx(filename::String; modelname::String="", recordedby::String="")
    probe = probefromspikeglx(filename, modelname)
    recording = recordingfromspikeglx(filename; recordedby=recordedby)
    trial = trialfromspikeglx(filename)

    Dataset(probe, recording, trial)
end

function datasetfromspikeglx(pattern::Glob.GlobMatch, prefix::String; modelname::String="", recordedby::String="")
    filenames = naturalsort(glob(pattern, prefix))
    probe = probefromspikeglx(filenames[1], modelname)
    recordings = recordingfromspikeglx(pattern, prefix; recordedby=recordedby)
    trials = trialfromspikeglx(pattern, prefix)

    Dataset(probe, recordings, trials)
end

function recordings(dataset::Dataset)
    dataset.recordings
end

function trials(dataset::Dataset)
    dataset.trials
end
