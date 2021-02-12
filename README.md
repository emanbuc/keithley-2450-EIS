# keithley-2450-EIS

Scopo del progetto è verificare sperimentalmente la possibilità di eseguire un EIS utilizzando lo strumento smu Keithley 2450. Questo tipo di esame non è tra le applicazioni riportate nelle documentazione, ma almeno in teoria i dati di targa dovrebbero permettere la misura, almeno per basse frequenze.

Commercial instruments are available that can measure impedances from mΩ to TΩ and over frequencies from μHz to MHz.

The measurement of battery impedance is crucial for online monitoring of State of Charge and State of Health [1]


[Getting started](docs/getting_started.md)

[Electrochemical Impedance Spectroscopy (EIS)](docs/electrochemical-Impedance-spectroscopy.md)

[current sweep speed test](docs/current-sweep-speed-test.md)

Limitation of Keithley 2450 for EIS - TBD 

EIS with Impedency.py

[sinusoidal signal generator](docs/sinusoidal-signal-generator.md)

[frequency sweep signal generator](docs/frequency-sweep-signal-generator.md)

[Keithley 2450 remote operations](docs/keithley-2450-remote.md)

[Save data](docs/save-data.md)

Data from Resistive load

Data from RC load

Data from Li-On Battery

## Todo

- stepped sine frequency sweep  con frequenze dell'articolo: 0.05, 0.1, 0.2, 0.4, 1, 2,4,10,20,40 con - 10mA  prendere almeno un perido per ogni segnale. Provare 100sec per ogni step
  - RC
  - Batteria

- Usage of Multi-Sine Signals for Electrochemical Impedance Spectroscopy
