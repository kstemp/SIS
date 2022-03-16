
rectangle(w, h, x, y) = Shape(x .+ [0,w,w,0], y .+ [0,0,h,h])

width = (2.54-2.1) / DCₒ1.Vg2;
height = 0.3;

plot!(rectangle(width, height ,2.1 / DCₒ1.Vg2, 0.25), opacity=.4, color = :pink, label = "Fit interval")


upVs, upIs = loadFile(fileName("230", "0_00"), smooth = false);


upVsp, upIsp =  loadFile(fileName("230", "0_50"), smooth = false);

plot(upVs, upIs, xlims = (0, 5), ylims = (0, 0.4), 
xlabel = L"$V_o$ [mV]",
ylabel = L"$I_{\rm{dc}}^0(V_o)$ [mA]")

plot!(rectangle(5 - 2.71, 0.4 , 2.71, 0), opacity=.3, color = :lightgreen, label = "")

savefig("01. unmpumped exp.pdf")


plot(upVs, upIs, xlims = (0, 5), ylims = (0, 0.4), 
xlabel = L"$V_o$ [mV]",
ylabel = L"$I_{\rm{dc}}^0(V_o)$ [mA]")

plot!(rectangle(2.71, 0.4 , 0, 0), opacity=.3, color = :pink, label = "")

savefig("02. leakage.pdf")


plot(upVsp, upIsp, xlims = (0, 5), ylims = (0, 0.4), 
xlabel = L"$V_o$ [mV]",
ylabel = L"$I_{\rm{dc}}(V_o)$ [mA]")

savefig("03. pumped exp.pdf")

plot(upVs, upIs .* 1000, xlims = (0, 2), ylims = (0, 10),
xlabel = L"$V_o$ [mV]",
ylabel = L"$I_{\rm{dc}}^0(V_o)$ [μA]")

