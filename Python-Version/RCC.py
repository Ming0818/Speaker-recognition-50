
# coding: utf-8

# In[27]:

import numpy
import math
from scipy.signal import hamming
def rcc(arr):
    #arr=list(range(200))
    N = len(arr)
    window = numpy.hamming(N)
    arr=(arr*window)
    #print(arr)
    fft_signal = numpy.fft.fft(arr)
    #print(fft_signal)
    log_signal=numpy.log(fft_signal)
    ifft_signal=numpy.fft.ifft(log_signal)
    real_cepstrum=(numpy.abs(ifft_signal))
    real_cepstrum = real_cepstrum[:20]
    return (real_cepstrum)


# In[ ]:


