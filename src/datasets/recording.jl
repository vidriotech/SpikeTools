using Dates

mutable struct RecordingMetadata                # mutable because paths change
    binarypath::Union{String, Array{String, 1}} # single path or array of paths to recording files
    datatype::DataType                          # data type of stored data
    fsizebytes::Union{UInt64, Array{UInt64, 1}} # size of the file(s), in bytes
    nstoredchannels::UInt64                     # number of stored channels in file(s)
    probe::Probe                                # probe used in the recording
    recordedby::String                          # who recorded this data set
    recordedon::DateTime                        # date and time on which a dataset BEGAN recording
    samplerate::UInt                            # sample rate of the recording, in Hz
end
