fileName(ω, mm) = string("data/IV_", ω, "GHz_-30mA_", mm, "um.csv")

function recoverImpedances(files)

	nVLOs = []
	nZLOs = []
	for f in files
	
		nVLO, nZLO = myplot(f[1], f[2])
	
		push!(nZLOs, nZLO)
		push!(nVLOs, nVLO)
	
	end

	return nVLOs, nZLOs

end

#plot()

function myplot(ν, driving)
	upVs, upIs = loadFile(fileName(ν, "0_00"));
	DCₒ1 = parseDCₒData(upVs, upIs; cutoff = 1.4);

	upVsp, upIsp =  loadFile(fileName(ν, driving));
	DC1 = parseDCData(upVsp, upIsp, DCₒ1; ν= parse(Float64, ν)) 
	fitVs, fitIs = File.filter(DC1.nVs, DC1.nIs, 2.1 / DCₒ1.Vg2, 2.54 / DCₒ1.Vg2);

	p =plot!(DC1.nVs, DC1.nIs, linewidth = 2, label = string(ν, " GHz"))
	display(p)
	s = scatter!(fitVs, fitIs, xlims = (0, 1.5), ylims = (0, 2))
	display(s)

	nZLO, nVLO = performRecovery(DCₒ1, DC1, fitVs, fitIs);

	return nVLO, nZLO
end

files_210 = [["210", "0_70"],["210", "0_80"],["210", "0_90"],["210", "1_00"],["210", "1_10"],["210", "1_20"],["210", "1_30"],["210", "1_40"],["210", "1_50"]]

files_220 = [["220", "0_10"],["220", "0_20"],["220", "0_30"],["220", "0_40"],["220", "0_50"],["220", "0_60"],["220", "0_70"],["220", "0_80"]]

files_230 = [["230", "0_10"],["230", "0_20"],["230", "0_30"],["230", "0_40"],["230", "0_50"],["230", "0_65"],["230", "0_70"]]

files_240 = [["240", "0_10"],["240", "0_20"],["240", "0_30"],["240", "0_40"],["240", "0_50"],["240", "0_60"],["240", "0_70"]]

files_250 = [["250", "0_70"],["250", "0_80"],["250", "0_90"],["250", "0_100"],["250", "0_110"],["250", "0_120"],["250", "0_130"]]

files_260 = [["260", "2_00"],["260", "2_10"],["260", "2_20"],["260", "2_30"],["260", "2_40"],["260", "2_50"],["260", "2_60"]]

nVLOs_210, nZLOs_210 = recoverImpedances(files_210);
nVLOs_220, nZLOs_220 = recoverImpedances(files_220);
nVLOs_230, nZLOs_230 = recoverImpedances(files_230);
nVLOs_240, nZLOs_240 = recoverImpedances(files_240);
nVLOs_250, nZLOs_250 = recoverImpedances(files_250);
nVLOs_260, nZLOs_260 = recoverImpedances(files_260);

plot([70:10:150;] ./ 70, nVLOs_210, label = "210", legend = :outerright, legendtitle = "Frequency [GHz]", legendtitlefontsize = 8, marker = :dot, line = :solid, markersize = 2)
plot!([10:10:80;] ./ 10, nVLOs_220, label = "220", marker = :dot, line = :solid, markersize = 2)
plot!([20, 30, 40, 50, 65, 70] ./ 20, nVLOs_230[2:end], label = "230", marker = :dot, line = :solid, markersize = 2)
plot!([10:10:70;] ./ 10, nVLOs_240, label = "240", marker = :dot, line = :solid, markersize = 2)
plot!([70:10:130;] ./ 70, nVLOs_250, label = "250", marker = :dot, line = :solid, markersize = 2)
plot!([200:10:260;] ./ 200, nVLOs_260, label = "260", marker = :dot, line = :solid, markersize = 2)
ylims!(0, 0.8)
xlabel!("Attenuator setting (normalised)")
ylabel!(L"V_{\mathrm{LO}}^{\mathrm{T}}~/~V_{\mathrm{g}}")
xlims!(0, 9)

savefig("attenuator normalised.pdf")