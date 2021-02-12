# EIS for batteries

The measurement of battery impedance is crucial for online monitoring of State of Charge (SoC) and State of Health (SoH) (1)

## Configuration List

A configuration list is a list of stored settings for the source or measure function. You can restore
these settings to change the function and its settings that are used by the instrument.
Configuration lists allow you to store the function settings of the instrument and then return the
instrument to those settings as needed.
The instrument also uses configuration lists to manage the settings for sweeps.

A configuration index contains a copy of all instrument source or measure settings at a specific point.
Configuration lists are typically made up of multiple indexes.
You can store a maximum of 300,000 indexes

Measure configuration lists contain the measure function
setting and the settings for the measure function, such as the NPLC, display digits, and math settings.


## Source Signal

Le misure eseguite su batteria XXX con corrente di 1mA si sono rivelate molto rumorose. Migliori risultati sono stati ottentui con correnti di 10mA.

## Soruce Delay

Tra le diverse misurazioni è necessario introdurre un ritardo (`smu.sorce.delay`) per permettere alla sorgente di corrente raggiungere il livelo programmato e stabilizzarsi.


## References

[1] A. Guha and A. Patra, "Online Estimation of the
Electrochemical Impedance Spectrum and
Remaining Useful Life of Lithium-Ion Batteries," in
IEEE Transactions on Instrumentation and
Measurement, vol. 67, no. 8, pp. 1836-1849, 2018.