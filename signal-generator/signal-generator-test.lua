
local signalGenerator = require "signalGenerator"
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
local sweep = signalGenerator.generateFreqSweep(freqSweepStart,freqSweepStop,freqSweepStep)
for sweepIndex=0,stepN do print(sweep[sweepIndex]) end


--  sinusoidal waveform parameters
-- 
local sampleTime = 0.01 -- signal sampling period [s]
local A = 1e-3 -- current signal amplitude [A]
local po=0 -- phase offset
local b = 0 -- DC bias
local N = 1000 -- lunghezza del segnale (numero di campioni)


-- signal generation
--
local generatedSignal1 = signalGenerator.generateSinusoidalSignal(sampleTime,0.1,A,po,b)
local generatedSignal2 = signalGenerator.generateSinusoidalSignal(sampleTime,1,A,po,b)
local generateSignal3= signalGenerator.generateSinusoidalSignalSampleBased(sampleTime,1,N,A,po,b)

print("fine")

