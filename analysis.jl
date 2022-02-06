push!(LOAD_PATH, "C:/Users/Chris/Projects/stj2")
using Data, Currents, Recovery
#=
    unpumped curve
=#
DCₒData = loadDCₒData("C:\\Users\\Chris\\OneDrive\\Project\\IV curves data\\Unpumped_offset_corrected.csv");

#=
    pumped curve
=#
DCData = loadDCData("C:\\Users\\Chris\\OneDrive\\Project\\IV curves data\\Pumped_offset_corrected.csv", DCₒData; ν = 230.0)

# perform impedance recovery
fitVs, fitIs = File.filter(DCData.nVs, DCData.nIs, 0.6, 0.98);

nZLO, nVLO = performRecovery(DCₒData, DCData, fitVs, fitIs);

plot(DCData.nVs, DCData.nIs, xlims = (0, 2), ylims=(0, 2))

plot!([0:0.01:2;], Vₒ -> Ip(DCₒData, DCData, Vₒ, recover_nVω(DCₒData, DCData, nVLO, nZLO, Vₒ)), label = "Recovered I-V from Zemb and VLO")

# contour([0:0.01:1;], [-1:0.01:0;], (x,y) -> log10(error(x + y*im, nVs, nVωs)), fill = (true, cgrad(:speed)), lines = false)
# scatter!([min[1]], [ min[2]], label = "Zemb = 0.13 - 0.09i")