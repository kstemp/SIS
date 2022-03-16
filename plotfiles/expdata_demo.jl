
push!(LOAD_PATH, "C:/Users/Chris/Projects/SIS/sis")
include("loadfile.jl")
using Data, Currents, Recovery, File, Plots, Responsivity

fileName(ω, mm) = string("data/IV_", ω, "GHz_-30mA_", mm, "um.csv")

upVs, upIs = loadFile(fileName("230", "0_00"));
DCₒ1 = parseDCₒData(upVs, upIs; cutoff = 1.4);

upVsp, upIsp =  loadFile(fileName("230", "0_40"));
DC1 = parseDCData(upVsp, upIsp, DCₒ1; ν = 230.0)

p = plot(upVs, upIs, xlims = (0, 5), ylims = (0, 0.4),  xlabel = L"$V_o$ [mV]", label = L"$I_{\mathrm{dc}}^0$", legend = :topleft);

plot!(upVsp, upIsp, label = L"$I_{\mathrm{dc}}$")

plot!(upVs, V -> V / DCₒ1.Rn2 + DCₒ1.shift2, label = L"$R_{\mathrm{n}} = 23.77~\mathrm{\Omega}$", line = :dash, color = :gray, linewidth = 0.8)

scatter!([DCₒ1.Vg2], [Idc(DCₒ1, 1) * DCₒ1.Ig2], label = L"$V_{\mathrm{g}}=2.68$ mV")

zeroxticks(p)

savefig("05 expdata_demo.pdf")

p = plot([0:0.01:2;],  V -> Idc(DCₒ1, V), xlims = (0, 2), ylims = (-3, 3), label = L"$I_{\mathrm{dc}}^0$", xlabel = L"$V_o~/~V_{\mathrm{g}}$", legend = :topleft)
plot!([0:0.01:2;],  V -> Ikk(DCₒ1, V), label = L"$I_{\mathrm{kk}}$")

zeroxticks(p)

savefig("06 Idc Ikk.pdf")

p = plot([0:0.01:2;],  V -> abs(Id(DCₒ1, DC1, V, DC1.nVₚₕ)), xlims = (0, 2), ylims = (0, 2), label = L"$|\mathfrak{Re}\lbrace \tilde I_{\omega}\rbrace|$", xlabel = L"$V_o~/~V_{\mathrm{g}}$", ylabel= L"$I~/~I_{\mathrm{g}}$", legend = :topleft)
plot!([0:0.01:2;],  V -> abs(Ir(DCₒ1, DC1, V, DC1.nVₚₕ)), label = L"$|\mathfrak{Im}\lbrace \tilde I_{\omega}\rbrace|$")

savefig("07 Ir Id.pdf")

fitVs, fitIs = File.filter(DC1.nVs, DC1.nIs, 2.1 / DCₒ1.Vg2, 1);

nZLO, nVLO = performRecovery(DCₒ1, DC1, fitVs, fitIs);

nVω(nVₒ) = recover_nVω(DCₒ1, DC1, nVLO, nZLO, nVₒ)

Myi(nVₒ, nZLO, nVLO) = Ip(DCₒ1, DC1, nVₒ, recover_nVω(DCₒ1, DC1, nVLO, nZLO, nVₒ));
plot(DC1.nVs, DC1.nIs, xlims = (0, 2), ylims = (0, 3),  label = "Experimental", legend = :topleft, xlabel = L"$V_o~/~V_{\mathrm{g}}$", ylabel= L"$I_{\mathrm{dc}}~/~I_{\mathrm{g}}$")
plot!([0:0.01:2;], Vₒ -> Myi(Vₒ, nZLO, nVLO), label = "Simulated" )

rectangle(w, h, x, y) = Shape(x .+ [0,w,w,0], y .+ [0,0,h,h])

width = (DCₒ1.Vg2-2.1) / DCₒ1.Vg2;
height = 0.4;

plot!(rectangle(width, height ,2.1 / DCₒ1.Vg2, 0.25), opacity=.4, color = :pink, label = "Fit interval")

annotate!(1.4,1.4,text(L"$\nu=230$ GHz", plot_font, 7))
annotate!(1.35,0.9,text(L"$\hat V_{\mathrm{LO}}^{\mathrm{T}}=0.31$", plot_font, 7))
annotate!(1.5,0.4,text(L"$\hat Z_{\mathrm{emb}}=0.05-0.06i$", 7))

savefig("08 fit.pdf")

#=
p1=plot([0.0:0.01:2.6;], 
nVₒ -> recover_nVω(DCₒ1, DC1, nVLO2, nZLO2, nVₒ)/Ir(DCₒ1, DC1, nVₒ, recover_nVω(DCₒ1, DC1, nVLO2, nZLO2, nVₒ)) ,
label = "Reactive (Brute-force)" , right_margin = 10Plots.mm);

plot!([0.0:0.01:2.6;], 
nVₒ -> recover_nVω(DCₒ1, DC1, nVLO, nZLO, nVₒ)/Ir(DCₒ1, DC1, nVₒ, recover_nVω(DCₒ1, DC1, nVLO, nZLO, nVₒ)) ,
label = "Reactive (Withington)" , color = 2, ylims = (-100, 100), legend = :bottomright);

p2 = plot([0.0:0.01:2.6;], 
nVₒ -> recover_nVω(DCₒ1, DC1, nVLO2, nZLO2, nVₒ)/Id(DCₒ1, DC1, nVₒ, recover_nVω(DCₒ1, DC1, nVLO2, nZLO2, nVₒ)) ,
label = "Dissipative(Brute-force)" , ylims = (0, 7), color = 1);

plot!([0.0:0.01:2.6;], 
nVₒ -> recover_nVω(DCₒ1, DC1, nVLO, nZLO, nVₒ)/Id(DCₒ1, DC1, nVₒ, recover_nVω(DCₒ1, DC1, nVLO, nZLO, nVₒ)) ,
label = "Dissipative (Withington)" , color = 2);

plot(p1, p2, layout = (2,1))

xlims!(0, 1.5)
ylims!(-100, 100)


Myi(nVₒ) = Ip(DCₒ1, DC1, nVₒ, recover_nVω(DCₒ1, DC1, nVLO, nZLO, nVₒ));
Myi2(nVₒ) = Ip(DCₒ1, DC1, nVₒ, recover_nVω(DCₒ1, DC1, nVLO2, nZLO2, nVₒ));

plot(DC1.nVs, DC1.nIs, xlims = (0, 2), ylims = (0, 3))#,  label = "Experimental", legend = :topleft, xlabel = L"$V_o~/~V_{\mathrm{g}}$", ylabel= L"$I_{\mathrm{dc}}~/~I_{\mathrm{g}}$")

plot!([0.5:0.01:2;], Vₒ -> Myi2(Vₒ), label = "Recovered (Brute-force)" )

plot!([0.5:0.01:2;], Vₒ -> Myi(Vₒ), label = "Recoverd (Withington)" )
=#