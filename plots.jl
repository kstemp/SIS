using Plots, LaTeXStrings

plot_font = "Computer Modern"

fsize =  7

default(
  fontfamily=plot_font,
  linewidth=1, 
  framestyle=:box, 
  label=nothing, 
  grid=false,
  xtickfontsize = fsize,
  ytickfontsize = fsize,
  xguidefontsize = fsize,
  yguidefontsize = fsize,
  legendfontsize = fsize,
  titlefontsize = fsize,
  size = (230.449, 153.63),
  xminorticks=5,
  yminorticks=5,
  legend = :topleft,
  fg_legend = :transparent,
  bg_legend = :transparent,
  right_margin = 0Plots.mm, 
  left_margin = 0Plots.mm, 
  bottom_margin = 0Plots.mm,
   top_margin =0Plots.mm
)

plotSizeSmall() = default(size = (230.449, 153.63))

plotSizeDefault() = default(size = (800, 600))

"""
"""
function zeroxticks(p)

  ticks = xticks(p);

  ticks[1][2][1] = "0"

  xticks!(ticks[1][1], ticks[1][2])

end

"""
TODO Remove
"""
function MyPlot(args...; kwargs...)

  p = plot(args...; kwargs...); 

  return p;

end

#myplot = plot(sort(rand(10)),sort(rand(10)),label="Legend", ylims = (0, 1), xlabel=L"\textrm{Standard text}(r) / \mathrm{cm^3}", ylabel="Same font as everything")

#annotate!(0.2,0.8,text("My note",plot_font, 20))

#savefig("./plot.pdf")


#= plot([0:0.01:2;], V -> I(V), xlims = (0, 2), ylims=(-0.03, 4), ylabel = L"I_{\textrm{dc}}^0 / I_{\textrm{g}}", xlabel = L"V_o / V_{\textrm{g}}" , right_margin = 0Plots.mm, left_margin = 0Plots.mm, bottom_margin = 0Plots.mm, top_margin = 0Plots.mm)
=#
#=

p = plot([0:0.01:1;], V -> I(V, 300)*1e4, ylabel = L"I_{\textrm{dc}}^0 / I_{\textrm{g}}\times 10^{-4}", xlabel = L"V_o / V_{\textrm{g}}" , right_margin = 0Plots.mm, left_margin = 0Plots.mm, bottom_margin = 0Plots.mm, top_margin = 0Plots.mm, label = "T = 300 K", legend = :right, xlims = (0, 1), ylims = (0, 6))

plot!([0:0.01:1;], V -> I(V, 275)*1e4, label = "T = 275 K")

plot!([0:0.01:1;], V -> I(V, 250)*1e4, label = "T = 250 K")

 savefig("01 DC unmpumped leakage.pdf")

=#


#=
p = plot([0:0.01:2;], V -> Ipa(V, nVₚₕ), xlims = (0, 2), ylims=(-0.03, 4), ylabel = L"I_{\textrm{dc}} / I_{\textrm{g}}", xlabel = L"V_o / V_{\textrm{g}}" , right_margin = 0Plots.mm, left_margin = 0Plots.mm, bottom_margin = 0Plots.mm, top_margin = 0Plots.mm, label = L"I_{\textrm{dc}}~\textrm{(driven)}")
zeroxticks(p)
plot!([0:0.01:2;], V -> I(V), label = L"I_{\textrm{dc}}^0", line = :dot)

plot!([1 - nVₚₕ, 1], [1, 1], arrow = :both, color = :black, linewidth = 0.5)

annotate!((1 - nVₚₕ +1 - 0.2)/ 2, 1.6, text(L"V_{\textrm{ph}} / V_{\textrm{g}}", :black, :top, 7))

plot!([1 + 0.02, 1 + nVₚₕ], [1, 1], arrow = :both, color = :black, linewidth = 0.5)
annotate!((1 + nVₚₕ +1 + 0.2)/ 2, 0.9, text(L"V_{\textrm{ph}} / V_{\textrm{g}}", :black, :top, 7))

=#