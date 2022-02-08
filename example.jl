"""
	SIS tools package for julia

	Author: 	Chris Stempinski
	File:       example.jl
	
	TODO description
"""

push!(LOAD_PATH, "C:/Users/Chris/Projects/SIS/sis")
include("loadfile.jl")
using Data, Currents, Recovery, File, Plots, Responsivity

fileName(ω, mm) = string("data/IV_", ω, "GHz_-30mA_", mm, "um.csv")

upVs, upIs = loadFile(fileName("230", "0_00"));
DCₒ1 = parseDCₒData(upVs, upIs);

upVsp, upIsp =  loadFile(fileName("230", "0_40"));
DC1 = parseDCData(upVsp, upIsp, DCₒ1; ν = 230.0)

# perform impedance recovery=#
fitVs, fitIs = File.filter(DC1.nVs, DC1.nIs, 2 / DCₒ1.Vg2, 2.54 / DCₒ1.Vg2);

nZLO, nVLO = performRecovery(DCₒ1, DC1, fitVs, fitIs);

# example plots
plot(DCₒ1.nVs, DCₒ1.nIs, xlims = (-2, 2), ylims = (-3, 3), linewidth = 1.5, label = "Experimental unpumped I-V curve", legend = :topleft);
p = plot!(DC1.nVs, DC1.nIs, label = "Experimental pumped I-V curve" , linewidth = 1.5)
show(p)

Myi(nVₒ) = Ip(DCₒ1, DC1, nVₒ, recover_nVω(DCₒ1, DC1, nVLO, nZLO, nVₒ));

plot(DC1.nVs, DC1.nIs, xlims = (0, 1.3), ylims = (0, 2), linewidth = 1.5, label = "Experimental data", legend = :topleft);
k = plot!([0:0.005:2;], Vₒ -> Myi(Vₒ), label = "Recovered I-V from Zemb and VLO" , linewidth = 1.5)
show(k)

plot([0:0.005:2;], V -> responsivity(DCₒ1, DC1, V, nVLO, nZLO), title = "Responsivity", linewidth = 1.5, label = "Responsivity", legend = :topleft);
s = plot!(DC1.nVs, DC1.nIs, ylims = (-2, 3), xlims = (0, 2), label = "Pumped I-V curve", line = :dash)
show(s)
