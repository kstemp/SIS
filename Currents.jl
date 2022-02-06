module Currents

using SpecialFunctions, Richardson, Data

export Idc
function Idc(DCₒ::DCₒData, nVₒ)

    if (nVₒ > 1.6)
        return nVₒ + DCₒ.shift2 / DCₒ.Ig2;
    elseif (nVₒ < -1.6)
        return nVₒ + DCₒ.shift1 / DCₒ.Ig1;
    else
        return DCₒ.nIdci(nVₒ);
    end

end

export Ikk
function Ikk(DCₒ::DCₒData, nVₒ)

    return DCₒ.Ikki(nVₒ);

end

"""
    coeff(Ifunc, m, nVₒ, nVω)

m-th order a or b (depending on whether Ifunc is Idc or Ikk) coefficient

"""
function coeff(DCₒ::DCₒData, DC::DCData, Ifunc, m, nVₒ, nVω)

    α = nVω / DC.nVₚₕ

    term(n) = besselj(n, α) * besselj(n + m, α) * Ifunc(DCₒ, nVₒ + n * DC.nVₚₕ);

    val = sum(n -> term(n), -5:1:5)

    #=val, err = Richardson.extrapolate(1, x0 = Inf) do N
        @show N
        sum(n -> term(n), -Int(N):1:Int(N))
    end=#

    # err commented out for the purposes of the fit
    return val#, err;

end

a(DCₒ::DCₒData, DC::DCData, m, nVₒ, nVω) = coeff(DCₒ, DC, Idc, m, nVₒ, nVω);

b(DCₒ::DCₒData, DC::DCData, m, nVₒ, nVω) = -coeff(DCₒ, DC, Ikk, m, nVₒ, nVω);

export Ip
"""
    Ip(nVₒ, nVω = nVₚₕ) 

DC part of the pumped I-V curve

"""
Ip(DCₒ::DCₒData, DC::DCData, nVₒ, nVω = nVₚₕ) = a(DCₒ, DC, 0, nVₒ, nVω);

export Id
"""
    Id(nVₒ, nVω = nVₚₕ)

Dissipative component of the AC part of the pumped I-V curve

"""
Id(DCₒ::DCₒData, DC::DCData, nVₒ, nVω = nVₚₕ) = a(DCₒ, DC, 1, nVₒ, nVω) + a(DCₒ, DC, -1, nVₒ, nVω);

export Ir
"""
    Ir(nVₒ, nVω = nVₚₕ) 

Reactive component of the AC part of the pumped I-V curve

"""
Ir(DCₒ::DCₒData, DC::DCData, nVₒ, nVω = nVₚₕ) = b(DCₒ, DC, 1, nVₒ, nVω) - b(DCₒ, DC, -1, nVₒ, nVω);

export Iω
"""
    Iω(nVₒ, nVω = nVₚₕ)

AC part of the pumped I-V curve

"""
Iω(DCₒ::DCₒData, DC::DCData, nVₒ, nVω = nVₚₕ) = Id(DCₒ, DC, nVₒ, nVω) + im * Ir(DCₒ, DC, nVₒ, nVω);

end