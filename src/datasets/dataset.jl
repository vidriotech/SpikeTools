struct Dataset
    recordingmetadata::RecordingMetadata
    sortmetadata::Union{SortMetadata, Nothing}
    trialmetadata::Union{TrialMetadata, Nothing}
end
