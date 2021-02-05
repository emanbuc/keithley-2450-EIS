-- create a number sequence generator as a closure
function sequence(from,to,step)
  local i = from - 1
  return function()
    if i < to then
      i = i + step
      return i
    end
  end
end

-- generate signal
-- local N = 10 -- # numero campioni per periodo da generare
-- local samplingFreq = 100 [Hz]
-- local signalFrequency = 2
-- local amplitude = 1e-3 [A]
function generateSinusoidalSignal(samplingFreq,N,signalFrequency,amplitude)
	local samplingPeriod = 1/samplingFreq
	local signal = {}    -- new array
	for i in sequence(0,N) do 
		signal[i]=math.sin(2*math.pi*signalFrequency*i*samplingPeriod)* amplitude
	end
	return signal
end


local N = 100 -- # numero campioni per periodo da generare
local samplingFreq = 100 --[Hz]
local signalFrequency = 2
local amplitude = 1e-3 --[A]

local generatedSignal = generateSinusoidalSignal(samplingFreq,N,signalFrequency,amplitude)

for i in generatedSignal do
	print(generatedSignal[i])
end

-- ix = np.arange(N) # sample index
-- freq = 2 # Frequenza sinusoide Hz
-- amplitude = 1e-3
-- time = ix*samplingPeriod
-- signal = np.sin(2*np.pi*freq*time)*amplitude
--period= 1/freq
-- print("sampling period [s]:")
-- print(samplingPeriod)
-- print(signal)