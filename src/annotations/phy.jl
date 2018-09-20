include("types.jl")

# pc_features.npy
# pc_feature_ind.npy
# similar_templates.npy
# spike_templates.npy
# templates.npy
# templates_ind.npy
# templates_unw.npy
# template_features.npy
# template_feature_ind.npy
# whitening_mat.npy
# whitening_mat_inv.npy

struct PhyAnnotation <: Annotation
    amplitudes::Array{<:Integer, 1}
    probe::Probe
    spikeclusters::Array{<:Integer, 1}
    spiketimes::Array{<:Integer, 1}
end
