-- ==============================================

function generateFreqSweep(freqSweepStart,freqSweepStop,freqSweepStep)
	local freqSweep = {}
	local next = freqSweepStart
	local fIndex = 0
	
	while next <= freqSweepStop do
		freqSweep[fIndex] = next
		next = next+freqSweepStep
		fIndex = fIndex+1
	end
	return freqSweep
end



-- Generate sine wave
-- A is the amplitude of the sine wave.
-- b is the signal bias
-- po is the offset (phase shift) of the signal.
-- sampleTime: Specify the sample period in seconds 
-- reference: https://it.mathworks.com/help/simulink/slref/sinewavefunction.html

function generateSinusoidalSignal(sampleTime,signalFrequency,N,A,po,b)
	print(string.format("signal frequency %g",signalFrequency))
	local signalPeriod = 1/signalFrequency
	local p= math.floor(signalPeriod/sampleTime) -- p is the number of time samples per sine wave period
 
	local signal = {}    -- new array
	for k=0,N do 
		--k is a repeating integer value that ranges from 0 to p�1
		-- y=Asin(2pi(k+o)/p)+b
		signal[k]=A*math.sin(2*math.pi*k*sampleTime+po)+b
	end
	return signal
end

-- ======================================
--  GENERATE CURRENT SIGNAL ---
-- --------------------------------------

-- Frequency sweep configuration
--
local freqSweepStart = 0.1
local freqSweepStop = 0.2
local freqSweepStep = 0.1

-- Frequency sweep calculation
-- 
local stepN = math.floor((freqSweepStop - freqSweepStart)/freqSweepStep)
print("Frequency sweep. start: %g, stop: %g , step: %g",freqSweepStart,freqSweepStop,freqSweepStep)
local sweep = generateFreqSweep(freqSweepStart,freqSweepStop,freqSweepStep)
for sweepIndex=0,stepN do print(sweep[sweepIndex]) end


--  sinusoidal waveform parameters
-- 
local sampleTime = 0.5 -- signal sampling period [s]
local A = 1e-3 -- current signal amplitude [A]
local po=0 -- phase offset
local b = 0 -- DC bias
local N = 1000 -- lunghezza del segnale (numero di campioni)


-- signal generation
--
local generatedSignal1 = generateSinusoidalSignal(sampleTime,0.1,N,A,po,b)
local generatedSignal2 = generateSinusoidalSignal(sampleTime,1,N,A,po,b)

print("fine")

