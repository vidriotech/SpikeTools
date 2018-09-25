@testset "Create Neuropixels probe from Phy" begin
    chanmapfile = joinpath(ENV["TESTBASE"], "datasets", "fromphy", "channel_map.npy")
    chanposfile = joinpath(ENV["TESTBASE"], "datasets", "fromphy", "channel_positions.npy")
    probe = probefromphy(chanmapfile, chanposfile, "Neuropixels Phase 3A", 385)
    @test length(channelmap(probe)) == 374
    @test size(channelpositions(probe)) == (374, 2)
    @test modelname(probe) == "Neuropixels Phase 3A"
    @test nchannels(probe) == 385
end

@testset "Create (naive) IMEC probe from SpikeGLX" begin
    metafile = joinpath(ENV["TESTBASE"], "datasets", "fromspikeglx", "anm420712_20180802_ch0-119bank1_ch120-382bank0_g0_t2.imec.ap.meta")
    probe = probefromspikeglx(metafile, "Neuropixels Phase 3A")
    @test length(channelmap(probe)) == 374
    @test size(channelpositions(probe)) == (374, 2)
    @test modelname(probe) == "Neuropixels Phase 3A"
    @test nchannels(probe) == 385
end

@testset "Create (naive) NIDQ probe from SpikeGLX" begin
    metafile = joinpath(ENV["TESTBASE"], "datasets", "fromspikeglx", "anm365938_g0_t0.nidq.meta")
    probe = probefromspikeglx(metafile, "HH2")
    @test length(channelmap(probe)) == 192
    @test size(channelpositions(probe)) == (192, 2)
    @test modelname(probe) == "HH2"
    @test nchannels(probe) == 256
end

@testset "Create probe from JRCLUST" begin
    jrcmatfile = joinpath(ENV["TESTBASE"], "datasets", "fromjrclust", "testset_jrc.mat")
    probe = probefromjrclust(jrcmatfile, "HH2", 256)
    @test length(channelmap(probe)) == 64
    @test size(channelpositions(probe)) == (64, 2)
    @test modelname(probe) == "HH2"
    @test nchannels(probe) == 256
end

@testset "Create a probe from a .rez file" begin
    rezfile = joinpath(ENV["TESTBASE"], "datasets", "fromrez", "rez.mat")
    probe = probefromrezfile(rezfile, "Neuropixels Phase 3A")
    @test length(channelmap(probe)) == 374
    @test size(channelpositions(probe)) == (374, 2)
    @test modelname(probe) == "Neuropixels Phase 3A"
    @test nchannels(probe) == 385
end

@testset "Create single recording from SpikeGLX" begin
    metafile = joinpath(ENV["TESTBASE"], "datasets", "fromspikeglx", "anm420712_20180802_ch0-119bank1_ch120-382bank0_g0_t2.imec.ap.meta")
    rec = recordingfromspikeglx(metafile; recordedby="Gandalf")
    @test binarypath(rec) == "C:/Users/labadmin/Documents/anm420712/anm420712_20180802_ephys/anm420712_20180802_ch0-119bank1_ch120-382bank0_g0_t2.imec.ap.bin"
    @test rec.datatype == Int16
    @test fsizebytes(rec) == 13860000000
    @test nstoredchannels(rec) == 385
    @test recordedby(rec) == "Gandalf"
    @test recordedon(rec) == DateTime("2018-08-02T14:04:21")
    @test samplerate(rec) == 30000
end

@testset "Create multiple recordings from SpikeGLX" begin
    metafiles = glob"anm365938_g0_t*.nidq.meta"
    recs = recordingfromspikeglx(metafiles, joinpath(ENV["TESTBASE"], "datasets", "fromspikeglx"))
    t = rand(1:length(recs))
    @test binarypath(recs[t]) == "E:/anm365938/2017-10-25/SpikeGL/anm365938_g0_t$(t-1).nidq.bin"
    @test all(getfield.(recs, :datatype) .== Int16)
    mask = fsizebytes.(recs) .== 101121024
    @test sum(mask) == 44
    @test all(fsizebytes.(recs)[.!mask] .== 101120512)
    @test all(nstoredchannels.(recs) .== 256)
    @test all(isempty.(recordedby.(recs)))
    @test issorted(recordedon.(recs))
    @test all(samplerate.(recs) .== 25000)
end

@testset "Create a recording from a .rez file" begin
    rezfile = joinpath(ENV["TESTBASE"], "datasets", "fromrez", "rez.mat")
    rec = recordingfromrezfile(rezfile; recordedby="Shadowfax")
    @test binarypath(rec) == "F:\\CortexLab\\singlePhase3\\data\\Hopkins_20160722_g0_t0.imec.ap_CAR.bin"
    @test rec.datatype == Int16
    @test fsizebytes(rec) ≈ 8.717075136000000e+10
    @test nstoredchannels(rec) == 385
    @test recordedby(rec) == "Shadowfax"
    @test recordedon(rec) == DateTime("2016-07-22T20:27:33")
    @test samplerate(rec) == 30000
end

@testset "Create single trial from SpikeGLX" begin
    metafile = joinpath(ENV["TESTBASE"], "datasets", "fromspikeglx", "anm420712_20180802_ch0-119bank1_ch120-382bank0_g0_t2.imec.ap.meta")
    tr = trialfromspikeglx(metafile)
    @test starttimesecs(tr) ≈ 1220.0004
    @test runtimesecs(tr) ≈ 600
end

@testset "Create multiple trials from SpikeGLX" begin
    metafiles = glob"anm365938_g0_t*.nidq.meta"
    trs = trialfromspikeglx(metafiles, joinpath(ENV["TESTBASE"], "datasets", "fromspikeglx"))
    @test issorted(starttimesecs.(trs))
    mask = runtimesecs.(trs) .≈ 7.90008
    @test sum(mask) == 44 # these are the larger files in the recordings test
    @test all(runtimesecs.(trs)[.!mask] .≈ 7.90004)
