struct Probe
    channelmap::Array{<:Integer, 1}
    channelpositions::Array{<:Real, 2}
    modelname::String
    nchannels::Integer

    function Probe(channelmap::Array{<:Integer, 1}, channelpositions::Array{<:Real, 2},
                   modelname::String, nchannels::Integer)
        nmapchans = length(channelmap)
        if nmapchans == size(channelpositions, 1) && nmapchans ≤ nchannels
            new(channelmap, channelpositions, modelname, nchannels)
        else
            error("misshapen probe")
        end
    end
end

function probefromphy(chanmapfile::String, chanposfile::String, modelname::String="", nchannels::Integer=0)
    channelmap = npzread(chanmapfile)[:] .+ 1
    channelpositions = npzread(chanposfile)

    # by default, assume nchannels is largest channel in channel map
    nchannels = nchannels > 0 ? nchannels : maximum(channelmap)

    Probe(channelmap, channelpositions, modelname, nchannels)
end

function probefromspikeglx(metadata::Dict{String}, modelname::String="")
    nchannels = parse(UInt64, metadata["nSavedChans"])

    chanmap = split(metadata["~snsChanMap"][2:end-1], ")(")
    chanheader = parse.(UInt64, split(chanmap[1], ","))
    chanmap = chanmap[2:end]

    shankmap = split(metadata["~snsShankMap"][2:end-1], ")(")
    shankheader = parse.(UInt64, split(shankmap[1], ","))
    shankmap = split.(shankmap[2:end], ":")

    # Per docs: "The number of table entries must equal AP (if Imec) or MN (if Nidq)."
    shankid = parse.(UInt64, getindex.(shankmap, 1)) .+ 1
    shankcols = parse.(UInt64, getindex.(shankmap, 2)) .+ 1
    shankrows = parse.(UInt64, getindex.(shankmap, 3)) .+ 1
    connected = Bool.(parse.(UInt8, getindex.(shankmap, 4)))

    if metadata["typeThis"] == "imec"
        # This is the count of channels, of each type, in each timepoint, as stored in the binary file.
        chantypecounts = parse.(UInt64, split(metadata["snsApLfSy"], ",")) # [#AP, #LF, #SY]
        chanmask = startswith.(chanmap, "AP")
    else # NIDQ
        # This is the count of channels, of each type, in each timepoint, as stored in the binary file.
        chantypecounts = parse.(UInt64, split(metadata["snsMnMaXaDw"], ",")) # [#MN, #MA, #XA, #XD]
        chanmask = startswith.(chanmap, "MN") # MN channels; I **think** these are the only ones we care about
    end

    # split values by ":", take the second element, parse these into unsigned ints
    channelmap = parse.(UInt64, getindex.(split.(chanmap[chanmask], ":"), 2)) .+ 1
    # naive geometry until we understand the format better
    shankcols = (shankid .- 1) .*maximum(shankcols) .+ shankcols
    channelpositions = Array{Float64, 2}([shankcols shankrows])

    Probe(channelmap[connected], channelpositions[connected, :], modelname, nchannels)
end

function probefromspikeglx(filename::String, modelname::String="")
    # open up the file and parse it into a Dict
    lines = open(filename, "r") do fh
       readlines(fh)
    end

    probefromspikeglx(Dict{String, Any}(split.(lines, "=")), modelname)
end

function channelmap(probe::Probe)
    probe.channelmap
end

function channelpositions(probe::Probe)
    probe.channelpositions
end

function modelname(probe::Probe)
    probe.modelname
end

function nchannels(probe::Probe)
    probe.nchannels
end
