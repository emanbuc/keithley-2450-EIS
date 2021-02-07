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

function saveToFile(dataFileName, samples)
	file_num = file.open(dataFileName,file.MODE_WRITE)
	if file_num != nil then
		i=1
		while samples[i] do
			value = samples[i]
			file.write(file_num,string.format("%g;%g \r\n",i,value))
			i=i+1
		end		
		file.close(file_num)
	end
end

-- ========================================
-- SETTING

local sourceDelay = 0 -- [s]
local delay = 0.1 -- [s]
local nplc = 0.01 -- range from 0.01 to 10 , default 1
local fileName = "sweep_test_R10K_load.csv"
local currentSignalFileName = "current_sweep_timebased.csv"
local repetition = 1

-- Frequency sweep configuration
--
local freqSweepStart = 0.1
local freqSweepStop = 0.2
local freqSweepStep = 0.1

--  sinusoidal waveform parameters
-- 
local sampleTime = 0.1 -- output signal sampling period [s]
local A = 1e-3 -- current signal amplitude [A]
local po=0 -- phase offset
local b = 0 -- DC bias
local N = 1000 -- signal lengh (sample number)

-- ======================================
--  GENERATE CURRENT SIGNAL ---
-- --------------------------------------



-- Frequency sweep calculation
-- 
local stepN = math.floor((freqSweepStop - freqSweepStart)/freqSweepStep)
print("Frequency sweep. start: %g, stop: %g , step: %g",freqSweepStart,freqSweepStop,freqSweepStep)
local sweep = generateFreqSweep(freqSweepStart,freqSweepStop,freqSweepStep)
for sweepIndex=0,stepN do print(sweep[sweepIndex]) end



-- signal generation
--

local currentLevels = {}
local signalSampleIndex=0

for sweepIndex=0,stepN do	
	local freq = sweep[sweepIndex]
	print("generate signal")
	print(string.format("frequency sweep index: %g - freq: %g", sweepIndex,freq))
	
	--local signalPeriod = 1/signalFrequency
	--local N= math.floor(signalPeriod/sampleTime)

--	local generatedSignal = generateSinusoidalSignalSampleBased(sampleTime,freq,N,A,po,b)
	local generatedSignal = generateSinusoidalSignal(sampleTime,freq,A,po,b)
	
	for i, value in generatedSignal do
		currentLevels[signalSampleIndex]= value
		signalSampleIndex = signalSampleIndex+1
	end		
end


print("Save current signal  to file")
saveToFile(currentSignalFileName,currentLevels)

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
smu.source.range = 10e-3
smu.source.delay = sourceDelay
smu.source.readback = smu.OFF

--
--Measure Settings
--
smu.measure.func = smu.FUNC_DC_VOLTAGE
smu.measure.range = 10
smu.measure.nplc = nplc
smu.measure.sense=smu.SENSE_4WIRE
smu.measure.autozero.enable = smu.OFF
smu.measure.autozero.once()

print(string.format("configure sweeplist current Sweep delay: %g , repetition: %g",delay, repetition))
smu.source.sweeplist("CurrentListSweep", 1,delay,repetition)

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
	print("Time,Current,Voltage")
	for i=1,defbuffer1.n do
		print(string.format("%s,%g,%g",defbuffer1.timestamps[i],defbuffer1.sourcevalues[i], defbuffer1.readings[i]))
	end
end

-- save to file
print("Save data to file")
file_num = file.open(fileName,file.MODE_WRITE)
if file_num != nil then
	print("Time;Current;Voltage")
	for i=1,defbuffer1.n do
		file.write(file_num,string.format("%s;%g;%g \r\n",defbuffer1.timestamps[i],defbuffer1.sourcevalues[i], defbuffer1.readings[i]))
	end
	file.close(file_num)
end
