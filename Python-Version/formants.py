import numpy
import math
from scipy.signal import lfilter, hamming
    #from audiolazy import lpc
from scikits.talkbox import lpc

def formant(arr):
    # entered array is the recorded array using the data acquisation
    

        #duration = 2;
        #fs = 11025;

        #sd.default.samplerate = fs;

        #print("Speak now")
        #arr = sd.rec(duration*fs, samplerate=fs, channels=1, blocking=True)
        #from scikits.talkbox import lpc
        # applying hamming window
    Fs=11025
    #rr = [1,2,3,4,5,6,7,7,88]
    N = len(arr)
    window = numpy.hamming(N)
    arr1 = arr * window
    arr1 = lfilter([1], [1., 0.63], arr1)
    n_coeff =int( 2 + Fs / 1000) #no of coefficients
    
    A,e,k = (lpc(arr1, n_coeff))#applying lpc
    #A.numpolyz(A)
    rts = numpy.roots(A)
    rts = [r for r in rts if numpy.imag(r) >= 0] #only positive roots
    angz = numpy.arctan2(numpy.imag(rts), numpy.real(rts)) # taking angles

    for_freq = sorted(angz * (Fs / (2 * math.pi)))
    return (for_freq)
