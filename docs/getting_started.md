# Getting Started

Edit experiment parameters in `main.tsp` file

```lua
-- experiment parameters
local sourceDelay = 0 -- [s]
local delay = 0.01 -- [s]
local nplc = 0.01 -- range from 0.01 to 10 , default 1
local resultFileNamePrefix = "test_battery_readback_10ms_10ma"
local sourceFilenamePrefix = "generatedCurrent_10ms_10ma"
local sourceLabel = "Current"
local readingLabel = "Voltage"
local repetition = 1
local measureRange = 5 --[V]

--  sinusoidal waveform parameters
local sampleTime = delay -- output signal sampling period [s]
local A = 0.010 -- current signal amplitude [A]
local po=0.01 -- phase offset
local b = 0 -- DC bias
local signalDuration = 100 -- [s]

-- frequency sweep
local sweep = {0.05,0.1,0.2,0.4,1,2,4,10,20,40}

```

## Run from PC



## Run locallly on the instrument

