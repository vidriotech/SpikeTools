abstract type Annotation end
abstract type TemplateAnnotation <: Annotation end

struct JRCLUSTAnnotation <: Annotation
    probe::Probe                        # probe
    spikeclusters::Array{<:Integer, 1}  # cluster assignment for each spike
    spiketimes::Array{<:Integer, 1}     # time at which spike was called
end

struct KilosortAnnotation <: TemplateAnnotation
    amplitudes::Array{<:Real, 1}        # template scaling factor
    probe::Probe                        # probe
    similartemplates::Array{<:Real, 2}  # template similarity score
    spikeclusters::Array{<:Integer, 1}  # cluster assignment for each spike
    spiketemplates::Array{<:Integer, 1} # template assignment for each spike
    spiketimes::Array{<:Integer, 1}     # time at which spike was called
    templates::Array{<:Real, 3}         # all templates
end

function jrclustfrommat(matfile::String, auto::Bool=false; modelname::String="")
    probe = probefromjrclust(matfile, modelname)
    spikeclusters = Vector{Int64}(readmatshim(matfile, auto ? "S_clu/viClu_auto" : "S_clu/viClu"))
    spiketimes = Vector{UInt64}(readmatshim(matfile, "viTime_spk"))

    JRCLUSTAnnotation(probe, spikeclusters, spiketimes)
end

function kilosortfromphy(dir::String; modelname::String="")
    filenames = joinpath.(dir, ["amplitudes.npy", "channel_map.npy", "channel_positions.npy",
                                "similar_templates.npy", "spike_clusters.npy", "spike_templates.npy",
                                "spike_times.npy", "templates.npy", "params.py"])

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
    nchannels = open(joinpath(dir, "params.py"), "r") do fh
        keysvals = Dict{String, String}([split(l, r"\s*=\s*") for l in readlines(fh)]) # . syntax fails here
        parse(UInt64, keysvals["n_channels_dat"])
    end

    probe = probefromphy(joinpath(dir, "channel_map.npy"), joinpath(dir, "channel_positions.npy"), modelname, nchannels)

    amplitudes = npzread(joinpath(dir, "amplitudes.npy"))[:]
    similartemplates = npzread(joinpath(dir, "similar_templates.npy"))
    spikeclusters = npzread(joinpath(dir, "spike_clusters.npy"))[:] .+ 1
    spiketemplates = npzread(joinpath(dir, "spike_templates.npy"))[:] .+ 1
    spiketimes = npzread(joinpath(dir, "spike_times.npy"))[:]
    templates = npzread(joinpath(dir, "templates.npy"))

    nspikes = length(spiketimes)
    if !all(length.([amplitudes, spikeclusters, spiketemplates]) .== nspikes)
        error("Mismatched spike counts")
    end

    # check our templates are consistent
    if maximum(spiketemplates) ≠ size(templates, 1)
        error("Spike template assignments inconsistent with saved templates")
    elseif !all(size(similartemplates) .== size(templates, 1))
        error("Template similarity score inconsistent with saved templates")
    elseif length(channelmap(probe)) ≠ size(templates, 3)
        error("Probe inconsistent with saved templates")
    end

    KilosortAnnotation(amplitudes, probe, similartemplates, spikeclusters,
                       spiketemplates, spiketimes, templates)
end

function kilosortfromrezfile(rezfile::String; modelname::String="")
    probe = probefromrezfile(rezfile, modelname)

    st3 = readmatshim(rezfile, "rez/st3", false)
    spiketimes = Array{UInt64}(st3[:, 1])
    spiketemplates = Array{UInt32}(st3[:, 2])
    amplitudes = st3[:, 3]
    if size(st3, 2) > 4
        spikeclusters = Array{UInt32}(st3[:, 5]) .+ 1
    else
        spikeclusters = spiketemplates
    end

    ntemplates = length(unique(spiketemplates))

    if matfieldexists(rezfile, "rez", "simScore")
        similartemplates = readmatshim(rezfile, "rez/simScore", false)
    else
        # TODO: compute this here
        similartemplates = NaN .* ones(ntemplates, ntemplates)
    end

    if matfieldexists(rezfile, "rez", "Wphy")
        W = readmatshim(rezfile, "rez/Wphy", false)
    else
        W = readmatshim(rezfile, "rez/W", false)
    end
    if ndims(W) < 3 # ungathered gpuArray
        error("Ungathered gpuArray `W` or `Wphy` in rez file; gather all gpuArrays and resave")
    end

    U = readmatshim(rezfile, "rez/U", false)
    if ndims(U) < 3 # ungathered gpuArray
        error("Ungathered gpuArray `U` in rez file; gather all gpuArrays and resave")
    end

    Nchan = Int64(mattoscalar(rezfile, "rez/ops/Nchan"))
    (nt0, Nfilt) = size(W)

    templates = zeros(Float32, Nchan, nt0, Nfilt)
    for iNN = 1:size(templates, 3)
        templates[:, :, iNN] = U[:, iNN, :] * transpose(W[:, iNN, :])
    end
    templates = permutedims(templates, [3 2 1]) # now it's nTemplates x nSamples x nChannels

    KilosortAnnotation(amplitudes, probe, similartemplates, spikeclusters,
                       spiketemplates, spiketimes, templates)
end

function clusters(ann::Annotation, sorted::Bool=true)
    uniqueclusters = unique(spikeclusters(ann))
    sorted && uniqueclusters == sorted(uniqueclusters)

    uniqueclusters
end

function clustertimes(ann::Annotation, cluster::Integer)
    spiketimes(ann)[spikeclusters(ann) .== cluster]
end

function nclusters(ann::Annotation)
    length(clusters(ann, false))
end

function nspikes(ann::Annotation)
    length(spiketimes(ann))
end

function spikeclusters(ann::Annotation)
    ann.spikeclusters
end

function spikecounts(ann::Annotation)
    allclusters = clusters(ann)
    [count(allclusters .== c) for c in allclusters]
end

function spiketimes(ann::Annotation)
    ann.spiketimes
end

function amplitudes(ann::TemplateAnnotation)
    ann.amplitudes
end

function similartemplates(ann::TemplateAnnotation)
    ann.similartemplates
end

function spiketemplates(ann::TemplateAnnotation)
    ann.spiketemplates
end

function templates(ann::TemplateAnnotation)
    ann.templates
end
