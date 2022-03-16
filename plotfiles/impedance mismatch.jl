default(size = (300.449, 153.63))

plot(
    [0:0.01:4;], 
    Vₒ -> real(nZLO) / (nVω(Vₒ) /real(Iω(DCₒ1, DC1,  Vₒ, nVω(Vₒ)))),
    ylabel = L"$\mathfrak{Re}\lbrace \hat Z_{\mathrm{emb}}\rbrace~/~\mathfrak{Re}\lbrace \hat Z_{\mathrm{j}}\rbrace$", 
    legend = :topleft, 
    xlims = (0, 2),
    ylims = (0, 0.2),
    label =L"\mathfrak{Re}",
    xlabel = L"V / V_{\mathrm{g}}",
 right_margin=12Plots.mm
    )

    plot(twinx(), [0:0.01:2;], 
    Vₒ -> imag(nZLO) / (-nVω(Vₒ)/imag(Iω(DCₒ1, DC1,  Vₒ, nVω(Vₒ)))),
   ylabel =L"$-\mathfrak{Re}\lbrace \hat Z_{\mathrm{emb}}\rbrace~/~\mathfrak{Im}\lbrace \hat Z_{\mathrm{j}}\rbrace$",
    color = 3,
    ylims = (-0.5, 0.5),
    xlims = (0,2),
    xticks = [],
    label = L"\mathfrak{Im}",
    legend = :topright
 )

 savefig("impedance mismatch.pdf")

 hline!(
     [real(nZLO)], 
    line = :dash, 
    label = L"$\mathfrak{Re}\lbrace \hat Z_{\mathrm{emb}}\rbrace$"
)

#=
 plot!(
     [], [], 
    color = 3, 
  label = L"$-|\mathfrak{Im}\lbrace \hat Z_{\mathrm{j}}\rbrace|$"
 )

 plot!([],
    [],
   color = 4, 
 label =  L"$|\mathfrak{Im}\lbrace \hat Z_{\mathrm{LO}}\rbrace|$",
 line = :dash
)

axis2 = twinx();=#



hline!( [imag(nZLO)], 
    line = :dash, 
    label =  L"$\mathfrak{Im}\lbrace \hat Z_{\mathrm{emb}}\rbrace$",
   ylabel =L"\mathfrak{Im}\lbrace \hat Z\rbrace",
   xlabel = L"V / V_{\mathrm{g}}",
    color = 4,
)
savefig("impedance mismatch imag.pdf")