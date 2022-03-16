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

include("plotfiles/files.jl")

nVLOs_210, nZLOs_210 = recoverImpedances(files_210);
nVLOs_220, nZLOs_220 = recoverImpedances(files_220_2);
nVLOs_230, nZLOs_230 = recoverImpedances(files_230);
nVLOs_240, nZLOs_240 = recoverImpedances(files_240);
nVLOs_250, nZLOs_250 = recoverImpedances(files_250);
nVLOs_260, nZLOs_260 = recoverImpedances(files_260);

at210 = [70:10:150;] ./ 70 .- 1
at220 = [10:10:50;] ./ 10 .- 1
at230 = [20, 30, 40, 50, 65, 70] ./ 20 .- 1
at240 = [10:10:70;] ./ 10 .- 1
at250 = [70:10:130;] ./ 70 .- 1
at260 = [200:10:260;] ./ 200 .- 1


function plotFitAt(at, nVLOs, color)

    @. model(t, p) = p[2] + p[1] * t

    p0 = [0.3, 0.5, 0.5, 0.1]
    
    fit = curve_fit(model, at, nVLOs, p0)
    
    p = fit.param
    
    display(plot!([0:0.01:8;], t -> model(t, p), color = color, label = "", linewidth = 0.7))

	push!(p1s, p[1])
	push!(p2s, p[2])

end

scatter(at210, nVLOs_210, label = "210", legend = :outerright, legendtitle = L"$\nu$ [GHz]", legendtitlefontsize = 8, markersize = 2)
scatter!(at220, nVLOs_220, label = "220", markersize = 2)
scatter!(at230, nVLOs_230, label = "230", markersize = 2)
scatter!(at240, nVLOs_240, label = "240", markersize = 2)
scatter!(at250, nVLOs_250, label = "250", markersize = 2)
scatter!(at260, nVLOs_260, label = "260", markersize = 2)


p1s = []
p2s = []
plotFitAt(at210, nVLOs_210, 1)
plotFitAt(at220, nVLOs_220, 2)
plotFitAt(at230, nVLOs_230, 3)
plotFitAt(at240, nVLOs_240, 4)
plotFitAt(at250, nVLOs_250, 5)
plotFitAt(at260, nVLOs_260, 6)

ylims!(0, 0.8)
xlabel!("Attenuator setting (normalised)")
ylabel!(L"V_{\mathrm{LO}}^{\mathrm{T}}~/~V_{\mathrm{g}}")
xlims!(0, 8)

savefig("attenuator normalised.pdf")

νs = [210:10:260;]

@. model(t, p) = p[1] + p[2] * t + p[3] * t^2
p0 = [0.3, 0.5, 0.8]
    
fit1 = curve_fit(model, νs, p1s, p0)
p1 = fit1.param

fit2 = curve_fit(model, νs, p2s, p0)
p2 = fit2.param


scatter(νs, p1s, markersize = 3, xlims = (205, 265), ylims  =(-1, 2), label = "", xlabel = L"$\nu$ [GHz]", ylabel = "Slope")
plot!([200:1:260;], t -> model(t, p1), linewidth  = 0.7, color = 1)


plot!([200:1:260;], t -> model(t, p2), linewidth  = 0.7, color = 2)


scatter(νs, p2s, markersize = 3, label = "Slope")


savefig("attenuator fit.pdf")

dat210 = nVLOs_210 .- p1s[1]
dat220 = nVLOs_220 .- p1s[2]
dat230 = nVLOs_230 .- p1s[3]
dat240 = nVLOs_240 .- p1s[4]
dat250 = nVLOs_250 .- p1s[5]
dat260 = nVLOs_260 .- p1s[6]

scatter(at210,  nVLOs_210, label = "210", legend = :outerright, legendtitle = L"$\nu$ [GHz]", legendtitlefontsize = 8, markersize = 2)
scatter!(at220, nVLOs_220, label = "220", markersize = 2)
scatter!(at230, nVLOs_230, label = "230", markersize = 2)
scatter!(at240, nVLOs_240, label = "240", markersize = 2)
scatter!(at250, nVLOs_250, label = "250", markersize = 2)
scatter!(at260, nVLOs_260, label = "260", markersize = 2)

plot!([0:1:8;], t -> t * p2s[1], color = 1, label = "", linewidth = 0.7)
plot!([0:1:8;], t -> t * p2s[2], color = 2, label = "", linewidth = 0.7)
plot!([0:1:8;], t -> t * p2s[3], color = 3, label = "", linewidth = 0.7)
plot!([0:1:8;], t -> t * p2s[4], color = 4, label = "", linewidth = 0.7)
plot!([0:1:8;], t -> t * p2s[5], color = 5, label = "", linewidth = 0.7)
plot!([0:1:8;], t -> t * p2s[6], color = 6, label = "", linewidth = 0.7)


ylims!(0, 3)
xlabel!("Attenuator setting (normalised)")
ylabel!(L"V_{\mathrm{LO}}^{\mathrm{T}}~/~V_{\mathrm{g}}")
xlims!(0, 8)