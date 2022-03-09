function IIdeal(nVₒ)

    if (nVₒ >= 0)

        if (nVₒ >= 1)
            return nVₒ
        end

        return 0;
    elseif (nVₒ < 0) 
        if (nVₒ < -1)
            return nVₒ
        end

        return 0
    end

end

Vsk = [-100:0.005:100;]
f(nVₒ) = IIdeal(nVₒ) - (nVₒ > 0 ? nVₒ : nVₒ)

Fourier = fft(f.(Vsk))

@. Fourier *= (-im * sign(Vsk))

Ikks = real(ifft(Fourier));

p = plot([0:0.01:2;],  V -> Idc(DCₒ1, V), xlims = (0, 2), ylims = (-3, 3), label = L"$I_{\mathrm{dc}}^0$",xlabel = L"$V_o~/~V_{\mathrm{g}}$",ylabel = L"$I~/~I_{\mathrm{g}}$", legend = :bottomright)
plot!([0:0.01:2;],  V -> Ikk(DCₒ1, V), label = L"$I_{\mathrm{kk}}$ (experimental)")
plot!(Vsk, Ikks, label = L"$I_{\mathrm{kk}}$ (ideal)", line = :dash, color = :gray)

savefig("06 Idc Ikk.pdf")


