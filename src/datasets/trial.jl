using Glob

struct Trial
    starttimesecs::Real   # start time of trial, in seconds, relative to beginning of experiment
    runtimesecs::Real     # run time of trial, in seconds

    function Trial(starttimesecs::Real, runtimesecs::Real)
        if starttimesecs < 0 || runtimesecs < 0
            error("Start and run times must be nonnegative")
        end

        new(starttimesecs, runtimesecs)
    end
end

function trialfromrezfile(rezfile::String)
    samplerate = mattoscalar(rezfile, "rez/ops/fs")
    if matfieldexists(rezfile, "rez/ops", "tstart")
        tstart = mattoscalar(rezfile, "rez/ops/tstart")
        tend = mattoscalar(rezfile, "rez/ops/tend")
    else # make a guess based on the file size
        nchannels = mattoscalar(rezfile, "rez/ops/NchanTOT")
        tstart = 0
        tend = filesize(mattostring(rezfile, "rez/ops/fbinary"))/(2nchannels)
    end

    Trial(tstart/samplerate, tend/samplerate)
end

function trialfromspikeglx(metadata::Dict{String}, firstsample::Signed=0)
    trialstart = parse(Int64, metadata["firstSample"])
    runtime = parse(Float64, metadata["fileTimeSecs"])

    if metadata["typeThis"] == "imec"
        samplerate = parse(Int64, metadata["imSampRate"])
    else
        samplerate = parse(Int64, metadata["niSampRate"])
    end

    Trial((trialstart - firstsample)/samplerate, runtime)
end

function trialfromspikeglx(filename::String, firstsample::Signed)
    # open up the file and parse it into a Dict
    lines = open(filename, "r") do fh
       readlines(fh)
    end

    trialfromspikeglx(Dict{String, Any}(split.(lines, "=")), firstsample)
end

function trialfromspikeglx(filename::String, firstsample::Unsigned=0)
    trialfromspikeglx(filename, Int(firstsample))
end

function trialfromspikeglx(pattern::Glob.GlobMatch, prefix::String="")
    filenames = naturalsort(glob(pattern, prefix))

    # get start time from the first file
    firstsample = open(filenames[1], "r") do fh
       readuntil(fh, "firstSample=")
       parse(UInt64, readline(fh))
   end

   trialfromspikeglx.(filenames, firstsample)
end

function starttimesecs(trial::Trial)
    trial.starttimesecs
end

function runtimesecs(trial::Trial)
    trial.runtimesecs
end
