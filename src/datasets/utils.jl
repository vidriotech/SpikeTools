using HDF5

function naturalsort(x::Vector{String})
    f = text -> all(isnumeric, text) ? Char(parse(Int, text)) : text
    sorter = key -> join(f(c) for c in collect((m.match for m = eachmatch(r"[0-9]+|[^0-9]+", key))))
    sort(x, by=sorter)
end

function readmatshim(filename::String, attr::String, flatten::Bool=true) # necessary until MAT.jl is fixed
    # check version of the file
    matfilever = open(filename, "r") do fh
        bytesread = read(fh, 140)
        bytesread = bytesread[1:findfirst(bytesread .== 0) - 1]
        verstring = join(Char.(bytesread), "")
        if !occursin("MAT-file", verstring)
            error("not a MAT file")
        end

        parse(Float64, match(r"\d\.\d", verstring).match)
    end

    # MAT files less than 7.3 don't use HDF5
    if matfilever < 7.3
        error("This version not supported; convert to v7.3 and try again")
    end

    data = flatten ? h5read(filename, attr)[:] : h5read(filename, attr)
end

function matfieldexists(matfile::String, dataset::String, field::String)
    field in h5readattr(matfile, dataset)["MATLAB_fields"]
end

function mattostring(matfile::String, attr::String)
    join(Char.(readmatshim(matfile, attr)), "")
end

function mattoscalar(matfile::String, attr::String)
    readmatshim(matfile, attr)[1]
end
