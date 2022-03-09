
push!(LOAD_PATH, "C:/Users/Chris/Projects/SIS/sis")
include("loadfile.jl")
using Data, Currents, Recovery, File, Plots, Responsivity



using Interpolations, LaTeXStrings;

upVs, upIs = loadFile("data/chopper/IV_230GHz_unpumped_1_35.csv"; Vcutoff = 4);#(fileName("230", "0_00"));
DCₒ1 = parseDCₒData(upVs, upIs; cutoff = 1.4);

upVsp, upIsp =  loadFile("data/chopper/IV_230GHz_pumped_1_35.csv"; Vcutoff = 4);#(fileName("230", "0_40"));
DC1 = parseDCData(upVsp, upIsp, DCₒ1; ν = 230.0)

fitVs, fitIs = File.filter(DC1.nVs, DC1.nIs, 2.1 / DCₒ1.Vg2, 2.54 / DCₒ1.Vg2);

nZLO, nVLO = performRecovery(DCₒ1, DC1, fitVs, fitIs);

df = DataFrame(CSV.File("data/chopper/lockin.csv", delim = ",", limit = 12000, header = true, types=Dict(1=>Float64, 2=>Float64, 3=>Float64)))

Vschopper = df[!, 3] .- 0.080968;
Ischopper = df[!, 2];

nVsc = Vschopper / DCₒ1.Vg2;
nIsc = Ischopper / DCₒ1.Ig2;

ΔIdci = LinearInterpolation(nVsc, nIsc ./ 10000);

plot(DC1.nVs, abs.(DCₒ1.nIs .- DC1.nIs), xlims = (0, 1.5), label = "Separate measurements", legend = :topleft, ylims = (0, 0.5), xlabel = L"$V_o~/~V_{\mathrm{g}}$", ylabel= L"$|\Delta I_{\mathrm{dc}}|~/~I_{\mathrm{g}}$")

plot!([0:0.005:2;], V -> abs(ΔIdc(DCₒ1, DC1, V, recover_nVω(DCₒ1, DC1, nVLO, nZLO, V))), xlims = (0, 1.5), label = L"With fitted $I_{\mathrm{dc}}$")

scatter!(nVsc, nIsc ./ 10000, label = "Lock-in", markersize = 1.5)

savefig("09 Delta Idc comparison.pdf")


function responsivity(DCₒ::DCₒData, DC::DCData, nVₒ, nVLO, nZLO, useAbsorbedPower = true)
    
    nVω = recover_nVω(DCₒ, DC, nVLO, nZLO, nVₒ)

    Power = 0;

    if useAbsorbedPower
        Power = 0.5 * abs(nVω) * Id(DCₒ, DC, nVₒ, nVω); 
    else
        Power =(nVLO)^2 / (8 * real(nZLO));
    end

    return ΔIdci(nVₒ) / Power;

end

function NEP(DCₒ::DCₒData, DC::DCData, nVₒ, nVLO, nZLO)

	R = responsivity(DCₒ, DC, nVₒ, nVLO, nZLO, false);

    return sqrt(Idc(DCₒ, nVₒ)) / R;

end

plot([0.1:0.01:1.7;], V -> abs(responsivity(DCₒ1, DC1, V, nVLO, nZLO, true)) , label = "Absorbed", legend = :topleft,  xlims = (0, 1.5), ylims = (0, 3), xlabel = L"$V_o~/~V_{\mathrm{g}}$", ylabel= L"$|\Delta I_{\mathrm{dc}}|~/~P$");
plot!([0.1:0.01:1.7;], V -> abs(responsivity(DCₒ1, DC1, V, nVLO * 0.8, nZLO, false)) , label = "Available")
plot!(DC1.nVs, DC1.nIs, label = L"$I_{\mathrm{dc}}$", line = :dash, linewidth = 0.7)
#hline!([1  /DC1.nVₚₕ], label = "")
savefig("10 responsivities.pdf")

plot([0.1:0.01:1.7;], V -> abs(responsivity(DCₒ1, DC1, V, nVLO * 0.8, nZLO, false)),  label = "Responsivity",  xlabel = L"$V_o~/~V_{\mathrm{g}}$", right_margin = 5Plots.mm, xlims = (0, 1.5), ylims = (0, 3), ylabel = "Responsivity")
plot!([], [], color = 2, label = "NEP")
plot!(twinx(), [0.75:0.01:1.25;], V -> NEP(DCₒ1, DC1, V, nVLO, nZLO) , legend = false, xticks = [], ylabel= "NEP [arbitrary units]", color = 2)

savefig("11 NEP.pdf")


plot([0:0.01:2;], V -> abs(ΔIdc(DCₒ1, DC1, V, recover_nVω(DCₒ1, DC1, nVLO, nZLO, V))), xlims = (0, 1.5), ylims = (0, 0.5), label = L"$|I_{\mathrm{dc}}-I_{\mathrm{dc}}^o|$", legend = :topleft)
plot!([0:0.01:2;], V -> abs(ΔIdc2(DCₒ1, DC1, V, recover_nVω(DCₒ1, DC1, nVLO, nZLO, V))), label = "Small-signal")
xlabel!(L"$V_o~/~V_{\mathrm{g}}$")
ylabel!(L"$|\Delta I_{\mathrm{dc}}|~/~I_{\mathrm{g}}$")

savefig("12 delta I small signal.pdf")