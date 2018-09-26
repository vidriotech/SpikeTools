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

function kilosortfromphy(dir::String)
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
