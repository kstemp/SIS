using Printf, LaTeXStrings, Responsivity, LsqFit

fileName(ω, mm) = string("data/IV_", ω, "GHz_-30mA_", mm, "um.csv")

include("plotfiles/files.jl")
#default(size = (330.449, 153.63))

function get_responsivities(files)

    Rs = []
    Rs_80 = []
    Rs_90 = []
    nVLOs = []
    nVₚₕ = -2;    

    for f in files
        ν = f[1]
        d = f[2]

        upVs, upIs = loadFile(fileName(ν, "0_00"));
        DCₒ1 = parseDCₒData(upVs, upIs; cutoff = 1.4);
    
        upVsp, upIsp =  loadFile(fileName(ν, d));
        DC1 = parseDCData(upVsp, upIsp, DCₒ1; ν = parse(Float64, ν)) 

        if (nVₚₕ < 0 )
            nVₚₕ = DC1.nVₚₕ
        end
    
        fitVs, fitIs = File.filter(DC1.nVs, DC1.nIs, 2.1 / DCₒ1.Vg2, 2.54 / DCₒ1.Vg2);
    
        nZLO, nVLO = performRecovery(DCₒ1, DC1, fitVs, fitIs);

        push!(nVLOs, nVLO)
        push!(Rs_80, responsivity(DCₒ1, DC1, 0.80, nVLO, nZLO))
        push!(Rs, responsivity(DCₒ1, DC1, 0.85, nVLO, nZLO))
        push!(Rs_90, responsivity(DCₒ1, DC1, 0.90, nVLO, nZLO))

       # p = plot!([0:0.01:2;], V -> responsivity(DCₒ1, DC1, V, nVLO, nZLO), label = @sprintf("%.2f", nVLO))
       # display(p)
    end

    errs = abs.(Rs_80 .- Rs_90)

    return [nVLOs, Rs, errs, nVₚₕ]

end


function plotFit(myp, color)

    @. model(t, p) = p[1] + p[2] * (t)^2 

    p0 = [0.3, 0.5]
    
    fit = curve_fit(model, myp[1], myp[2], p0)
    
    p = fit.param
    
    display(plot!([0:0.01:1;], t -> model(t, p), color = color, label = "", linewidth = 0.7))

    err = standard_errors(fit)

    return p[1], err[1]

end

p210 = get_responsivities(files_210)
p220 = get_responsivities(files_220)
p230 = get_responsivities(files_230)
p240 = get_responsivities(files_240)
p250 = get_responsivities(files_250)
p260 = get_responsivities(files_260)
p270 = get_responsivities(files_270)

default(size = (360.449, 210.63), grid = false)

p1 = scatter(p210[1], p210[2], yerr = p210[3], 
    label = "210", 
    xlims = (0, 0.8),
    ylims = (1.9, 3.2),
    legendtitle = "Frequency [GHz]",
    legendtitlefontsize = 8,
    legend = :outerright,
    xlabel = L"V_{\mathrm{LO}}^{\mathrm{T}}~/~V_{\mathrm{g}}",
    ylabel = L"R_{\mathrm{i}}(V_o)~\times~V_{\mathrm{g}}",
    color = 1,
    markersize = 2,
    bottom_margin = 2Plots.mm
    ) 

scatter!(p230[1], p230[2], yerr = p230[3], label = "230",color = 2, markersize = 2) 
scatter!(p250[1], p250[2], yerr = p250[3], label = "250",color = 3,  markersize = 2)
scatter!(p270[1], p270[2], yerr = p270[3], label = "270",color = 4,  markersize = 2) 

#annotate!(0.2,2.05,text(L"$V_o=0.8\,V_{\mathrm{g}}$", plot_font, 7))

plotFit(p210, 1)
plotFit(p230, 2)
plotFit(p250, 3)
plotFit(p270, 4)

hline!([1 / p210[4]], color = 1, line = :dash, label = "Quantum limit", linewidth = 0.7)
hline!([1 / p230[4]], color = 2, line = :dash, label = "", linewidth = 0.7)
hline!([1 / p250[4]], color = 3, line = :dash, label = "", linewidth = 0.7)
hline!([1 / p270[4]], color = 4, line = :dash, label = "", linewidth = 0.7)

savefig("responsivities fit.pdf")

is = plotFit.([p210, p220, p230, p240, p250, p260, p270], 1)

Rs = [x[1] for x in is]
ers = [x[2] for x in is]

lims = 1 ./ [p210[4], p220[4], p230[4], p240[4], p250[4], p260[4], p270[4]]


default(size = (280.449, 203.63))
default(grid = true)
scatter([210:10:270;], Rs, 
label = L"$R_{\mathrm{i}}\left(V_{\mathrm{LO}}^{\mathrm{T}}\rightarrow 0\right)$", 
markersize = 2.2,
legend = :bottomleft,
xlabel = L"Frequency $\nu$ [GHz]",
ylabel = L"R_{\mathrm{i}}~\times~V_{\mathrm{g}}",
xlims = (205, 275),
ylims = (2.25, 3.2),
yerr = mers
)


scatter!([210:10:270;], lims, 
label = "Quantum limit", markersize = 2
)


@. model(t, p) = p[2] / (t) + p[1] + p[3] / t^2 
fit = curve_fit(model, [210:10:270;], Rs, [0.3, 0.5, 0.1])
p1 = fit.param

plot!([200:10:280;], t -> model(t, p1), color = 1, linewidth = 0.7)

@. model2(t, p) = p[1] / t
fit1 = curve_fit(model2, [210:10:270;], lims, [0.3])

p2 = fit1.param

plot!([200:10:280;], t -> model2(t, p2), color = 2, linewidth = 0.9, line = :dash, label = "")

savefig("responsivity at zero vs frequency.pdf")


plot!(twinx(), [200:10:280;], t-> abs(model2(t, p1) - model(t, p)), xlims = (205, 275))

