
# coding: utf-8

# In[13]:

#taken input is an array assuming the filtered signal will be in form of an array
import numpy
#arr=[1,2,3,4,5]
def spectral_centroid(arr):
    Fs=11025
    x_n=numpy.abs(numpy.fft.fft(arr))
    #print(x_n)
    sum_num=0
    for var in range(len(x_n)):
        sum_num = sum_num + x_n[var]*(var+1) 
    #print(sum_num)
    centroid=Fs/len(arr)*sum_num/numpy.sum(x_n)
    return (centroid)


# In[ ]:



