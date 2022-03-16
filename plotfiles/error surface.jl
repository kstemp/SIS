using ColorSchemes

default(size = (240.449, 153.63))

nVωs = recover_nVωs(DCₒ1, DC1, fitVs, fitIs);

heatmap([0:0.01:1;], [-1:.01:1;], (x, y) -> log10(Recovery.error(DCₒ1, DC1, x + im * y, fitVs, nVωs)), 
    color = cgrad(:deep, rev=true),
    xlims = (0, 1),
    ylims = (-1, 1),
    xlabel = L"$\mathfrak{Re}\lbrace Z_{\mathrm{emb}}\rbrace ~/~R_{\mathrm{n}}$",
    ylabel = L"$\mathfrak{Im}\lbrace Z_{\mathrm{emb}}\rbrace ~/~R_{\mathrm{n}}$",
    colorbar_title = " \n\nlog10(ε)",
    colorbar_titlefontsize = 8,
    colorbar_titlefont = "Computer Modern",
 right_margin =6Plots.mm
)

scatter!([real(nZLO)], [imag(nZLO)], label = L"\hat Z_{\mathrm{emb}} = 0.05-0.06i", bg_legend = :white, fg_legend = :black, legend = :topright, markersize = 2.5, color = 2)

scatter!([real(nZLO)], [imag(nZLO)], label = "", markersize = 4, marker = :xcross, color = 2)

savefig("error surface.pdf")