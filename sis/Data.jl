"""
    SIS tools package for julia

    Author: 	Chris Stempinski
    File:       Data.jl

    TODO description
"""
module Data

using File, Interpolations, DSP, FFTW

export DCₒData

struct DCₒData

    nVs     ::Vector{Float64};
    nIs     ::Vector{Float64};

    Vg1     ::Float64;
    Vg2     ::Float64;

    Rn1     ::Float64;
    shift1  ::Float64;
    Rn2     ::Float64;
    shift2  ::Float64;

    Ig1     ::Float64;
    Ig2     ::Float64;

    nIdci;
    Ikki;

end

export parseDCₒData

function parseDCₒData(Vs::Vector{Float64}, Is::Vector{Float64}; correctOffsets = true)::DCₒData

    if correctOffsets
        correctOffsets!(Vs, Is)
    end

    Vg1, Vg2 = findVgs(Vs, Is);

    Rn1, shift1, Rn2, shift2 = getRnsAndShift(Vs, Is)

    Ig1 = abs(Vg1) / Rn1;
    Ig2 = Vg2 / Rn2;

    nVs, nIs = normalise(Vs, Is, Vg1, Vg2, Ig1, Ig2);

    nIdci = LinearInterpolation(nVs, nIs);

    #=
        compute the Kramers-Kronig transform

        TODO: refactor into separate method
        TODO: get rid of the myIdc function, it's a duplicate
    =#
    Vsk = [-100:0.005:100;]

    function myIdc(nVₒ)

        if (nVₒ > 1.6)
            return nVₒ + shift2 / Ig2;
        elseif (nVₒ < -1.6)
            return nVₒ + shift1 / Ig1;
        else
            return nIdci(nVₒ);
        end

    end

    f(nVₒ) = myIdc(nVₒ) - (nVₒ > 0 ? (nVₒ + shift2 / Ig2) : (nVₒ + shift1 / Ig1))

    Fourier = fft(f.(Vsk))

    @. Fourier *= (-im * sign(Vsk))

    Ikks = real(ifft(Fourier));

    Ikki = LinearInterpolation(Vsk, Ikks)

    return DCₒData(nVs, nIs, Vg1, Vg2, Rn1, shift1, Rn2, shift2, Ig1, Ig2, nIdci, Ikki);

end

export DCData

struct DCData

    nVs     ::Vector{Float64};
    nIs     ::Vector{Float64};

    ν       ::Float64;
    nVₚₕ     ::Float64;

end

export parseDCData

function parseDCData(Vs::Vector{Float64}, Is::Vector{Float64}, DCₒ::DCₒData; ν::Float64 = 230.0, correctOffsets = true)::DCData

    if correctOffsets
        correctOffsets!(Vs, Is)
    end

    nVs, nIs = normalise(Vs, Is, DCₒ.Vg1, DCₒ.Vg2, DCₒ.Ig1, DCₒ.Ig2);
 
    nVₚₕ = 2π * 6.582e-4 * ν / DCₒ.Vg2;

    return DCData(nVs, nIs, ν, nVₚₕ);

end

end