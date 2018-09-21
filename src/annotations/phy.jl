abstract type PhyAnnotation <: Annotation end

struct KilosortAnnotation <: PhyAnnotation
    amplitudes::Array{<:Real, 1}        # template scaling factor
    probe::Probe                        # probe
    similartemplates::Array{<:Real, 2}  # template similarity score
    spikeclusters::Array{<:Integer, 1}  # cluster assignment for each spike
    spiketemplates::Array{<:Integer, 1} # template assignment for each spike
    spiketimes::Array{<:Integer, 1}     # time at which spike was called
    templates::Array{<:Real, 3}         # all templates
end

function loadkilosort(dir::String)
    filenames = joinpath.(dir, ["amplitudes.npy", "channel_map.npy", "channel_positions.npy",
                                "similar_templates.npy", "spike_clusters.npy", "spike_templates.npy",
                                "spike_times.npy", "templates.npy"])

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

    probe = probefromphy(joinpath(dir, "channel_map.npy"), joinpath(dir, "channel_positions.npy"))

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

function amplitudes(ann::KilosortAnnotation)
    ann.amplitudes
end

function similartemplates(ann::KilosortAnnotation)
    ann.similartemplates
end

function spiketemplates(ann::KilosortAnnotation)
    ann.spiketemplates
end

function templates(ann::KilosortAnnotation)
    ann.templates
end
