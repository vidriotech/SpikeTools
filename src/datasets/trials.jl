struct TrialMetadata
    ntrials::UInt64           # number of trials
    starttimes::Array{Real} # start time of each trial, in seconds
    runtimes::Array{Real}   # run time of each trial, in seconds
end
