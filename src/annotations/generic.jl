abstract type Annotation end

function clusters(ann::Annotation)
    unique(spikeclusters(ann))
end

function nclusters(ann::Annotation)
    length(clusters(ann))
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

function spiketimes(ann::Annotation)
    ann.spiketimes
end
