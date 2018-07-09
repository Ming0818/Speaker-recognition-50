import numpy as np
import scipy as sp
from scikits.talkbox import lpc
def LSF(arr):
	Fs=11025
	#rr = [1,2,3,4,5,6,7,7,88]
	N = len(arr)
	window = np.hamming(N)
	arr1 = arr * window
	arr1 = sp.signal.lfilter([1], [1., 0.63], arr1)
	n_coeff =int( 2 + Fs / 1000) #no of coefficients
	A,e,k = (lpc(arr1, n_coeff))#applying lpc
	lsfs = poly2lsf(A)
	return lsfs

def poly2lsf(a):
	a = np.array(a)
	if a[0] != 1:
		a/=a[0]
		if max(np.abs(np.roots(a))) >= 1.0:
			error('The polynomial must have all roots inside of the unit circle.');


	# Form the sum and differnce filters

	p  = len(a)-1   # The leading one in the polynomial is not used
	a1 = np.concatenate((a, np.array([0])))        
	a2 = a1[-1::-1]
	P1 = a1 - a2        # Difference filter
	Q1 = a1 + a2        # Sum Filter 

	# If order is even, remove the known root at z = 1 for P1 and z = -1 for Q1
	# If odd, remove both the roots from P1

	if p%2: # Odd order
		P, r = sp.signal.deconvolve(P1,[1, 0 ,-1])
		Q = Q1
	else:          # Even order 
		P, r = sp.signal.deconvolve(P1, [1, -1])
		Q, r = sp.signal.deconvolve(Q1, [1,  1])

	rP  = np.roots(P)
	rQ  = np.roots(Q)

	aP  = np.angle(rP[1::2])
	aQ  = np.angle(rQ[1::2])

	lsf = sorted(np.concatenate((-aP,-aQ)))

	return lsf
