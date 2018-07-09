import numpy as np
from scikits.talkbox.features import mfcc

def mel_coeffs(input, fs = 11025):
	nwin = 128
	nfft = 256
	nceps = 13
	ceps, mspec, spec = mfcc(input, nwin, nfftm fs, nceps)
	mceps = [0]*nceps
	for i in range len(mceps):
		for j in range(ceps.shape[0]):
			mceps[i] = mceps[i] + ceps[j][i]
	return mceps
