using File, DataFrames, CSV, Loess

"""
    loadFile(fileName, Vcutoff = 5)

This is a helper method that SHOULD NOT in general be used when performing analysis
on arbitrary experimental data, as it makes a number of assumptions about the 
structure of the CSV file. 

"""
function loadFile(fileName; Vcol = 2, Icol = 3, Vcutoff = 5, smooth = true)
    
    df = DataFrame(CSV.File(fileName, delim = ",", limit = 12000, header = false, types=Dict(1=>String, 2=>Float64, 3=>Float64)))

    Vs = df[!, Vcol];
    Is = df[!, Icol];

    upsweepEnd = upsweepStart = 0;
    for i in 1:length(Vs)
        if (Vs[i] > Vcutoff)
            upsweepEnd = i;
            break;
        end
    end

    for i in length(Vs):-1:1
        if (Vs[i] < -Vcutoff)
            upsweepStart = i;
            break;
        end
    end

    #=@show upsweepStart
    @show upsweepEnd=#

    Vs_up = vcat(Vs[upsweepStart:end], Vs[1:upsweepEnd]);
    Is_up = vcat(Is[upsweepStart:end], Is[1:upsweepEnd]);

    if (smooth)

    # Loess smoothing
        model = loess(Vs_up, Is_up, span=0.01)
        us = range(extrema(Vs_up)...; step = 0.01)
        vs = predict(model, us)

        return [us;], vs ./ 1000 

    else

        return Vs_up, Is_up ./ 1000

    end

end