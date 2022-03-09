using Optim

function error2(DCₒ::DCₒData, DC::DCData, fitVs, fitIs, nZLO, nVLO, nVωs)

    nVωs_emb = []

    for nV in fitVs
        nVω_emb = recover_nVω(DCₒ, DC, nVLO, nZLO, nV);
        push!(nVωs_emb, nVω_emb)
    end
    
    error = sum((nVωs .- nVωs_emb) .^ 2)

    return error;

end

function performRecovery2(DCₒ::DCₒData, DC::DCData, fitVs, fitIs)

    nVωs = recover_nVωs(DCₒ, DC, fitVs, fitIs);
    
    f(x::Vector) = error2(DCₒ, DC, fitVs, fitIs, x[1] + im * x[2], x[3], nVωs);

    res = Optim.optimize(f, [0.5; -0.5; 0.5]);
    min = Optim.minimizer(res);

    return min[1] + im * min[2], min[3];

end
