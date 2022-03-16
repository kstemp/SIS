MyI(V) -> V;

dos(E) = abs(E) <= 1 ? 0 : abs(E) / sqrt(E^2 - 1);

fermi(E, p) = 1 / (exp(E * p) + 1)

Integrand(E, V, p) = dos(E - 2V) * dos(E) * (fermi(E - 2V, p) - fermi(E, p))

MyI(V, p) = quadgk(E -> Integrand(E, V, p), -Inf, -1, 0, 1, Inf, rtol = 1e-4)[1]

plot([0:0.01:1.5;], V -> MyI(V, 10),
ylims = (-0.03, 4),
xlims = (0, 2),
xlabel  = L"$V_o~/~V_{\mathrm{g}}$",
ylabel = L"$I_{\mathrm{dc}}^0\left(V_o\right)~/~I_{\mathrm{g}}$",
label = L"I_{\mathrm{dc}}^0"
)
plot!([0:1], V -> 2.2 * (V - 1) + 1.59, line = :dash, linewidth = 0.7, label = L"R_{\mathrm{n}}")

plot!([1.5:0.1:2;], V -> MyI(V, 10), color = 1)


annotate!(1.7, 1.6,text(L"$V_{\mathrm{g}}=\frac{2\Delta}{e}$", plot_font, 7))
annotate!(1.7,0.7, text(L"$I_{\mathrm{g}}=\frac{V_{\mathrm{g}}}{R_{\mathrm{n}}}$", plot_font, 7))

savefig("02 DC unmpuped_analytic_largebias.pdf")



plot([0:0.01:0.2;], V -> MyI(V, 9) * 1e4,
ylims = (0, 6),
xlims = (0, 1),
xlabel  = L"$V_o~/~V_{\mathrm{g}}$",
ylabel = L"$I_{\mathrm{dc}}^0\left(V_o\right)~/~I_{\mathrm{g}}~\times~10^{-4}$",
label = L"\Delta/k_{\mathrm{B}}T = 9",
legend = :topright
)

plot!([0:0.01:0.2;], V -> MyI(V, 8.5) * 1e4, label = L"\Delta/k_{\mathrm{B}}T = 8.5")

plot!([0:0.01:0.2;], V -> MyI(V, 8) * 1e4, label = L"\Delta/k_{\mathrm{B}}T = 8")

plot!([0.2:0.015:2;], V -> MyI(V, 9) * 1e4, color = 1)
plot!([0.2:0.015:2;], V -> MyI(V, 8.5) * 1e4, color = 2)
plot!([0.2:0.015:2;], V -> MyI(V, 8) * 1e4, color = 3)

savefig("01 DC unmpumped leakage.pdf")