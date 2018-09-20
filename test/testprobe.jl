@testset "Create Neuropixels probe from Phy" begin
    chanmapfile = joinpath(ENV["DATADIR"], "channel_map.npy")
    chanposfile = joinpath(ENV["DATADIR"], "channel_positions.npy")
    probe = ProbeTools.fromphy(chanmapfile, chanposfile, 385)
    @test length(ProbeTools.channelmap(probe)) == 374
    @test size(ProbeTools.channelpositions(probe)) == (374, 2)
    @test ProbeTools.nchannels(probe) == 385
end
