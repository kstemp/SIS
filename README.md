# SIS detector tools

This is a "software package" for analysis experimental I-V characteristics of a Superconductor-Insulator-Superconductor (SIS) tunnel junction operating in a direct detector setup. The code was created as a part of my MPhys project at the Superconducting Detectors Group at University of Oxford. 

## Features

* parsing experimental "un-pumped" I-V characteristics of a junction: correcting for current and voltage offsets, finding gap voltage and normal resistance, normalising the data
* parsing experimental "pumped" I-V characteristics of a junction
* recovering impedance and Thevening voltage of the embedding circuit
* computing the junction responsivity, both assuming all available power is transferred to the junction as well as taking into account the embedding circuit

## Example usage - performing impedance recovery

Vs (Vsp) and Is (Vsp) are vectors containing un-pumped (pumped) voltage and current experimental data, respectively.
```
using Data, Currents, Recovery, File, Plots

DCₒ = parseDCₒData(Vs, Is);

DC = parseDCData(Vsp, Isp, DCₒ; ν = 230)

fitVs, fitIs = File.filter(DC.nVs, DC.nIs, 0.75, 0.97);

nZLO, nVLO = performRecovery(DCₒ, DC, fitVs, fitIs);

plot(DC.nVs, DC.nIs, xlims = (0, 2), ylims=(0, 2), label = "Experimental data")
plot!([0:0.01:2;], Vₒ -> Ip(DCₒ, DC, Vₒ, recover_nVω(DCₒ, DC, nVLO, nZLO, Vₒ)), label = "Recovered I-V")
```

## License
[MIT](https://choosealicense.com/licenses/mit/)