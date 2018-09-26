@testset "Import a probe from Phy .npy files" begin
    chanmapfile = joinpath(ENV["TESTBASE"], "datasets", "fromphy", "channel_map.npy")
    chanposfile = joinpath(ENV["TESTBASE"], "datasets", "fromphy", "channel_positions.npy")
    probe = probefromphy(chanmapfile, chanposfile, "Neuropixels Phase 3A", 385)
    @test length(channelmap(probe)) == 374
    @test size(channelpositions(probe)) == (374, 2)
    @test modelname(probe) == "Neuropixels Phase 3A"
    @test nchannels(probe) == 385
end

@testset "Import a probe from KiloSort rez.mat" begin
    rezfile = joinpath(ENV["TESTBASE"], "datasets", "fromrez", "eMouse-rez.mat")
    probe = probefromrezfile(rezfile, "eMouse")
    @test length(channelmap(probe)) == 32
    @test size(channelpositions(probe)) == (32, 2)
    @test modelname(probe) == "eMouse"
    @test nchannels(probe) == 34
end

@testset "Import a probe from KiloSort2 rez.mat" begin
    rezfile = joinpath(ENV["TESTBASE"], "datasets", "fromrez", "ks2-rez.mat")
    probe = probefromrezfile(rezfile, "Neuropixels Phase 3A")
    @test length(channelmap(probe)) == 374
    @test size(channelpositions(probe)) == (374, 2)
    @test modelname(probe) == "Neuropixels Phase 3A"
    @test nchannels(probe) == 385
end

@testset "Import a (naive) IMEC probe from SpikeGLX .meta file" begin
    metafile = joinpath(ENV["TESTBASE"], "datasets", "fromspikeglx", "anm420712_20180802_ch0-119bank1_ch120-382bank0_g0_t2.imec.ap.meta")
    probe = probefromspikeglx(metafile, "Neuropixels Phase 3A")
    @test length(channelmap(probe)) == 374
    @test size(channelpositions(probe)) == (374, 2)
    @test modelname(probe) == "Neuropixels Phase 3A"
    @test nchannels(probe) == 385
end

@testset "Import a (naive) NIDQ probe from SpikeGLX .meta file" begin
    metafile = joinpath(ENV["TESTBASE"], "datasets", "fromspikeglx", "anm365938_g0_t0.nidq.meta")
    probe = probefromspikeglx(metafile, "HH2")
    @test length(channelmap(probe)) == 192
    @test size(channelpositions(probe)) == (192, 2)
    @test modelname(probe) == "HH2"
    @test nchannels(probe) == 256
end

@testset "Import a probe from JRCLUST _jrc.mat file" begin
    jrcmatfile = joinpath(ENV["TESTBASE"], "datasets", "fromjrclust", "testset_jrc.mat")
    probe = probefromjrclust(jrcmatfile, "HH2")
    @test length(channelmap(probe)) == 64
    @test size(channelpositions(probe)) == (64, 2)
    @test modelname(probe) == "HH2"
    @test nchannels(probe) == 256
end

@testset "Import recording from single SpikeGLX .meta file" begin
    metafile = joinpath(ENV["TESTBASE"], "datasets", "fromspikeglx", "anm420712_20180802_ch0-119bank1_ch120-382bank0_g0_t2.imec.ap.meta")
    rec = recordingfromspikeglx(metafile; recordedby="Gandalf")
    @test binarypath(rec) == "C:/Users/labadmin/Documents/anm420712/anm420712_20180802_ephys/anm420712_20180802_ch0-119bank1_ch120-382bank0_g0_t2.imec.ap.bin"
    @test rec.datatype == Int16
    @test fsizebytes(rec) == 13860000000
    @test nstoredchannels(rec) == 385
    @test recordedby(rec) == "Gandalf"
    @test recordedon(rec) == Date("2018-08-02")
    @test samplerate(rec) == 30000
end

@testset "Import recordings from multiple SpikeGLX .meta files" begin
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

@testset "Import a recording from KiloSort rez.mat" begin
    rezfile = joinpath(ENV["TESTBASE"], "datasets", "fromrez", "eMouse-rez.mat")
    rec = recordingfromrezfile(rezfile; recordedby="Treebeard")

    @test binarypath(rec) == "F:\\eMouse\\sim_binary.dat"
    @test rec.datatype == Int16
    @test fsizebytes(rec) == 1700000000
    @test nstoredchannels(rec) == 34
    @test recordedby(rec) == "Treebeard"
    @test recordedon(rec) == Date("2018-08-17")
    @test samplerate(rec) == 25000
end

@testset "Import a recording from KiloSort2 rez.mat" begin
    rezfile = joinpath(ENV["TESTBASE"], "datasets", "fromrez", "ks2-rez.mat")
    rec = recordingfromrezfile(rezfile; recordedby="Shadowfax")

    @test binarypath(rec) == "F:\\CortexLab\\singlePhase3\\data\\Hopkins_20160722_g0_t0.imec.ap_CAR.bin"
    @test rec.datatype == Int16
    @test fsizebytes(rec) ≈ 8.717075136000000e+10
    @test nstoredchannels(rec) == 385
    @test recordedby(rec) == "Shadowfax"
    @test recordedon(rec) == Date("2016-07-22")
    @test samplerate(rec) == 30000
