# 1 minute apart, 44 hours in total
tdf = DataFrame(CSV.File("data/temperature.csv", delim = ",", header = true, types=Dict(1=>String, 2=>Float64, 3=>Float64, 4=>Float64)))

T5 = tdf[!, 2]; # 77 K radiation shield
T6 = tdf[!, 3]; # mixer block bracket
T7 = tdf[!, 4]; # LNA bracket
T8 = tdf[!, 5]; # 4 K plate

plot(T5, label = "77 K Radiation Shield", legend = :topleft)
plot!(T6, label = "Mixer Block Bracket")
plot!(T7, label = "LNA Bracket")
plot!(T8, label = "4 K Plate")
ylabel!("Temperature [K]")
xlabel!("Cooldown time [h]")
xticks!([1:(60 * 5):length(T8);], string.([0:8;] .* 5))
xlims!(0, 60 * 40)
ylims!(0, 300)

rectangle(w, h, x, y) = Shape(x .+ [0,w,w,0], y .+ [0,0,h,h])

plot!(rectangle(6*60, 100 , 60 * 17, 0), opacity=.3, color = :pink, label = "Helium cooldown")

savefig("13 Temperature log.pdf")