end

@testset "Create a trial from a .rez file" begin
    rezfile = joinpath(ENV["TESTBASE"], "datasets", "fromrez", "rez.mat")
    tr = trialfromrezfile(rezfile, 30000)
    @test starttimesecs(tr) == 0
    @test runtimesecs(tr) ≈ 3.773625600000000e+03
end

@testset "Create single dataset from SpikeGLX" begin
    metafile = joinpath(ENV["TESTBASE"], "datasets", "fromspikeglx", "anm420712_20180802_ch0-119bank1_ch120-382bank0_g0_t2.imec.ap.meta")
    dataset = datasetfromspikeglx(metafile; modelname="Neuropixels Phase 3A", recordedby="Saruman")
    @test modelname(dataset.probe) == "Neuropixels Phase 3A"

    recs = recordings(dataset)
    @test length(recs) == 1
    rec = recs[1]
    @test binarypath(rec) == "C:/Users/labadmin/Documents/anm420712/anm420712_20180802_ephys/anm420712_20180802_ch0-119bank1_ch120-382bank0_g0_t2.imec.ap.bin"
    @test rec.datatype == Int16
    @test fsizebytes(rec) == 13860000000
    @test nstoredchannels(rec) == 385
    @test recordedby(rec) == "Saruman"
    @test recordedon(rec) == DateTime("2018-08-02T14:04:21")
    @test samplerate(rec) == 30000

    trs = trials(dataset)
    @test length(trs) == 1
    tr = trs[1]
    @test starttimesecs(tr) ≈ 1220.0004
    @test runtimesecs(tr) ≈ 600
end

@testset "Create multiple datasets from SpikeGLX" begin
    metafiles = glob"anm365938_g0_t*.nidq.meta"
    dataset = datasetfromspikeglx(metafiles, joinpath(ENV["TESTBASE"], "datasets", "fromspikeglx"); modelname="Neuropixels Phase 3A", recordedby="Radagast")
    @test modelname(dataset.probe) == "Neuropixels Phase 3A"
    recs = recordings(dataset)
    t = rand(1:length(recs))
    @test binarypath(recs[t]) == "E:/anm365938/2017-10-25/SpikeGL/anm365938_g0_t$(t-1).nidq.bin"
    @test all(getfield.(recs, :datatype) .== Int16)
    mask = fsizebytes.(recs) .== 101121024
    @test sum(mask) == 44
    @test all(fsizebytes.(recs)[.!mask] .== 101120512)
    @test all(nstoredchannels.(recs) .== 256)
    @test all(recordedby.(recs) .== "Radagast")
    @test issorted(recordedon.(recs))
    @test all(samplerate.(recs) .== 25000)
    trs = trials(dataset)
    @test issorted(starttimesecs.(trs))
    mask = runtimesecs.(trs) .≈ 7.90008
    @test sum(mask) == 44 # these are the larger files in the recordings test
    @test all(runtimesecs.(trs)[.!mask] .≈ 7.90004)
end

@testset "Create a sorting from JRCLUST" begin
    jrcmatfile = joinpath(ENV["TESTBASE"], "datasets", "fromjrclust", "testset_jrc.mat")
    sorting = sortingfromjrclust(jrcmatfile; modelname="HH2", recordedby="Aragorn", sortedby="Aragorn")
    visite2chan = [112; 111; 110; 109; 107; 108; 105; 106; 103; 104; 101; 102; 99;
                   100; 97; 98; 81; 82; 83; 84; 86; 85; 88; 87; 90; 89; 92; 91; 94;
                   93; 96; 95; 66; 65; 68; 67; 70; 69; 72; 71; 74; 73; 76; 75; 77;
                   78; 79; 80; 127; 128; 125; 126; 123; 124; 121; 122; 119; 120; 117;
                   118; 116; 115; 114; 113]
    vrsitexy = 25.0 .* [repeat([0; 10], inner=32) repeat(0:31, outer=2)]

    @test channelmap(dataset(sorting).probe) == visite2chan
    @test channelpositions(dataset(sorting).probe) == vrsitexy
    @test modelname(dataset(sorting).probe) == "HH2"
    @test nchannels(dataset(sorting).probe) == 256
    @test programused(sorting) == "JRCLUST"
    @test programversion(sorting) == "v3.2.5"
    @test runtimesecs(sorting) ≈ 3.778967968300000e+03
    @test sortedby(sorting) == "Aragorn"
    @test sortedon(sorting) == DateTime("2018-09-11T14:49:59.838")
end

@testset "Create a sorting from a .rez file" begin
    rezfile = joinpath(ENV["TESTBASE"], "datasets", "fromrez", "rez.mat")
    sorting = sortingfromrezfile(rezfile, programversion="77bd485", runtimesecs=0,
                                 modelname="Neuropixels Phase 3A", recordedby="Shagrat",
                                 sortedby="Gorbag")
    chanmap = setdiff(1:385, [37 76 113 152 189 228 265 304 341 380 385])
    chanpos = [repeat([0], 374) chanmap]

    @test channelmap(dataset(sorting).probe) == chanmap
    @test channelpositions(dataset(sorting).probe) == chanpos
    @test modelname(dataset(sorting).probe) == "Neuropixels Phase 3A"
    @test nchannels(dataset(sorting).probe) == 385
    @test programused(sorting) == "KiloSort"
    @test programversion(sorting) == "77bd485"
    @test runtimesecs(sorting) ≈ 0
    @test sortedby(sorting) == "Gorbag"
    @test sortedon(sorting) == DateTime("2018-08-02T13:25:57.775")
end
