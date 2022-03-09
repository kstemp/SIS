push!(LOAD_PATH, "C:/Users/Chris/Projects/SIS/sis")
include("loadfile.jl")
using Data, Currents, Recovery, File, Plots, Responsivity

upVs, upIs = loadFile("data/power/IV_230GHz_-30mA_Unpumped_both_Amp_BPF_PM.csv");

upVs27, upIs27 = loadFile("data/power/IV_230GHz_-30mA_s0_27um_both_Amp_BPF_PM.csv"; smooth = false);
upVs50, upIs50 = loadFile("data/power/IV_230GHz_-30mA_s0_50um_both_Amp_BPF_PM.csv"; smooth = false);
upVs70, upIs70 = loadFile("data/power/IV_230GHz_-30mA_s0_70um_both_Amp_BPF_PM.csv"; smooth = false);
upVs90, upIs90 = loadFile("data/power/IV_230GHz_-30mA_s0_90um_both_Amp_BPF_PM.csv"; smooth = false);

p = plot(upVs, upIs, xlims = (0, 5), ylims = (0, 0.4), xlabel = L"$V_o$ [mV]", ylabel = L"$I_{\mathrm{dc}}^o(V_o)$ [mA]", label = "-17.5 dBm (unpumped)")
plot!(upVs27, upIs27, label = "-17.4")
plot!(upVs50, upIs50, label = "-16.4")
plot!(upVs70, upIs70, label = "-16.2")
plot!(upVs90, upIs90, label = "-16.4")