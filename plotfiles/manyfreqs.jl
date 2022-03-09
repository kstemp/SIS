fileName(ω, mm) = string("data/IV_", ω, "GHz_-30mA_", mm, "um.csv")

files = [
["210", "1_30"],
["220", "0_30"],
["230", "0_40"],
["240", "0_70"],
["250", "0_110"],
["260", "2_20"],
["270", "1_30"],
]

plot()
nVLOs = []
nZLOs = []

for f in files

	myplot(f[1], f[2])

end



function myplot(ν, driving)
	upVs, upIs = loadFile(fileName(ν, "0_00"));
	DCₒ1 = parseDCₒData(upVs, upIs; cutoff = 1.4);

	upVsp, upIsp =  loadFile(fileName(ν, driving));
	DC1 = parseDCData(upVsp, upIsp, DCₒ1;ν= parse(Float64, ν)) # NOTE CHANGE THIS TO NU

	p =plot!(upVsp, upIsp, xlims = (0, 3), ylims = (0, 0.3), linewidth = 2, label = string(ν, " GHz"))
	display(p)

	fitVs, fitIs = File.filter(DC1.nVs, DC1.nIs, 2.1 / DCₒ1.Vg2, 2.54 / DCₒ1.Vg2);

	nZLO, nVLO = performRecovery(DCₒ1, DC1, fitVs, fitIs);

	push!(nZLOs, nZLO)
	push!(nVLOs, nVLO)
end






