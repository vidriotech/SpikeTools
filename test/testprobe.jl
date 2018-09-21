@testset "Create Neuropixels probe from Phy" begin
    chanmapfile = joinpath(ENV["DATADIR"], "channel_map.npy")
    chanposfile = joinpath(ENV["DATADIR"], "channel_positions.npy")
    probe = probefromphy(chanmapfile, chanposfile, "Neuropixels Phase 3A", 385)
    @test length(channelmap(probe)) == 374
    @test size(channelpositions(probe)) == (374, 2)
    @test modelname(probe) == "Neuropixels Phase 3A"
    @test nchannels(probe) == 385
end
