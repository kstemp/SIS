
df = DataFrame(CSV.File("data/power.csv", delim = ",", header = true, types=Dict(1=>Float64, 2=>Float64, 3=>Float64, 4=>Float64)))

at = df[!, 1];
freq = df[!, 2];
T = df[!, 3];
P = df[!, 4];

Power(freq, T) = DataFrames.filter(r -> (r[3] == T && abs(r[2] - freq) < 3), df)

function mys(freq, T) 
	p = scatter!(Power(freq, T)[!, 1] / minimum(Power(freq, T)[!, 1]), Power(freq, T)[!, 4], label = string(freq, " GHz"), markersize = 2)
	plot!(Power(freq, T)[!, 1] / minimum(Power(freq, T)[!, 1]), Power(freq, T)[!, 4])
	display(p)
end

scatter([], [], xlabel = "Normalised attenuator reading", ylabel = "Power [dBm]", legend = :outerright)
mys.([215:10:265;], 300.0)
annotate!(5.05,-17.65,text("T = 300 K", plot_font, 7))

savefig("300 K.pdf")

scatter([], [], xlabel = "Normalised attenuator reading", ylabel = "Power [dBm]", legend = :outerright)
mys.([215:10:265;], 77.0)
annotate!(6.1,-17.6,text("T = 77 K", plot_font, 7))

savefig("77 K.pdf")