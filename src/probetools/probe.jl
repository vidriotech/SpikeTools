struct Probe
    channelmap::Array{Integer, 1}
    channelpositions::Array{Real, 2}
    nchannels::Integer

    function Probe(channelmap, channelpositions, nchannels)
        nmapchans = length(channelmap)
        if nmapchans == size(channelpositions, 1) && nmapchans ≤ nchannels
            new(channelmap, channelpositions, nchannels)
        else
            error("misshapen probe")
        end
    end
end

function fromphy(chanmapfile::String, chanposfile::String, nchannels::Integer=0)
    channelmap = npzread(chanmapfile)[:] .+ 1
    channelpositions = npzread(chanposfile)

    # by default, assume nchannels is largest channel in channel map
    nchannels = nchannels > 0 ? nchannels : maximum(channelmap)

    Probe(channelmap, channelpositions, nchannels)
end

function channelmap(probe::Probe)
    probe.channelmap
end

function channelpositions(probe::Probe)
    probe.channelpositions
end

function nchannels(probe::Probe)
    probe.nchannels
end
