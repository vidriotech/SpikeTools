using Glob

struct Sorting
    dataset::Dataset       # the dataset on which the sorting was done
    programused::String    # the program used to do the automated sorting
    programversion::String # version of that program
    runtimesecs::Real      # runtime in seconds for the sorting
    sortedby::String       # who ran the initial sorting
    sortedon::DateTime     # when was the sorting run
end

function sortingfromjrclust(matfile::String; modelname::String="", recordedby::String="", sortedby::String="")
    filename = readmatshim(matfile, "P/vcFile")
    if all(filename .== 0)
        filenames = "$(splitext(mattostring(matfile, "P/csFile_merge"))[1]).meta"
        prefix = dirname(filenames)
        prefix = isempty(prefix) ? dirname(matfile) : prefix
        pattern = Glob.GlobMatch(basename(filenames))
        dataset = datasetfromspikeglx(pattern, prefix; recordedby=recordedby)
    else
        filename = "$(mattostring(filename, "P/vcFile")[1]).meta"
        dataset = datasetfromspikeglx(filename; recordedby=recordedby)
    end

    nchannels = nstoredchannels(recordings(dataset)[1])
    probe = probefromjrclust(matfile, modelname, nchannels)
    dataset.probe = probe

    programversion = mattostring(matfile, "P/version")
    runtimesecs = mattoscalar(matfile, "runtime_detect") + mattoscalar(matfile, "runtime_sort")
    sortedon = unix2datetime(ctime(matfile))

    Sorting(dataset, "JRCLUST", programversion, runtimesecs, sortedby, sortedon)
end

function sortingfromrezfile(rezfile::String; programversion::String="", runtimesecs::Real=0,
                            modelname::String="", recordedby::String="", sortedby::String="")
    dataset = datasetfromrezfile(rezfile; modelname=modelname, recordedby=recordedby)
    sortedon = unix2datetime(mtime(rezfile))
    Sorting(dataset, "KiloSort", programversion, runtimesecs, sortedby, sortedon)
end

function dataset(sorting::Sorting)
    sorting.dataset
end

function programused(sorting::Sorting)
    sorting.programused
end

function programversion(sorting::Sorting)
    sorting.programversion
end

function runtimesecs(sorting::Sorting)
    sorting.runtimesecs
end

function sortedby(sorting::Sorting)
    sorting.sortedby
end

function sortedon(sorting::Sorting)
    sorting.sortedon
end