end

@testset "Import trial from SpikeGLX single .meta file" begin
    metafile = joinpath(ENV["TESTBASE"], "datasets", "fromspikeglx", "anm420712_20180802_ch0-119bank1_ch120-382bank0_g0_t2.imec.ap.meta")
    tr = trialfromspikeglx(metafile)
    @test starttimesecs(tr) ≈ 1220.0004
    @test runtimesecs(tr) ≈ 600
end

@testset "Import trials from multiple SpikeGLX .meta files" begin
    metafiles = glob"anm365938_g0_t*.nidq.meta"
    trs = trialfromspikeglx(metafiles, joinpath(ENV["TESTBASE"], "datasets", "fromspikeglx"))
    @test issorted(starttimesecs.(trs))
    mask = runtimesecs.(trs) .≈ 7.90008
    @test sum(mask) == 44 # these are the larger files in the recordings test
    @test all(runtimesecs.(trs)[.!mask] .≈ 7.90004)
end

@testset "Construct a trial from KiloSort rez.mat" begin
    rezfile = joinpath(ENV["TESTBASE"], "datasets", "fromrez", "eMouse-rez.mat")
    tr = trialfromrezfile(rezfile)
    @test starttimesecs(tr) == 0
    @test runtimesecs(tr) == 1000
end

@testset "Construct a trial from KiloSort2 rez.mat" begin
    rezfile = joinpath(ENV["TESTBASE"], "datasets", "fromrez", "ks2-rez.mat")
    tr = trialfromrezfile(rezfile)
    @test starttimesecs(tr) == 0
    @test runtimesecs(tr) ≈ 3.773625600000000e+03
end

@testset "Construct dataset from single SpikeGLX .meta file" begin
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
    @test recordedon(rec) == Date("2018-08-02")
    @test samplerate(rec) == 30000

    trs = trials(dataset)
    @test length(trs) == 1
    tr = trs[1]
    @test starttimesecs(tr) ≈ 1220.0004
    @test runtimesecs(tr) ≈ 600
end

@testset "Construct dataset from multiple SpikeGLX .meta files" begin
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

@testset "Import JRCLUST annotation from _jrc.mat file" begin
    matfile = joinpath(ENV["TESTBASE"], "datasets", "fromjrclust", "testset_jrc.mat")
    jrcannotation = jrclustfrommat(matfile; modelname="HH2")

    @test nclusters(jrcannotation) == 200
    @test nspikes(jrcannotation) == 4302921
    @test length(channelmap(jrcannotation.probe)) == 64
    @test size(channelpositions(jrcannotation.probe)) == (64, 2)
    @test nchannels(jrcannotation.probe) == 256
    @test spikeclusters(jrcannotation)[10191] == 186
end

@testset "Import KiloSort annotation from Phy .npy files" begin
    kilosortoutputdir = joinpath(ENV["TESTBASE"], "datasets", "fromphy")
    ksannotation = kilosortfromphy(kilosortoutputdir; modelname="Neuropixels Phase 3A")

    @test nclusters(ksannotation) == 347
    @test nspikes(ksannotation) == 8938169
    @test length(channelmap(ksannotation.probe)) == 374
    @test size(channelpositions(ksannotation.probe)) == (374, 2)
    @test nchannels(ksannotation.probe) == 385
    @test minimum(amplitudes(ksannotation)) ≈ 12.018919944763184
    @test maximum(amplitudes(ksannotation)) ≈ 106.52466583251953
    @test minimum(similartemplates(ksannotation)[CartesianIndex.(1:347, 1:347)]) ≈ 0.9829312
    @test maximum(similartemplates(ksannotation)[CartesianIndex.(1:347, 1:347)]) ≈ 0.98877007
    @test spiketemplates(ksannotation)[10191] == 81
end

@testset "Import annotation from KiloSort rez.mat file" begin
    rezfile = joinpath(ENV["TESTBASE"], "datasets", "fromrez", "eMouse-rez.mat")
    ksannotation = kilosortfromrezfile(rezfile; modelname="eMouse")

    @test nclusters(ksannotation) == 31
    @test nspikes(ksannotation) == 168879
    @test length(channelmap(ksannotation.probe)) == 32
    @test size(channelpositions(ksannotation.probe)) == (32, 2)
    @test minimum(amplitudes(ksannotation)) ≈ 10.027755737304688
    @test maximum(amplitudes(ksannotation)) ≈ 1.145809936523438e+02
    @test minimum(similartemplates(ksannotation)[CartesianIndex.(1:64, 1:64)]) == 0
    @test maximum(similartemplates(ksannotation)[CartesianIndex.(1:64, 1:64)]) ≈ 1.0000008 # !!
    @test spiketemplates(ksannotation)[10191] == 6
