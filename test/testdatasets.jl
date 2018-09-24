@testset "Create Neuropixels probe from Phy" begin
    chanmapfile = joinpath(ENV["TESTBASE"], "datasets", "fromphy", "channel_map.npy")
    chanposfile = joinpath(ENV["TESTBASE"], "datasets", "fromphy", "channel_positions.npy")
    probe = probefromphy(chanmapfile, chanposfile, "Neuropixels Phase 3A", 385)
    @test length(channelmap(probe)) == 374
    @test size(channelpositions(probe)) == (374, 2)
    @test modelname(probe) == "Neuropixels Phase 3A"
    @test nchannels(probe) == 385
end

@testset "Create (naive) Neuropixels probe from SpikeGLX" begin
    metafile = joinpath(ENV["TESTBASE"], "datasets", "fromspikeglx", "anm420712_20180802_ch0-119bank1_ch120-382bank0_g0_t2.imec.ap.meta")
    probe = probefromspikeglx(metafile, "Neuropixels Phase 3A")
    @test length(channelmap(probe)) == 374
    @test size(channelpositions(probe)) == (374, 2)
    @test modelname(probe) == "Neuropixels Phase 3A"
    @test nchannels(probe) == 385
end
