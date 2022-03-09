using Printf 
plot(legend = :outerright,
 legendtitle = L"V_{\mathrm{LO}}^{\mathrm{T}}~/~V_{\mathrm{g}}", 
 legendtitlefontsize = 8,
 xlabel = L"$V_o~/~V_{\mathrm{g}}$",
 ylabel = L"$R_{\mathrm{i}}~\times~V_{\mathrm{g}}$",
 ylims = (-2, 3),
 xlims = (0,2),
 legendtitleposition = :right
 )

default(size = (300.449, 153.63))

for d in ["0_20", "0_60", "0_70", "0_80", "0_90", "1_00"]

    upVs, upIs = loadFile(fileName("240", "0_00"));
    DCₒ1 = parseDCₒData(upVs, upIs; cutoff = 1.4);

    upVsp, upIsp =  loadFile(fileName("240", d));
    DC1 = parseDCData(upVsp, upIsp, DCₒ1; ν = 230.) 

    fitVs, fitIs = File.filter(DC1.nVs, DC1.nIs, 2.1 / DCₒ1.Vg2, 2.54 / DCₒ1.Vg2);

    nZLO, nVLO = performRecovery(DCₒ1, DC1, fitVs, fitIs);

    p = plot!([0:0.01:2;], V -> responsivity(DCₒ1, DC1, V, nVLO, nZLO), label = @sprintf("%.2f", nVLO))
    display(p)

end

savefig("responsivities different driving levels.pdf")