end

@testset "Import annotation from KiloSort2 rez.mat file" begin
    rezfile = joinpath(ENV["TESTBASE"], "datasets", "fromrez", "ks2-rez.mat")
    ksannotation = kilosortfromrezfile(rezfile; modelname="Neuropixels Phase 3A")

    @test nclusters(ksannotation) == 347
    @test nspikes(ksannotation) == 8938169
    @test length(channelmap(ksannotation.probe)) == 374
    @test size(channelpositions(ksannotation.probe)) == (374, 2)
    @test minimum(amplitudes(ksannotation)) ≈ 12.018919944763184
    @test maximum(amplitudes(ksannotation)) ≈ 106.52466583251953
    @test minimum(similartemplates(ksannotation)[CartesianIndex.(1:347, 1:347)]) ≈ 0.9829312
    @test maximum(similartemplates(ksannotation)[CartesianIndex.(1:347, 1:347)]) ≈ 0.98877007
    @test spiketemplates(ksannotation)[10191] == 81
end

@testset "Import a sorting from JRCLUST _jrc.mat file" begin
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
    @test sortedon(sorting) == Date("2018-09-11")

    jrcannotation = autoannotation(sorting)
    @test nclusters(jrcannotation) == 200
    @test nspikes(jrcannotation) == 4302921
    @test length(channelmap(jrcannotation.probe)) == 64
    @test size(channelpositions(jrcannotation.probe)) == (64, 2)
    @test nchannels(jrcannotation.probe) == 256
    @test spikeclusters(jrcannotation)[10191] == 186
end

@testset "Import a sorting from KiloSort rez.mat" begin
    rezfile = joinpath(ENV["TESTBASE"], "datasets", "fromrez", "eMouse-rez.mat")
    sorting = sortingfromrezfile(rezfile, programversion="0fbe8eb", runtimesecs=0,
                                 modelname="eMouse", recordedby="Shagrat", sortedby="Gorbag")
    chanmap = [8; 10; 12; 14; 16; 18; 20; 22; 24; 26; 28; 30; 32; 7; 9; 11; 13; 15; 17; 19; 21; 23; 25; 27; 29; 31; 1; 2; 3; 4; 5; 6]
    xc = [20; 0; 0; 20; 0; 20; 0; 20; 0; 20; 0; 20; 0; 20; 0; 20; 20; 0; 20; 0; 20; 0; 20; 0; 20; 0; 20; 0; 20; 0; 20; 0]
    yc = [140; 160; 180; 180; 200; 200; 220; 220; 240; 240; 260; 260; 280; 280; 300; 300; 320; 340; 340; 360; 360; 380; 380; 400; 400; 420; 420; 440; 440; 460; 460; 480]
    chanpos = [xc yc]

    @test channelmap(dataset(sorting).probe) == chanmap
    @test channelpositions(dataset(sorting).probe) == chanpos
    @test modelname(dataset(sorting).probe) == "eMouse"
    @test nchannels(dataset(sorting).probe) == 34
    @test programused(sorting) == "KiloSort"
    @test programversion(sorting) == "0fbe8eb"
    @test runtimesecs(sorting) ≈ 0
    @test sortedby(sorting) == "Gorbag"
    @test sortedon(sorting) == Date("2018-09-26")

    ksannotation = autoannotation(sorting)
    @test nclusters(ksannotation) == 31
    @test nspikes(ksannotation) == 168879
    @test length(channelmap(ksannotation.probe)) == 32
    @test size(channelpositions(ksannotation.probe)) == (32, 2)
    @test minimum(amplitudes(ksannotation)) ≈ 10.027755737304688
    @test maximum(amplitudes(ksannotation)) ≈ 1.145809936523438e+02
    @test minimum(similartemplates(ksannotation)[CartesianIndex.(1:64, 1:64)]) == 0
    @test maximum(similartemplates(ksannotation)[CartesianIndex.(1:64, 1:64)]) ≈ 1.0000008 # !!
    @test spiketemplates(ksannotation)[10191] == 6
end
@testset "Import a sorting from KiloSort2 rez.mat" begin
    rezfile = joinpath(ENV["TESTBASE"], "datasets", "fromrez", "ks2-rez.mat")
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
    @test sortedon(sorting) == Date("2018-09-26")

    ksannotation = autoannotation(sorting)
    @test nclusters(ksannotation) == 347
    @test nspikes(ksannotation) == 8938169
    @test length(channelmap(ksannotation.probe)) == 374
    @test size(channelpositions(ksannotation.probe)) == (374, 2)
    @test minimum(amplitudes(ksannotation)) ≈ 12.018919944763184
    @test maximum(amplitudes(ksannotation)) ≈ 106.52466583251953
    @test minimum(similartemplates(ksannotation)[CartesianIndex.(1:347, 1:347)]) ≈ 0.9829312
    @test maximum(similartemplates(ksannotation)[CartesianIndex.(1:347, 1:347)]) ≈ 0.98877007
    @test spiketemplates(ksannotation)[10191] == 81
end
