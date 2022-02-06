"""
	SIS tools package for julia

	Author: 	Chris Stempinski
	File:       example.jl
	
	TODO description
"""

push!(LOAD_PATH, "C:/Users/Chris/Projects/SIS/sis")
using Data, Currents, Recovery, File, Plots

# load un-pumped and pumped I-V curves
DCₒ = loadDCₒData("C:\\Users\\Chris\\OneDrive\\Project\\IV curves data\\Unpumped_offset_corrected.csv");

DC = loadDCData("C:\\Users\\Chris\\OneDrive\\Project\\IV curves data\\Pumped_offset_corrected.csv", DCₒ; ν = 230.0)

# perform impedance recovery
fitVs, fitIs = File.filter(DC.nVs, DC.nIs, 0.6, 0.98);

nZLO, nVLO = performRecovery(DCₒ, DC, fitVs, fitIs);

# plot the recovered, pumped I-V curve
plot(DC.nVs, DC.nIs, xlims = (0, 2), ylims=(0, 2))
plot!([0:0.01:2;], Vₒ -> Ip(DCₒ, DC, Vₒ, recover_nVω(DCₒ, DC, nVLO, nZLO, Vₒ)), label = "Recovered I-V from Zemb and VLO")

# contour([0:0.01:1;], [-1:0.01:0;], (x,y) -> log10(error(x + y*im, nVs, nVωs)), fill = (true, cgrad(:speed)), lines = false)
# scatter!([min[1]], [ min[2]], label = "Zemb = 0.13 - 0.09i")