# Electrochemical impedance spectroscopy (EIS) on batteries with Keintly 2450

This project aims to perform a Electrochemical impedance spectroscopy (EIS) on a Li-Ion rechargeable battery using the Keithley 2450 Source Measure Unit (SMU) Instrument. Even the EIS is not among the applications listed in the official documentation,  the features of the instrument allow to perform the impedance measurement up to 100Hz.

The measurement of battery impedance is crucial for online monitoring of State of Charge and State of Health [1](docs/references.md#1). Lab measurements with Keithley 2450 can be used as bechmark to validate data from custom build impedence monitoring system such as [2](docs/references.md#2)

## How To Prerform an EIS

[EIS](/docs/electrochemical-Impedance-spectroscopy.md)

TBC

## Configuration List on Keintly 2450

A configuration list is a list of stored settings for the source or measure function. Configuration lists allow you to store the function settings of the instrument and then return the instrument to those settings as needed.
The instrument also uses configuration lists to manage the settings for sweeps.

A configuration index contains **a copy of all instrument source or measure settings at a specific point**.
Configuration lists are typically made up of multiple indexes.
You can store a **maximum of 300,000 indexes**.

Measure configuration lists contain the source/measure function setting and the settings for the source/measure function, such as the NPLC, display digits, and math settings.

In this project a source and measure configuration list is created with source value from [sinusoidal signal generation](sinusoidal-signal-generator.md) included in the tSP script.



## Source Settings

TBC

### Source Signal

Le misure eseguite su batteria XXX con corrente di 1mA si sono rivelate molto rumorose. Migliori risultati sono stati ottentui con correnti di 10mA.

### NPLC

NPLC Set the amount of time that the input signal is measured. Lower NPLC settings result
in faster reading rates, but increased noise. Higher NPLC settings result in lower
reading noise, but slower reading rates.

The amount of time is specified in parameters that are based on the number of power line cycles
(NPLCs). Each power line cycle for 60 Hz is 16.67 ms (1/60); for 50 Hz, it is 20 ms (1/50).

### Source Delay e frequenza di campionamento per EIS

Tra le diverse misurazioni è necessario introdurre un ritardo (`smu.sorce.delay`) per permettere alla sorgente di corrente raggiungere il livelo programmato e stabilizzarsi.

Lo strumento sarebbe in grado di eseguire le misure di tensione ai terminal del DUT con un intervallo di circa 1mS, ma l'intervallo di campionamento non è costante. 

Sperimentalemte è stato determinato che l'intervallo minimo che è possibile ottenere con `smu.source.readback = smu.ON`, `nplc=0.01`  e le forme d'onda sinusoidali nel range di frequenze utilizzate per l'esperimento è variabile e compreso tra 1ms e 3ms

Sembra non si apossibile ridurre l'incetezza sul timing dell'esecuzuioendella misura. 


La variabilità assoluta dell'intervallo di campionamento sembra  essere indipendente dal valore del paramtro `smu.sorce.delay`: per valori comoresi tra 0 e 10
Non è stato possibile ridurre la variabilità dell'intervallo di campionamento che rimane sempre di circa 

Impostando un `sorce delay=0.01` si ottiene un intervallo di campionamento pari a circa 10-12ms per  tutte le frequenza testate tra 0.05Hz e 40Hz

Questa scelta consente inoltre di utilizzare un valore  di nplc più elevato per aumentare ridurre la rumososità della misura senza limitare in maniera significativa l'analisi spettrale.

I due valori permettono un trade-off tra frequenza di campionamento e rumorosità della misura. Negli esperimenti sono state provate ad esempio le combinaizoni:

- `sorce delay=0.01 , nplc=0.1` permette di ottenere ottenere un intervallo di campionamento di 15ms con variabilità inferiore ad 1ms.
- `sorce delay=0.005 , nplc=0.04` permette di ottenere ottenere un intervallo di campionamento di circa 7ms con variabilità inferiore ad 1ms
- `sorce delay=0.005 , nplc=0.05` permette di ottenere ottenere un intervallo di campionamento di circa 7.5ms con variabilità inferiore ad 1ms

Il valore esatto delle frequnaza di campionamento dipende dalla frequenza della tensione che alimenta lo strumento e non è quindi determinabile a priori con precisione. Approssimativamente 50Hz in Italia, ma localmente si possono verificare scostamenti significativi.

### Source Range

## Measure Settings

xxx

### Measure Range

xx
