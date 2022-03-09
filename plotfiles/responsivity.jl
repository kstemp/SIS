using Responsivity

default(size = (300.449, 153.63))

plot([0:0.01:3], V -> responsivity(DCₒ1, DC1, V, nVLO, nZLO, true),
    xlims = (0, 2), 
    ylims = (-2, 3), 
    label = L"P = \frac{1}{2}V_{\omega}\mathfrak{Re}\lbrace \tilde I_{\omega}\rbrace",
    xlabel = L"$V_o~/~V_{\mathrm{g}}$",
    ylabel = L"$R_{\mathrm{i}}~\times~V_{\mathrm{g}}$",
    legend = :outerright
)

plot!([0:0.01:3], V -> responsivity(DCₒ1, DC1, V, nVLO, nZLO, false),
    label =  L"P =\frac{\left|V_{\mathrm{LO}}^{\mathrm{T}}\right|^2}{8\,\mathfrak{Re}\lbrace \tilde Z_{\mathrm{emb}}\rbrace}"
)

hline!([1 / DC1.nVₚₕ], label = "Quantum limit", line = :dash)

savefig("responsivity.pdf")