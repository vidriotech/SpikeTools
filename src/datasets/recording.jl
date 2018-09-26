using Dates
using Glob

mutable struct Recording
    binarypath::String        # path to recording file
    datatype::DataType        # data type of stored data
    fsizebytes::Unsigned      # size of the file, in bytes
    nstoredchannels::Unsigned # number of stored channels in file
    recordedby::String        # who recorded this data set
    recordedon::Date          # date on which this file was created
    samplerate::Unsigned      # sample rate of the recording, in Hz
end

"""
    readspikeglxmeta(filename::String)

Read in the SpikeGLX meta file living at the path `filename` and return a Dict of relevant values from it.
"""
function readspikeglxmeta(filename::String)
    if !isfile(filename)
        error("File $filename does not exist")
    end

    # open up the file and parse it into a Dict
    lines = open(filename, "r") do fh
       readlines(fh)
    end
    metadata = Dict{String, Any}(split.(lines, "="))

    vals = Dict(["binarypath" => metadata["fileName"],
                 "fsizebytes" => parse(UInt64, metadata["fileSizeBytes"]),
                 "nstoredchannels" => parse(UInt64, metadata["nSavedChans"]),
                 "recordedon" => Date(DateTime(metadata["fileCreateTime"]))])

    # distinguish here between NI-DAQ and IMEC probes
    if metadata["typeThis"] == "imec"
        vals["samplerate"] = parse(UInt64, metadata["imSampRate"])
    else
        vals["samplerate"] = parse(UInt64, metadata["niSampRate"])
    end

    vals
end

function recordingfromphy(params::Dict{String}; recordedby::String="")
    binarypath = params["dat_path"]
    fsizebytes = filesize(binarypath)
    nstoredchannels = parse(UInt64, params["n_channels_dat"])
    recordedon = Date(unix2datetime(mtime(binarypath)))
    samplerate = parse(UInt64, replace(params["sample_rate"], r"\." => ""))

    Recording(binarypath, Int16, fsizebytes, nstoredchannels, recordedby,
              recordedon, samplerate)
end

function recordingfromphy(paramfile::String)
    params = open(paramfile, "r") do fh
        Dict{String, String}([split(l, r"\s*=\s*") for l in readlines(fh)]) # broadcasting fails here
    end

    recordingfromphy(params)
end

function recordingfromrezfile(matfile::String; recordedby::String="")
    binarypath = mattostring(matfile, "rez/ops/fbinary")
    fsizebytes = filesize(binarypath)
    nstoredchannels = UInt(mattoscalar(matfile, "rez/ops/NchanTOT"))
    recordedon = Date(unix2datetime(mtime(binarypath)))
    samplerate = UInt(mattoscalar(matfile, "rez/ops/fs"))

    Recording(binarypath, Int16, fsizebytes, nstoredchannels, recordedby,
              recordedon, samplerate)
end

function recordingfromspikeglx(filename::String; recordedby::String="")
    vals = readspikeglxmeta(filename)

    Recording(vals["binarypath"], Int16, vals["fsizebytes"], vals["nstoredchannels"],
              recordedby, vals["recordedon"], vals["samplerate"])
end

function recordingfromspikeglx(pattern::Glob.GlobMatch, prefix::String=""; recordedby::String="")
    filenames = naturalsort(glob(pattern, prefix))
    recordingfromspikeglx.(filenames; recordedby=recordedby)
end

function binarypath(rec::Recording)
    rec.binarypath
end

function datatype(rec::Recording)
    rec.datatype
end

function fsizebytes(rec::Recording)
    rec.fsizebytes
end

function nstoredchannels(rec::Recording)
    rec.nstoredchannels
end

function recordedby(rec::Recording)
    rec.recordedby
end

function recordedon(rec::Recording)
    rec.recordedon
end

function samplerate(rec::Recording)
    rec.samplerate
end
