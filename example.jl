"""
	SIS tools package for julia

	Author: 	Chris Stempinski
	File:       example.jl
	
	TODO description
"""

push!(LOAD_PATH, "C:/Users/Chris/Projects/SIS/sis")
include("loadfile.jl")
using Data, Currents, Recovery, File, Plots, Responsivity

#fileName(ω, mm) = string("data/IV_", ω, "GHz_-30mA_", mm, "um.csv")

#=
upVs, upIs = loadFile("data/chopper/IV_230GHz_unpumped_1_35.csv"; Vcutoff = 4);#(fileName("230", "0_00"));
DCₒ1 = parseDCₒData(upVs, upIs; cutoff = 1.4);

upVsp, upIsp =  loadFile("data/chopper/IV_230GHz_pumped_1_35.csv"; Vcutoff = 4);#(fileName("230", "0_40"));
DC1 = parseDCData(upVsp, upIsp, DCₒ1; ν = 230.0)

# perform impedance recovery
fitVs, fitIs = File.filter(DC1.nVs, DC1.nIs, 1.9 / DCₒ1.Vg2, 2.47 #=2.54=# / DCₒ1.Vg2);

nZLO, nVLO = performRecovery(DCₒ1, DC1, fitVs, fitIs);
=#
#=
# example plots
plot(DCₒ1.nVs, DCₒ1.nIs, xlims = (-2, 2), ylims = (-3, 3), linewidth = 1.5, label = "Experimental unpumped I-V curve", legend = :topleft);
plot!(DC1.nVs, DC1.nIs, label = "Experimental pumped I-V curve" , linewidth = 1.5)

Myi(nVₒ) = Ip(DCₒ1, DC1, nVₒ, recover_nVω(DCₒ1, DC1, nVLO, nZLO, nVₒ));

plot(DC1.nVs, DC1.nIs, xlims = (0, 1.3), ylims = (0, 2), linewidth = 1.5, label = "Experimental data", legend = :topleft)
plot!([0:0.005:2;], Vₒ -> Myi(Vₒ), label = "Recovered I-V from Zemb and VLO" , linewidth = 1.5)




df = DataFrame(CSV.File("data/chopper/lockin.csv", delim = ",", limit = 12000, header = true, types=Dict(1=>Float64, 2=>Float64, 3=>Float64)))

Vschopper = df[!, 3];
Ischopper = df[!, 2];

nVsc = Vschopper / DCₒ1.Vg2;
nIsc = Ischopper / DCₒ1.Ig2;;
=#

#=

plot(DC1.nVs, abs.(DCₒ1.nIs .- DC1.nIs), xlims = (0, 1.5), label = "From separately measured pumped/unpumped curves", legend = :topleft, ylims = (0, 0.5))

plot!([0:0.005:2;], V -> ΔIdc(DCₒ1, DC1, V, recover_nVω(DCₒ1, DC1, nVLO, nZLO, V)), xlims = (0, 1.5), label = "From the fit");

scatter!(nVsc .- 0.0853071 / DCₒ1.Vg2, nIsc ./ 10000, label = "From chopper", markersize = 2.5)

=#

#=
plot([0:0.005:2;], V -> abs(responsivity2(DCₒ1, DC1, V, nVLO, nZLO, true)) ,linewidth = 1.5, label = "Absorbed power", legend = :topright, ylims = (0, 3));
plot!([0:0.005:2;], V -> abs(responsivity2(DCₒ1, DC1, V, nVLO, nZLO, false)) ,linewidth = 1.5, label = "Available power");
plot!(DC1.nVs, DC1.nIs, xlims = (0, 1.5), label = "Pumped I-V curve", line = :dash)

hline!([1  /DC1.nVₚₕ], label = "Quantum limit")
=#