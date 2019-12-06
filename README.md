EGG Code - Nicolai Wolpert (2019)
=======================


When using this function in any published study, please cite: Wolpert, N., Rebollo, I.,
Tallon-Baudry, C. (2019). Electrogastrography for psychophysiological 
research: practical guidelines and normative data.

Copyright (C) 2019, Laboratoire de Neurosciences Cognitives, Nicolai Wolpert, 
Ignacio Rebello & Catherine Tallon-Baudry
Email: nicolaiwolpert@gmail.com

DISCLAIMER:
This code is provided without explicit or implicit guarantee, and without any 
form of technical support. The code is not intended to be used for clinical 
purposes. The functions are free to use and can be redistributed, modified 
and adapted, under the terms of the CC BY-NC-SA version of creative commons 
license (see <https://creativecommons.org/licenses/>).

Purpose
-------------

The aim of these scripts is to help the reader getting started with processing
and analyzing the EGG signal. It provides some functions to filter and visualize
the signal and detect artifacts.
We also provide example EGG data that can be used in these scripts (Names: 
'EGG_raw_example1.mat', 'EGG_raw_example2.mat' and 'EGG_raw_example3.mat').
EGG data that are loaded in this script have to be in fieldtrip format (e.g.
the output of 'ft_preprocessing'), without any highpass-filter.

Instructions
-----------------------

1. The scripts are using the fieldtrip toolbox (Oostenveld et al., 2011).
To install, go to
http://www.fieldtriptoolbox.org/download/ and follow the instructions on
http://www.fieldtriptoolbox.org/faq/should_i_add_fieldtrip_with_all_subdirectories
_to_my_matlab_path/

2. All the functions are called from 'Script_EGG_main'. Example data sets are
provided. Download the data sets and specify the path and name in Script_EGG_main,
as well as the path to the fieldtrip toolbox.

3. Call 'compute_FFT_EGG'.
Input: Raw EGG data in fieldtrip format
This function computes a power spectrum for all the channels and outputs a fieldtrip 
structure containing the power spectrum.
It plots the power spectrum, showing the channels in different colors and
highlighting the normogastric range (0.033-0.067 Hz). The channel with the
maximal power in normogastric range is highlighted with a star at the frequency
of maximum power.
Output: Fieldtrip data structure containing the power spectra, selcted channel and peak
frequency.

4. Call 'compute_filter_EGG'.
Input: Raw EGG data, power spectrum (fieldtrip structure, output from 
'compute_FFT_EGG')
This function filters the EGG and computes the amplitude and phase of the EGG, 
on the channel with the highest peak in the power spectrum in the normogastric 
range.
Output: Fieldtrip data structure with the filtered signal, amplitude and 
phase.

5. Call ‘plot_EGG_visual_inspection'. 
Input: Filtered signal (output from 'compute_filter_EGG')
This function creates a plot with the raw signal (first row), filtered signal
(second row), phase time series (third row) and amplitude (fourth row).
Output: plot

6. Call 'show_prop_normogastria'. 
Input: Filtered signal (output from 'compute_filter_EGG')
This function creates a plot with a histogram of cycle durations, with dotted
red lines marking the mean +/- 3 standard deviations.
Output: plot

7. Call 'detect_EGG_artifacts'. 
Input: Filtered signal (output from 'compute_filter_EGG')
This function looks for artifacted cycles in the phase time series. The two 
criteria for a cycle to be considered as artifact are: 1. A non-monotonous
change in phase 2. a cycle duration below/above +/- 3 standard deviations.
The function creates a plot with the raw signal (first row), the filtered 
signal (second row), the phase time series (third row) and the amplitude
(fourth row). Artifacted cycles are shaded in red in the third row.
Output: matrix with start and end samples of the artifacts
