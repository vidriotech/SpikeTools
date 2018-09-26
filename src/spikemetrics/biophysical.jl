function isifraction(ann::Annotation, cluster::Integer, refracintervalms::T=2) where T<:Real
    ctimes = clustertimes(ann, cluster)
    samplespermilisec = Int(ceil(samplerate(dataset(ann))/1000))
    refracintervalsamp = samplespermilisec * refracintervalms

    if !isempty(ctimes)
        diffs = diff(ctimes)
        count(diffs .< refracintervalsamp)/length(ctimes)
    else
        0.0
    end
end
