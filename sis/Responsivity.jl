"""
	SIS tools package for julia

	Author: 	Chris Stempinski
	File:       Responsivity.jl
	
	TODO description
"""
module Responsivity

using Data, Currents, Recovery

export responsivity
"""
    Resp_actual(nVₒ, nVω, nZLO, nVLO)

Uses the power that actually reaches the junction, diminished due to the
embedding circuit.

"""
function responsivity(DCₒ::DCₒData, DC::DCData, nVₒ, nVLO, nZLO)
    
    nVω = recover_nVω(DCₒ, DC, nVLO, nZLO, nVₒ)

    ΔIdc = Ip(DCₒ, DC, nVₒ, nVω) - Idc(DCₒ, nVₒ)

    Power = nVLO^2 / (8 * real(nZLO))

    return ΔIdc / Power;

end

end