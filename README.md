# SIS detector tools

This is a "software package" for analysis experimental I-V characteristics of a Superconductor-Insulator-Superconductor (SIS) tunnel junction operating in a direct detector setup. The code was created as a part of my MPhys project at the Superconducting Detectors Group at University of Oxford. 

## Features

* TODO

## Example usage - performing impedance recovery

```
using Data, Currents, Recovery, File, Plots

# load un-pumped and pumped I-V curves
DCₒ = loadDCₒData("dciv.csv"; Vcol = 1, Icol = 2);

DC = loadDCData("f230.csv", DCₒ; ν = 230.0, Vcol = 1, Icol = 2)

fitVs, fitIs = File.filter(DC.nVs, DC.nIs, 0.75, 0.97);

nZLO, nVLO = performRecovery(DCₒ, DC, fitVs, fitIs);

plot(DC.nVs, DC.nIs, xlims = (0, 2), ylims=(0, 2))
plot!([0:0.01:2;], Vₒ -> Ip(DCₒ, DC, Vₒ, recover_nVω(DCₒ, DC, nVLO, nZLO, Vₒ)), label = "Recovered I-V")
```

## License
[MIT](https://choosealicense.com/licenses/mit/)