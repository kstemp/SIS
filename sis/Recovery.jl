"""
	SIS tools package for julia

	Author: 	Chris Stempinski
	File:       Recovery.jl
	
	TODO description
"""
module Recovery

using Printf, Roots, Optim, Currents, Data

"""
    recover_nVωs(nVs, nIs, guess = 1.0)

Recover the local oscillator / photon "amplitudes" for a given set of bias points
from the pumped I-V curve.

"""
function recover_nVωs(DCₒ::DCₒData, DC::DCData, fitVs, fitIs)

    nVωs = []

    for (nVₒ, nI) in zip(fitVs, fitIs)
        nVω = find_zero(nVω -> Ip(DCₒ, DC, nVₒ, nVω) - nI, 0.5)
        push!(nVωs, nVω)

        #@show nVₒ, nI, nVω
    end

    return nVωs;

end

"""
    error(nZLO, nVs, nVωs)

Compute the error for given nZLO, 

"""
function error(DCₒ::DCₒData, DC::DCData, nZLO, nVs, nVωs)

    term1 = term2 = term3 = 0;

    for (nVₒ, nVω) in zip(nVs, nVωs)

        nZω = nVω / Iω(DCₒ, DC, nVₒ, nVω);

        term1 += nVω^2;
        term2 += abs(nZω * nVω / (nZLO + nZω));
        term3 += abs2(nZω / (nZLO + nZω));

    end

    return term1 - term2^2 / term3;

end

"""
    find_nZLO(nZLO0, nVs, nVωs)

Apply the Nelder-Mead method to pinpoint ZLO that minimizes the error function
for given set of (nVₒ, nVω)

"""
function find_nZLO(DCₒ::DCₒData, DC::DCData, nZLO0, nVs, nVωs)
    
    f(x::Vector) = error(DCₒ, DC, x[1] + im * x[2], nVs, nVωs);

    res = Optim.optimize(f, [real(nZLO0), imag(nZLO0)], NelderMead());
    min = Optim.minimizer(res);

    return min[1] + im * min[2];

end

"""
    recover_nVLO(nZLO, nVs, nVωs)

Compute the optimal nVLO (in the least-squares sense) given the recover 
embedding impedance.

"""
function recover_nVLO(DCₒ::DCₒData, DC::DCData, nZLO, nVs, nVωs)

    term1 = term2 = 0;

    for (nVₒ, nVω) in zip(nVs, nVωs)

        nZω = nVω / Iω(DCₒ, DC, nVₒ, nVω);

        term1 += abs(nZω * nVω / (nZLO + nZω));
        term2 += abs2(nZω / (nZLO + nZω));

    end

    return term1 / term2;

end

export recover_nVω
"""
    recover_nVω(nVLO, nZLO, nVₒ)

Find the nVω from the Kirchhoff's equation for a given bias point, and having
computed nVLO and nZLO

"""
function recover_nVω(DCₒ::DCₒData, DC::DCData, nVLO, nZLO, nVₒ)

    Δ(nVω) = nVLO^2 - abs2(nVω + Iω(DCₒ, DC, nVₒ, nVω) * nZLO);

    return find_zero(Δ, (0, 1), Bisection())

end

export performRecovery
"""
    performRecovery(nVs, nIs)

Helper method for recovering the embedding impedance given a set of bias points
(nV⁽ⁱ⁾, nI⁽ⁱ⁾). 

"""
function performRecovery(DCₒ::DCₒData, DC::DCData, fitVs, fitIs)

    @printf("Performing impedance recovery...\n");

    nVωs = recover_nVωs(DCₒ, DC, fitVs, fitIs);

    nZLO = find_nZLO(DCₒ, DC, 1 - 0.5im, fitVs, nVωs)
    
    nVLO = recover_nVLO(DCₒ, DC, nZLO, fitVs, nVωs)

    @printf("Found (normalised):\n\tnZemb: %g + %gi\n\tnVLO = %g\n", real(nZLO), imag(nZLO), nVLO);
    
    @printf("Found:\n\tZemb: (%g + %gi) Ω\n\tVLO = %g mV\n", DCₒ.Rn2 * real(nZLO), DCₒ.Rn2 * imag(nZLO), DCₒ.Vg2 * nVLO);
    
    return nZLO, nVLO;

end

end