 plot(
    [0:0.01:4;], 
    Vₒ -> nVω(Vₒ) /real(Iω(DCₒ1, DC1,  Vₒ, nVω(Vₒ))),
    label = L"$|\mathfrak{Re}\lbrace \hat Z_{\mathrm{j}}\rbrace|$", legend = :topright, 
    xlims = (0, 2),
    ylims = (0, 6),
    ylabel =L"|\mathfrak{Re}\lbrace \hat Z \rbrace|",
    xlabel = L"V / V_{\mathrm{g}}"#,
    #right_margin=10Plots.mm
    )

 hline!(
     [real(nZLO)], 
    line = :dash, 
    label = L"$|\mathfrak{Re}\lbrace \hat Z_{\mathrm{emb}}\rbrace|$"
)

savefig("impedance mismatch real.pdf")

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

plot( [0:0.01:2;], 
    Vₒ -> -nVω(Vₒ)/imag(Iω(DCₒ1, DC1,  Vₒ, nVω(Vₒ))),
    label =L"$-|\mathfrak{Im}\lbrace \hat Z_{\mathrm{j}}\rbrace|$",
    color = 3,
    ylims = (-30, 30),
    xlims = (0,2),
    ylabel = "",
    legend = :bottomright
 )

hline!( [imag(nZLO)], 
    line = :dash, 
    label =  L"$|\mathfrak{Im}\lbrace \hat Z_{\mathrm{emb}}\rbrace|$",
   ylabel =L"|\mathfrak{Im}\lbrace \hat Z\rbrace|",
   xlabel = L"V / V_{\mathrm{g}}",
    color = 4,
)
savefig("impedance mismatch imag.pdf")