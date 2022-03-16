
function NEP(DCₒ::DCₒData, DC::DCData, nVₒ, nVLO, nZLO)

	R = responsivity(DCₒ, DC, nVₒ, nVLO, nZLO, true);

    return sqrt(Idc(DCₒ, nVₒ)) / R;

end


plot([0.0:0.01:2;], 
V -> responsivity(DCₒ1, DC1, V, nVLO, nZLO, true), 
label = L"R_{\mathrm{i}}", 
 xlabel = L"$V_o~/~V_{\mathrm{g}}$",
  right_margin = 8Plots.mm,
   ylims = (-3, 3), 
   ylabel = L"R_{\mathrm{i}}~\times~V_{\mathrm{g}}", 
   legend = :topright,
    xlims = (0, 2))

plot!([], [], color = 2, label = "|NEP|")

plot!(twinx(), [0.01:0.01:1.5;], 
V -> abs(NEP(DCₒ1, DC1, V, nVLO, nZLO)), 
legend = false,
 xticks = [],
  ylabel= "|NEP| [arbitrary units]", color = 2, xlims = (0, 2), ylims = (0, 3))

savefig("11 NEP.pdf")