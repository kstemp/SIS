"""
	SIS tools package for julia

	Author: 	Chris Stempinski
	File:       File.jl
	
	TODO description
"""
module File

using Printf, Interpolations, Optim

export correctOffsets!
"""
    correctOffset()

TODO 

"""
function correctOffsets!(Vs::Vector{Float64}, Is::Vector{Float64})

    println("Correcting offset...")

    #=  
        the experiment data has certain offset, which means that
        the original and reflected I-V characteristics won't overlap.
        We calculate what is the error between these two curves, 
        and find Voffset, Ioffset for which it is smallest 
    =#

    function error(Voffset, Ioffset)

        myVs = Vs .- Voffset;
        myIs = Is .- Ioffset;
        
        # mirror the voltages and currents through the origin
        mirror_Vs = -reverse(copy(myVs))
        mirror_Is = -reverse(copy(myIs))

        mirror_I = LinearInterpolation(mirror_Vs, mirror_Is);
        I = LinearInterpolation(myVs, myIs);

        sum((I(V) - mirror_I(V))^2 for V in [-1:0.1:1;])
        
    end

    f(x::Vector) = error(x[1], x[2]);

    res = Optim.optimize(f, [0.1, 0.1], NelderMead());
    min = Optim.minimizer(res);

    Voffset = min[1]
    Ioffset = min[2]

    @printf("Found:\n\tVoffset: %g\n", Voffset)
    @printf("\tIoffset: %g\n", Ioffset)
    @printf("\n\tError with offsets: %g, without: %g\n", error(Voffset, Ioffset), error(0, 0))

    Vs .-= Voffset;
    Is .-= Ioffset;

    return Vs, Is;

end

export normalise

"""
    normalise(Vs, Is, Vg1, Vg2, Ig1, Ig2)

Divides the voltages by the gap voltage (for positive/negative regions)
separately, and the currents by the gap current.

"""
function normalise(Vs, Is, Vg1, Vg2, Ig1, Ig2)
    
    nVs = copy(Vs);
    @. nVs[nVs > 0] /= Vg2;
    @. nVs[nVs < 0] /= abs(Vg1);

    nIs = copy(Is);
    @. nIs[nVs > 0] /= Ig2;
    @. nIs[nVs < 0] /= Ig1;

    return nVs, nIs

end

export findVgs
"""

    findVgs(Vs, Is)

Determine the gap voltage for the parts with Vₒ < 0 and Vₒ > 0
by finding where the dynamic resistance is smallest.
"""
function findVgs(Vs, Is)

    # dynamic resistance dVₒ / dIₒ, minimum indicates the gap and onset of large
    # tunnelling current
    dynR = abs.(diff(Vs) ./ diff(Is)); 

    half = length(dynR) ÷ 2;

    il = argmin(dynR[1:half]);
    ir = argmin(dynR[half:end - 100]) + (half - 1); # to avoid problems with the weird bullshit on the far end

    @show il
    @show ir

    return Vs[il], Vs[ir];

end

export getRnsAndShift
"""

    getRnsAndShift(Vs, Is)

"""
function getRnsAndShift(Vs, Is)

    function slope_intercept(y2, y1, x2, x1) 
        s = (y2-y1)/(x2-x1)
        i = -x1*(y2-y1) / (x2-x1) + y1;

        return s, i
    end

    slope1, shift1 = slope_intercept(Is[100], Is[1], Vs[100], Vs[1])
    slope2, shift2 = slope_intercept(Is[end], Is[end-100], Vs[end], Vs[end-100])

    return 1 / slope1, shift1, 1 / slope2, shift2

end

export filter

"""
    filter(Vs, Is, low = 0.6, high = 0.95)

Helper method to filter two arrays simultaneously, based on
a condition satisfied by the elements by the first array.

"""
function filter(Vs, Is, low = 0.6, high = 0.95)
    filteredVs = [Vs[i] for i=eachindex(Vs) if (Vs[i] <= high && Vs[i] >= low)]
    filteredIs = [Is[i] for i=eachindex(Is) if (Vs[i] <= high && Vs[i] >= low)]

    return  filteredVs, filteredIs
end

end