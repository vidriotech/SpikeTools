using Dates
using Glob

mutable struct RecordingMetadata                # mutable because paths change
    binarypath::String                          # path to recording file
    datatype::DataType                          # data type of stored data
    fsizebytes::UInt64                          # size of the file, in bytes
    nstoredchannels::UInt64                     # number of stored channels in file
    probe::Probe                                # probe used in the recording
    recordedby::String                          # who recorded this data set
    recordedon::DateTime                        # date and time on which this file BEGAN recording
    samplerate::UInt64                          # sample rate of the recording, in Hz
end

"""
    readspikeglxmeta(filename)

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
                 "recordedon" => DateTime(metadata["fileCreateTime"]),
                 "probe" => probefromspikeglx(metadata)])

    # distinguish here between NI-DAQ and IMEC probes
    if metadata["typeThis"] == "imec"
        vals["samplerate"] = parse(UInt64, metadata["imSampRate"])
    else
        vals["samplerate"] = parse(UInt64, metadata["niSampRate"])
    end

    vals
end

function recfromspikeglx(metafile::String; modelname="", recordedby::String="")
    vals = readspikeglxmeta(metafile)

    RecordingMetadata(vals["binarypath"],
                      Int16,
                      vals["fsizebytes"],
                      vals["nstoredchannels"],
                      vals["probe"],
                      recordedby,
                      vals["recordedon"],
                      vals["samplerate"])
end
