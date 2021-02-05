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


local freqSweepStart = 0.1
local freqSweepStop = 0.2
local freqSweepStep = 0.1

local stepN = math.floor((freqSweepStop - freqSweepStart)/freqSweepStep)

local sweep = generateFreqSweep(freqSweepStart,freqSweepStop,freqSweepStep)
for i=0,stepN do
	--print(string.format("index: %g - freq: %g", i,f))
	print(sweep[i])
end
