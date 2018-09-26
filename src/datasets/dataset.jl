using Glob

mutable struct Dataset
    probe::Probe                    # probe used in the recording
    recordings::Vector{Recording} # support multi-file recordings (single file in 1-element array)
    trials::Vector{Trial}         # trial data (can be empty)

    function Dataset(probe::Probe, recording::Recording, trial::Trial)
        new(probe, [recording], [trial])
    end

    function Dataset(probe::Probe, recordings::Vector{Recording}, trials::Vector{Trial})
        new(probe, recordings, trials)
    end
end

function datasetfromjrclust(matfile::String; modelname::String="", recordedby::String="")
    filename = readmatshim(matfile, "P/vcFile")
    if all(filename .== 0)
        filenames = "$(splitext(mattostring(matfile, "P/csFile_merge"))[1]).meta"
        prefix = dirname(filenames)
        prefix = isempty(prefix) ? dirname(matfile) : prefix
        pattern = Glob.GlobMatch(basename(filenames))
        dataset = datasetfromspikeglx(pattern, prefix; recordedby=recordedby)
    else
        filename = "$(splitext(mattostring(matfile, "P/vcFile"))[1]).meta"
        dataset = datasetfromspikeglx(filename; recordedby=recordedby)
    end

    dataset.probe = probefromjrclust(matfile, modelname)
    dataset
end

function datasetfromphy(dir::String; modelname::String="", recordedby::String="")
    filenames = joinpath.(dir, ["channel_map.npy", "channel_positions.npy", "params.py"])
    # directory exists and all files accounted for
    if !isdir(dir)
        error("Directory $dir does not exist")
    else
        filesexist = isfile.(filenames)
        if !all(filesexist)
            missingfiles = join(filenames[.!filesexist], ", ")
            error("The following required files were not found: $missingfiles")
        end
    end

    # open up params.py and grab n_channels_dat from it
    params = open(joinpath(dir, "params.py"), "r") do fh
        Dict{String, String}([split(l, r"\s*=\s*") for l in readlines(fh)]) # broadcasting fails here
    end

    nchannels = parse(UInt64, params["n_channels_dat"])
    probe = probefromphy(joinpath(dir, "channel_map.npy"), joinpath(dir, "channel_positions.npy"), modelname, nchannels)
    recording = recordingfromphy(params)

    # no trial structure saved in params.py that I know of
    Dataset(probe, [recording], Trial[])
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

function probe(dataset::Dataset)
    dataset.probe
end

function recordings(dataset::Dataset)
    dataset.recordings
end

function samplerate(dataset::Dataset)
    sr = unique(samplerate.(recordings(dataset)))
    length(sr) == 1 ? sr[1] : sr
end

function trials(dataset::Dataset)
    dataset.trials
end
