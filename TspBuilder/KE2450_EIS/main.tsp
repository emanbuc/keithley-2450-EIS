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

function generateSinusoidalSignal(sampleTime,signalFrequency,A,po,b)
	print(string.format("signal frequency %g",signalFrequency))
	local signalPeriod = 1/signalFrequency
	local p= math.floor(signalPeriod/sampleTime) -- p is the number of time samples per sine wave period
 
	local signal = {}    -- new array
	for k=0,p-1 do 
		--k is a repeating integer value that ranges from 0 to p–1
		-- y=Asin(2pi(k+o)/p)+b
		signal[k]=A*math.sin(2*math.pi*(k+po)/p)+b
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


-- signal generation
--

local currentLevels = {}
local signalSampleIndex=0

for sweepIndex=0,stepN do	
	local freq = sweep[sweepIndex]
	print("generate signal")
	print(string.format("frequency sweep index: %g - freq: %g", sweepIndex,freq))
	
	local generatedSignal = generateSinusoidalSignal(sampleTime,freq,A,po,b)
	for i, value in generatedSignal do
		currentLevels[signalSampleIndex]= value
		signalSampleIndex = signalSampleIndex+1
	end		
end


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
--Source Settings
--
smu.source.func = smu.FUNC_DC_CURRENT
smu.source.vlimit.level = 21
smu.source.delay = 0
smu.source.readback = smu.OFF

--
--Measure Settings
--
smu.measure.func = smu.FUNC_DC_VOLTAGE
smu.measure.autorange = smu.ON
smu.measure.nplc = 0.01
smu.measure.sense=smu.SENSE_4WIRE
smu.measure.autozero.enable = smu.OFF
smu.measure.autozero.once()


delay = sampleTime
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
