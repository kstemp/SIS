"""
	SIS tools package for julia

	Author: 	Chris Stempinski
	File:       Responsivity.jl
	
	TODO description
"""

"""
    Responsivity(P, Vₒ)

Computes the responsivity ΔIdc/P(Vₒ) at specified bias point Vₒ.
P is a function specifying available/actual power into the junction.

"""
function Responsivity(P, nVₒ)

    ΔIdc = 0.5 * (Idc(nVₒ + nVₚₕ) - 2 * Idc(nVₒ) + Idc(nVₒ - nVₚₕ));

    return ΔIdc / P(nVₒ);

end

"""
    Resp_avail(nVₒ, nVω)

Uses the available power for responsivity calculations.

"""
function Resp_avail(nVₒ, nVω)

    P(nVₒ) = 0.5 * nVω * Id(nVₒ, nVω);

    return Responsivity(P, nVₒ)

end

"""
    Resp_actual(nVₒ, nVω, nZLO, nVLO)

Uses the power that actually reaches the junction, diminished due to the
embedding circuit.

"""
function Resp_actual(nVₒ, nVω, nZLO, nVLO)

    Power(nVₒ) = nVω^2 / (nVLO / Iω(nVₒ, nVω) - nZLO)    

    return Responsivity(Power, nVₒ)

end