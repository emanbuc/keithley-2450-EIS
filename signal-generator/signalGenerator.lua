local signalGenerator = {}
function signalGenerator.generateFreqSweep(freqSweepStart,freqSweepStop,freqSweepStep)
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

-- ==============================================

-- Generate sine wave
-- A is the amplitude of the sine wave.
-- b is the signal bias
-- po is the offset (phase shift) of the signal.
-- sampleTime: Specify the sample period in seconds 
-- reference: https://it.mathworks.com/help/simulink/slref/sinewavefunction.html

function signalGenerator.generateSinusoidalSignal(sampleTime,signalFrequency,A,po,b)
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

function signalGenerator.generateSinusoidalSignalSampleBased(sampleTime,signalFrequency,N,A,po,b)
	print(string.format("signal frequency %g",signalFrequency))
	local signal = {}    -- new array
	for k=0,N-1 do 
		signal[k]=A*math.sin(2*math.pi*k*sampleTime+po)+b
	end
	return signal
end

return signalGenerator;