abstract type Annotation end

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

function probe(ann::Annotation)
    ann.probe
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
