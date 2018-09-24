mutable struct Dataset
    recordingmetadata::Array{RecordingMetadata, 1} # support multi-file recordings (single file in 1-element array)
    sortmetadata::Union{SortMetadata, Nothing}     # (optional) data pertinent to a sorting output
    trialmetadata::Union{TrialMetadata, Nothing}   # (optional) trial data
end
