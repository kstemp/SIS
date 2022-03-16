

fitVs, fitIs = File.filter(DC1.nVs, DC1.nIs, 2.1 / DCₒ1.Vg2, 2.54 / DCₒ1.Vg2);

nZLO, nVLO = performRecovery(DCₒ1, DC1, fitVs, fitIs);

@show nZLO, nVLO

nVω(nVₒ) = recover_nVω(DCₒ1, DC1, nVLO, nZLO, nVₒ)

Myi(nVₒ, nZLO, nVLO) = Ip(DCₒ1, DC1, nVₒ, recover_nVω(DCₒ1, DC1, nVLO, nZLO, nVₒ));
plot(DC1.nVs, DC1.nIs, xlims = (0, 2), ylims = (0, 3), label = "Experimental")

plot!([0:0.001:2;], Vₒ -> Myi(Vₒ, nZLO, nVLO), label = "Simulated (narrow interval)", color = 2)

fitVs, fitIs = File.filter(DC1.nVs, DC1.nIs, 2.1 / DCₒ1.Vg2, 1);
nZLO, nVLO = performRecovery(DCₒ1, DC1, fitVs, fitIs);

@show nZLO, nVLO

plot!([0:0.001:2;], Vₒ -> Myi(Vₒ, nZLO, nVLO), label = "Simulated (wider interval)", color = 3)

xlabel!(L"V_o~/V_{\mathrm{g}}")
ylabel!(L"I_{\mathrm{dc}}~/I_{\mathrm{g}}")


rectangle(w, h, x, y) = Shape(x .+ [0,w,w,0], y .+ [0,0,h,h])

width = (2.54-2.1) / DCₒ1.Vg2;
height = 0.3;

plot!(rectangle(1 - 2.1 / DCₒ1.Vg2, 0.3, 2.1 / DCₒ1.Vg2, 0.25), opacity=.15, color = 3)

plot!(rectangle(2.54 / DCₒ1.Vg2 -2.1 / DCₒ1.Vg2, 0.5, 2.1 / DCₒ1.Vg2, 0.15), opacity=.15, color = 2)

xlims!(0.6, 1.05)
ylims!(0.1, 1.0)

savefig("fit interval compare.pdf")