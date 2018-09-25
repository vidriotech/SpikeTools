@testset "Import KiloSort annotations from .npy files" begin
    ksannotation = loadkilosort(joinpath(ENV["TESTBASE"], "annotations", "kilosort-phy"))

    @test nclusters(ksannotation) == 358
    @test nspikes(ksannotation) == 9014015
    @test length(channelmap(Annotations.probe(ksannotation))) == 374
    @test size(channelpositions(Annotations.probe(ksannotation))) == (374, 2)
    @test minimum(amplitudes(ksannotation)) ≈ 12.003653526306152
    @test maximum(amplitudes(ksannotation)) ≈ 106.51536560058594
    @test minimum(similartemplates(ksannotation)[CartesianIndex.(1:358, 1:358)]) ≈ 0.9828815f0
    @test maximum(similartemplates(ksannotation)[CartesianIndex.(1:358, 1:358)]) ≈ 0.98868686f0
    @test spiketemplates(ksannotation)[10191] == 24
end
