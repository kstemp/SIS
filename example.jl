"""
	SIS tools package for julia

	Author: 	Chris Stempinski
	File:       example.jl
	
	TODO description
"""

push!(LOAD_PATH, "C:/Users/Chris/Projects/SIS/sis")
include("loadfile.jl")
using Data, Currents, Recovery, File, Plots

using Optim

plotVs, plotIs = File.filter(DC1.nVs, DC1.nIs, 0.78, 1);

function findMaxErr(low = 0.78, high = 0.95, Wit = true)

	fitVs, fitIs = File.filter(DC1.nVs, DC1.nIs, low, high)#1.9 / DCₒ1.Vg2, 2.74 / DCₒ1.Vg2);

	nZLO, nVLO = Wit ? performRecovery(DCₒ1, DC1, fitVs, fitIs) :  performRecovery2(DCₒ1, DC1, fitVs, fitIs);

	Myi(nVₒ) = Ip(DCₒ1, DC1, nVₒ, recover_nVω(DCₒ1, DC1, nVLO, nZLO, nVₒ));
	
	plot(DC1.nVs, DC1.nIs, xlims = (0, 2), ylims = (0, 3))
p=	plot!(DC1.nVs, Myi.(DC1.nVs), label = "Simulated")
display(p)

	errors =  abs.(Myi.(plotVs) .- plotIs)

	#plot(plotVs, errors, xlims = (0, 2), ylims = (-0.2, 0.2))

	maxErr = maximum(errors)

	return maxErr, nZLO, nVLO

end

lhs = [[0.78, 0.8], 
[0.78, 0.81], 
[0.78, 0.82],
[0.78, 0.83], 
[0.78, 0.84],
[0.78, 0.85], 
[0.78, 0.86],
[0.78, 0.87], 
[0.78, 0.88],
[0.78, 0.89], 
[0.78, 0.90],
[0.78, 0.91], 
[0.78, 0.92],
[0.78, 0.93],
[0.78, 0.94],
[0.78, 0.95],
[0.78, 0.96],
[0.78, 0.97],
[0.78, 0.98],
[0.78, 0.99],
[0.78, 1.0],
]

hs  = []
errs = []
nZLOs = []
nVLOs = []

for lh in lhs

	try 
		err, nZLO, nVLO = findMaxErr(lh[1], lh[2], true);

		push!(hs, lh[2])
		push!(errs, err)
		push!(nZLOs, nZLO)
		push!(nVLOs, nVLO)
	catch err	
		@show lh[2]
	end

end

a=2

default(size = (300.449, 153.63))

plot(DC1.nVs, DC1.nIs, 
	xlims = (0, 1.1), 
	ylims = (0, 2),
	ylabel = L"I_{\mathrm{dc}}~/~I_{\mathrm{g}}",
	xlabel = L"V_{o}~/~V_{\mathrm{g}}",
	right_margin = 11Plots.mm,
	legend = :topleft,
	label = L"I_{\mathrm{dc}}^{(\mathrm{exp})}"
	)

rectangle(w, h, x, y) = Shape(x .+ [0,w,w,0], y .+ [0,0,h,h])

width = (1-0.78) + 0.01;
height = 0.58;

plot!(rectangle(width, height, 0.77 , 0.32), 
	opacity=.4,
	color = :pink, 
	label = "Error interval")

a2 = twinx()

scatter!(a2, hs, errs,
	 marker = :cross,
#	linestyle = :solid,
	ylims = (0, 0.25),
	xlims = (0, 1.1),
	xticks = [],
	legend = :bottomleft,
	ylabel = L"\operatorname{max}\,\,\left|I_{\mathrm{dc}}^{(\mathrm{fit})}-I_{\mathrm{dc}}^{(\mathrm{exp})}\right|~/~I_{\mathrm{g}}",
	label = "Fit error",
	linewidth = 4,
	color = 3
)

scatter!(a2, hs, errs,
	 marker = :cross,
#	linestyle = :solid,
	ylims = (0, 0.25),
	xlims = (0, 1.1),
	xticks = [],
	label = "",
	linewidth = 4,
	color = 3
)

savefig("fit error.pdf")

scatter(errs, nVLOs,
	markersize = 3, 
	ylabel = L"V_{\mathrm{LO}}^{\mathrm{T}}~/~V_{\mathrm{g}}",
	xlabel = L"\operatorname{max}\,\,\left|I_{\mathrm{dc}}^{(\mathrm{fit})}-I_{\mathrm{dc}}^{(\mathrm{exp})}\right|~/~I_{\mathrm{g}}",
	label =  L"V_{\mathrm{LO}}^{\mathrm{T}}~/~V_{\mathrm{g}}",
	bottom_margin = 3Plots.mm,
	right_margin =10Plots.mm,
	ylims = (0, 0.5),
	xlims = (0, 0.2),
	legend = :bottomleft,
	markershape = :cross,
	markerstrokewidth = 5
	)

scatter!([100], [100],  
	label = L"\mathfrak{Re}\lbrace Z_{\mathrm{emb}}\rbrace ~/~R_{\mathrm{n}}",
	color  =2
)

scatter!([100], [100],   
 label = L"\mathfrak{Im}\lbrace Z_{\mathrm{emb}}\rbrace ~/~R_{\mathrm{n}}",
	color  =3
)

a2 = twinx()

scatter!(a2, errs, real.(nZLOs), markersize = 2,
 ylabel = L"Z_{\mathrm{emb}}~/~R_{\mathrm{n}}",
 ylims = (-0.6, 0.3),
 xticks = [],
 color = 2,
 xlims = (0, 0.2))

scatter!(a2, errs,xticks = [], imag.(nZLOs), markersize = 2, 
color = 3)


savefig("error vs VLO Zemb.pdf")

fitZR = (real.(nZLOs))[6:13]
fitZRe = (errs[6:13])

fitZI = imag.(nZLOs)
fitZIe = errs

fitV = nVLOs[3:7]
fitVe = errs[3:7]

@. model(t, p) = p[1] + p[2] * t^2 + p[3]*t^3 + p[4]*t+ p[5]*t^4
p0 = [0.3, 0.5, 0.2, 0.1, 0.3]

fit2 = curve_fit(model,fitZIe, fitZI, p0)
p2 = fit2.param

@. model2(t, p) = p[1] + p[2] * t

fit1 = curve_fit(model2,fitZRe, fitZR, p0)
p1 = fit1.param

fit3= curve_fit(model2,fitVe, fitV, p0)
p3 = fit3.param

plot!([0:0.01:1;], t -> model2(t, p3), color = 1, label = "", linewidth = 0.7)
plot!(a2, [0:0.01:1;], t -> model2(t, p1), color = 2, label = "", linewidth = 0.7)
plot!(a2, [0:0.01:1;], t -> model(t, p2), color = 3, label = "", linewidth = 0.7)

savefig("error vs VLO Zemb.pdf")

nZLO_R_opt = model2(0, p1)
nZLO_I_opt = model(0, p2)
nVLO_opt = model(0, p3)

Myi(nVₒ) = Ip(DCₒ1, DC1, nVₒ, 
	recover_nVω(DCₒ1, DC1, nVLO_opt, nZLO_R_opt + im * nZLO_I_opt, nVₒ));