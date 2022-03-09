"""
	SIS tools package for julia

	Author: 	Chris Stempinski
	File:       Responsivity.jl
	
	TODO description
"""
module Responsivity

using Data, Currents, Recovery

export ΔIdc
"""
    ΔIdc(DCₒ, DC, nVₒ, nVω)

"""
ΔIdc(DCₒ, DC, nVₒ, nVω) = Ip(DCₒ, DC, nVₒ, nVω) - Idc(DCₒ, nVₒ);

export ΔIdc_small
"""
    ΔIdc_small(DCₒ, DC, nVₒ, nVω)

"""
ΔIdc_small(DCₒ, DC, nVₒ, nVω) = 0.25 * (nVω)^2 * (Idc(DCₒ, nVₒ + DC.nVₚₕ) - 2 * Idc(DCₒ, nVₒ) + Idc(DCₒ, nVₒ - DC.nVₚₕ)) / (DC.nVₚₕ)^2;

export responsivity
"""
    Resp_actual(nVₒ, nVω, nZLO, nVLO)

Uses the power that actually reaches the junction, diminished due to the
embedding circuit.

formulas taken from Wittington TODO check paper, 7 and 8

"""
function responsivity(DCₒ::DCₒData, DC::DCData, nVₒ, nVLO, nZLO, useAbsorbedPower = true)
    
    nVω = recover_nVω(DCₒ, DC, nVLO, nZLO, nVₒ)

    Power = 0;

    if useAbsorbedPower
        Power = 0.5 * abs(nVω) * Id(DCₒ, DC, nVₒ, nVω); 
    else
        Power =(nVLO)^2 / (8 * real(nZLO));
    end

    return ΔIdc(DCₒ, DC, nVₒ, nVω) / Power;

end

end