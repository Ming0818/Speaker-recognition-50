import numpy as numpy
import scipy as sp
import sp_peak_amp_freq
import sp_pitch_period
import formants
import LPCC
import RCC
import lsf
import hjorth
import dwt

def extract(filtered_audio, Fs):
	nfft = 256
	num_bins = 40
	start_frequency = 150
	end_frequency = 3200
	c = filtered_audio.shape[0]
	features = []
	for i in range(c):
		features.append([])
		peak_amp, peak_freq = sp_peak_amp_freq.peakFreq(filtered_audio[i],50)
		pitch_periods = sp_pitch_period.pitch_period(filtered_audio[i],Fs)
		form = formants.formant(filtered_audio[i])
		cep = LPCC.lpcc(filtered_audio[i])
		real_cc = RCC.rcc(filtered_audio[i])
		lsfs = lsf.LSF(filtered_audio[i])
		hjorth_parameters = hjorth.params(filtered_audio[i])
		wavelet = dwt.wenergy(filtered_audio[i],'db7',5);
		features[i].extend(lsfs)
		features[i].extend(hjorth_parameters)
		features[i].extend(wavelet)
	return features		


