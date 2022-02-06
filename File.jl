module File

using DataFrames, CSV

export loadFile

"""
    loadFile(fileName, Vcutoff = 5)

Loads the specified CSV and takes ONLY THE UPSWEEP part

"""
function loadFile(fileName, Vcol = 4, Icol = 5, Vcutoff = 5)
    
    df = DataFrame(CSV.File(fileName))

    Vs = df[!, Vcol];
    Is = df[!, Icol];

    upsweepEnd = upsweepStart = 0;
    for i in 1:length(Vs)
        if (#=Vs[i] > Vs[i + 1] &&=# Vs[i] > Vcutoff)
            upsweepEnd = i;
            break;
        end
    end

    for i in length(Vs):-1:1
        if (#=Vs[i] < Vs[i + 1]=# Vs[i] < -Vcutoff)
            upsweepStart = i;
            break;
        end
    end

    @show upsweepStart
    @show upsweepEnd

    Vs_up = vcat(Vs[upsweepStart:end], Vs[1:upsweepEnd]);
    Is_up = vcat(Is[upsweepStart:end], Is[1:upsweepEnd]);

    return Vs_up, Is_up

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

    slope1, shift1 = slope_intercept(Is[500], Is[1], Vs[500], Vs[1])
    slope2, shift2 = slope_intercept(Is[end], Is[end-500], Vs[end], Vs[end-500])

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