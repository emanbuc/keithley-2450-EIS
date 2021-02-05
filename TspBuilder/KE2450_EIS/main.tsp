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


-- generate signal
-- local N = 10 -- # numero campioni per periodo da generare
-- local samplingFreq = 100 [Hz]
-- local signalFrequency = 2
-- local amplitude = 1e-3 [A]
function generateSinusoidalSignal(samplingFreq,N,signalFrequency,amplitude)
	print(string.format("signal frequency %g",signalFrequency))
	local samplingPeriod = 1/samplingFreq
	local signal = {}    -- new array
	for i=0,N do 
		signal[i]=math.sin(2*math.pi*signalFrequency*i*samplingPeriod)* amplitude
	end
	return signal
end
-- ======================================

-- generate sinusoidal waveform signal samples

local N = 1000 --1000 -- # numero  da generare per ogni step dello sweep
local samplingFreq = 1000 --[Hz]
--local signalFrequency = 2
local amplitude = 1e-3 --[A]

--
-- Frequency sweep
--

local freqSweepStart = 0.1
local freqSweepStop = 0.2
local freqSweepStep = 0.1
local stepN = math.floor((freqSweepStop - freqSweepStart)/freqSweepStep)
print("Frequency sweep. start: %s, stop: %s , step: %s",freqSweepStart,freqSweepStop,freqSweepStep)
local sweep = generateFreqSweep(freqSweepStart,freqSweepStop,freqSweepStep)
for sweepIndex=0,stepN do print(sweep[sweepIndex]) end

-- 
-- current sweep signal
--

local currentLevels = {}
local signalSampleIndex=0

for sweepIndex=0,stepN do	
	local freq = sweep[sweepIndex]
	print("generate signal")
	print(string.format("frequency sweep index: %g - freq: %g", sweepIndex,freq))
	
	local generatedSignal = generateSinusoidalSignal(samplingFreq,N,freq,amplitude)
	for i, value in generatedSignal do
		currentLevels[signalSampleIndex]= value
		signalSampleIndex = signalSampleIndex+1
	end		
end

--local currentLevels = generateSinusoidalSignal(samplingFreq,N,signalFrequency,amplitude)

--
--Reset the instrument
--


reset()
defbuffer1.clear()

print("start programming instrument")

smu.source.configlist.create("CurrentListSweep")
smu.source.func = smu.FUNC_DC_CURRENT
--smu.source.range = 10
smu.source.vlimit.level = 21
for index = 1, table.getn(currentLevels) do
smu.source.level = currentLevels[index]
smu.source.configlist.store("CurrentListSweep")
end

--
--Measure Settings
--
smu.measure.func = smu.FUNC_DC_VOLTAGE
smu.measure.autorange = smu.ON
smu.measure.nplc = 1
smu.measure.sense=smu.SENSE_4WIRE
smu.measure.autozero.enable = smu.OFF
smu.measure.autozero.once()

--
--Source Settings
--
smu.source.func = smu.FUNC_DC_CURRENT
smu.source.vlimit.level = 21

delay = 1/samplingFreq 
repetition =1
startFrom = 1

print(string.format("configure sweeplist current Sweep delay: %g , repetition: %g",delay, repetition))
smu.source.sweeplist("CurrentListSweep", startFrom, delay,repetition)

print("RUN TRIGGER >>>>>>")
--Run trigger model and wait for it to complete
trigger.model.initiate()
waitcomplete()
print(">>>>> END ")

print("getting raw data ....")

--Print Results
if defbuffer1.n == 0 then
	print("Buffer is empty\n")
else
	print("Time\tCurrent\tVoltage")
	for i=1,defbuffer1.n do
		print(string.format("%s\t%g\t%g",defbuffer1.timestamps[i],defbuffer1.sourcevalues[i], defbuffer1.readings[i]))
	end
end
