
# coding: utf-8

# In[ ]:

import numpy
import math
from scipy.signal import lfilter, hamming
    #from audiolazy import lpc
from scikits.talkbox import lpc
#import sounddevice as sd
def lpcc(arr):
    Fs=11025
    #rr = [1,2,3,4,5,6,7,7,88]
    N = len(arr)
    window = numpy.hamming(N)
    arr1=(arr*window)
    arr1 = lfilter([1], [1., 0.63], arr1)
    n_coeff =int( 2 + Fs / 1000) #no of coefficients
    A,e,k = (lpc(arr1, n_coeff)) #applying lpc
    fft_var=numpy.fft.fft(A,1024)
    fft_var=abs(fft_var)#taking abs
    squared_array=numpy.square(fft_var)
    ar=[]#power spectrum
    for i in squared_array:
        ar.append(e/i)
    log_signal=numpy.log(ar)
    ifft_signal=numpy.fft.ifft(numpy.transpose(log_signal),1024)
    return ifft_signal[:14].tolist()
    

