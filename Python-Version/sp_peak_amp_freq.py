import numpy as np

def peakFreq(arr, length):
	fft = list(map(abs, np.fft.fft(arr)))
	peak_amp = max(fft)
	peak_freq = fft.index(peak_amp) * (length/len(arr))

	return (peak_amp, peak_freq)
