# Sustracción Espectral

## Descripción

Fichero Matlab que implementa el algoritmo de sustracción espectral detallado en el artículo de Steven Boll de 1979 "Suppression of acoustic noise in speech using spectral subtraction" 

## Archivos

+ **SustraccionEspectral_1.m**: implementa la sustracción espectral de la manera más simple.
+ **SustraccionEspectral_2.m:** implementa la sustracción espectral incluyendo eliminación de ruido musical y atenuación de las tramas  sin actividad vocal.
+ **wavread.m**: fichero que implementa la antigua función wavread de Matlab.
+ **wavwrite.m**: fichero que implementa la antigua función wavwrite de Matlab.
+ **noisy.wav**: fichero de ejemplo de una señal de voz con ruido Gray con una relación señal a ruid (SNR) de 0dB.
+ **clean.wav**: fichero de ejemplo que contiene a la señal limpiada una vez pasada por el algoritmo de sustracción espectral.

## Uso

```
SustraccionEspectral_1('noisy.wav','clean.wav');
```
ó
```
SustraccionEspectral_2('noisy.wav','clean.wav');
```

### Entradas

+ **noisy.wav**: fichero que contiene a la señal original contaminada con ruido.
+ **clean.wav**: nombre que deseemos que tenga el fichero con la señal limpia.

### Salidas

Este algoritmo no tiene salidas. El resultado se escribe en memoria en el archivo 'clean.wav' introducido como entrada.

## Resultados

A continuación se representa el espectro de la señal 'clean.wav' para cada uno de los ficheros SustraccionEspectral. Se observa que cuando se usa SustraccionEspectral_2.m se obtiene la eliminación de algunos picos considerados ruido musical y la atenuación de las tramas consideradas sin actividad vocal:

#### Sustracción Espectral 1
![SustraccionEspectral_1.m](https://raw.githubusercontent.com/BorjaRP93/SustraccionEspectral/master/Screenshots/1.png   "Resultados con SustraccionEspectral_1.m")
#### Sustracción Espectral 2 (Sin ruido musical y con tramas sin actividad vocal atenuadas)
![SustraccionEspectral_2.m](https://raw.githubusercontent.com/BorjaRP93/SustraccionEspectral/master/Screenshots/2.png "Resultados con SustraccionEspectral_2.m")



# English Version: Spectral Subtraction

## Description

Matlab file that implements the spectral subtraction algorithm detailed in the article by Steven Boll of 1979 "Suppression of acoustic noise in speech using spectral subtraction"

## Files

+ **SustraccionEspectral_1.m**: implements the spectral subtraction in the simplest way.
+ **SustraccionEspectral_2.m:** implements the spectral subtraction including elimination of musical noise and attenuation of the frames without vocal activity.
+ **wavread.m**: file that implements the old wavread function of Matlab.
+ **wavwrite.m**: file that implements the old wavwrite function of Matlab.
+ **noisy.wav**: sample file of a voice signal with Gray noise with a signal-to-noise ratio (SNR) of 0dB.
+ **clean.wav**: sample file that contains the cleaned signal once passed by the spectral subtraction algorithm.

## Use

```
SustraccionEspectral_1('noisy.wav', 'clean.wav');
```
or
```
SustraccionEspectral_2('noisy.wav', 'clean.wav');
```

### Inputs

+ **noisy.wav**: file that contains the original signal contaminated with noise.
+ **clean.wav**: name that we want the file to have with the clean signal.

### Outputs

This algorithm has no outputs. The result is written in memory in the file 'clean.wav' entered as input.

## Results

Next, the spectrum of the 'clean.wav' signal is represented for each of the SustraccionEspectral files. It is observed that when SustraccionEspectral_2.m is used, the elimination of some peaks considered musical noise and the attenuation of the considered frames without vocal activity is obtained:

#### Spectral Subtraction 1
![SustraccionEspectral_1.m](https://raw.githubusercontent.com/BorjaRP93/SustraccionEspectral/master/Screenshots/1.png   "Results with SustraccionEspectral_1.m")
#### Spectral Subtraction 2 (without musical noise and attenuation of no vocal activity frames)
![SustraccionEspectral_2.m](https://raw.githubusercontent.com/BorjaRP93/SustraccionEspectral/master/Screenshots/2.png "Results with SustraccionEspectral_2.m")
