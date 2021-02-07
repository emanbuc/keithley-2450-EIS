# discrete time sinusoidal signal generator

Lo strumento non prevede la geenrazione di form d'onda sinusoidali, ma permette di generare segnali in corrente e tensione passando una lista di set-point da programamre sulla sorgente di corrente/tensione.

```lua
smu.source.sweeplist("CurrentListSweep", 1,delay,repetition)
```

il parametro delay permette di impostare il ritardo tra i set point. Se la lista dei valori contiene i campioni di un segnale tempo discreto campionato a periodo Tc, impostando un delay pari a Tc dovrebbe essere possibile riprodurre il segnale originale.

Affinchè il segnale generato sia almeno approssimativamente sinusoidale devono essere vericate le seguenti condizioni:

- l'intervallo tra i campioni è molto minore dell'periodo del segnale sinusoidale
- la banda passante del generatore di corrente deve essere molto maggiore della frequenza del segnale sinusoidale

## Generazione del segnale a bordo dello strumento

La libreria delle funzoni matematiche dell'interprete del linguaggio di scriptting LUA include la funzione math.sin()

Per questo progetto sono stati sviluppate due diversi generatori di segnali sinusolidali:

-- Generate sine wave
-- A is the amplitude of the sine wave.
-- b is the signal bias
-- po is the offset (phase shift) of the signal.
-- sampleTime: Specify the sample period in seconds 
-- reference: https://it.mathworks.com/help/simulink/slref/sinewavefunction.html

```LUA
function generateSinusoidalSignal(sampleTime,signalFrequency,A,po,b)
	print(string.format("signal frequency %g",signalFrequency))
	local signalPeriod = 1/signalFrequency
	local p= math.floor(signalPeriod/sampleTime) -- p is the number of time samples per sine wave period
 
	local signal = {}    -- new array
	for k=0,p-1 do 
		--k is a repeating integer value that ranges from 0 to p-1
		-- y=Asin(2pi(k+o)/p)+b
		signal[k]=A*math.sin(2*math.pi*(k+po)/p)+b
	end
	return signal
end

function generateSinusoidalSignalSampleBased(sampleTime,signalFrequency,N,A,po,b)
	print(string.format("signal frequency %g",signalFrequency))
	local signal = {}    -- new array
	for k=0,N-1 do 
		signal[k]=A*math.sin(2*math.pi*k*sampleTime+po)+b
	end
	return signal
end
```

