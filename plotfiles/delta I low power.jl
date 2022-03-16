
upVs, upIs = loadFile(fileName("230", "0_00"));
DCₒ1 = parseDCₒData(upVs, upIs; cutoff = 1.6);



function doplot(d)

    upVs, upIs = loadFile(fileName("230", "0_00"));
    DCₒ1 = parseDCₒData(upVs, upIs; cutoff = 1.6);

    upVsp, upIsp =  loadFile(fileName("230", d[1]));
    DC1 = parseDCData(upVsp, upIsp, DCₒ1; ν = 230.0)

    fitVs, fitIs = File.filter(DC1.nVs, DC1.nIs, 2.1 / DCₒ1.Vg2, 2.54 / DCₒ1.Vg2);

    nZLO, nVLO = performRecovery(DCₒ1, DC1, fitVs, fitIs);

   p =plot!(DCₒ1.nVs, abs.(DC1.nIs .- DCₒ1.nIs), label = d[2])
   display(p)

end

default(size = (300.449, 153.63))

plot(
#legendtitle = L"V_{\mathrm{LO}}^{\mathrm{T}}~/~V_{\mathrm{g}}", 
#legendtitlefontsize = 8,
xlabel = L"$V_o~/~V_{\mathrm{g}}$",
ylabel = L"$\left|\Delta I_{\mathrm{dc}}\right|~/~I_{\mathrm{g}}$",
ylims = (-0.005, 0.21),
yticks = [0:0.05:0.2;],
xlims = (0,1.5),
legend = :outerright,
legendtitlefontsize = 8,
legendtitle = L"V_{\rm{LO}}^{\rm T}~/~V_{\mathrm{g}}"
)


doplot.([["0_30", "0.25"], ["0_20", "0.12"], ["0_10", "0.06"]])
plot!(DCₒ1.nVs, DCₒ1.nIs, label = "Leakage", line = :dash)


savefig("Delta Idc low driving.pdf")


#=
upVs, upIs = loadFile(fileName("230", "0_00"));
DCₒ11 = parseDCₒData(upVs, upIs; cutoff = 1.4);

upVsp, upIsp =  loadFile(fileName("230", "0_10"));
DC11 = parseDCData(upVsp, upIsp, DCₒ11; ν = 230.0)

upVsp, upIsp =  loadFile(fileName("230", "0_40"));
DC12 = parseDCData(upVsp, upIsp, DCₒ11; ν = 230.0)
plot(DCₒ11.nVs, DCₒ11.nIs, 
    label = "Leakage", 
    xlabel = L"$V_o~/~V_{\mathrm{g}}$",
    ylabel = L"$I~/~I_{\mathrm{g}}$",
    xlims = (0, 0.5),
    ylims = (-0.1, 0.1),
    legend = :bottomright
)

plot!(DCₒ11.nVs, (DC11.nIs .- DCₒ11.nIs),  
    label = L"\Delta I_{\mathrm{dc}}")

#plot!(DCₒ11.nVs, DCₒ11.nIs)
    
plot!(DCₒ11.nVs, (DC12.nIs .- DCₒ11.nIs),  
label = L"\Delta I_{\mathrm{dc}} 2")

