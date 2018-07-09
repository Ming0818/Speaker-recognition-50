import numpy as np
import math 

def pitch_period(arr, Fs):
	xcorr_arr = np.correlate(arr, arr,'full').tolist()
	max_index = xcorr_arr.index(max(xcorr_arr))

	for i in range (0, int(math.floor(len(arr)/2))):
		if xcorr_arr[max_index+i] > xcorr_arr[max_index+i-1]:
			min_index_delay = i-1
			break
	
	temp_arr = xcorr_arr[max_index+min_index_delay+1:]
	max_index2 = temp_arr.index(max(temp_arr))

	pitch_period1 = (min_index_delay+max_index2)/Fs

	samples1 = max_index + min_index_delay + max_index2
	for i in range(0, int(math.floor(len(arr)/2))):
		if xcorr_arr[samples1+i] > xcorr_arr[samples1+i-1]:
			min_index_delay2=i-1
			break

	temp_arr = xcorr_arr[samples1+min_index_delay2+1:]
	max_index3 = temp_arr.index(max(temp_arr))

	pitch_period2=(min_index_delay2+max_index3)/Fs

	samples2 = samples1+min_index_delay2+max_index3

	for i in range(0, int(math.floor(len(arr)/2))):
		if xcorr_arr[samples2+i] > xcorr_arr[samples2+i-1]:
			min_index_delay3=i-1
			break

	temp_arr = xcorr_arr[samples2+min_index_delay3+1:]
	max_index4 = temp_arr.index(max(temp_arr))

	pitch_period3=(min_index_delay3+max_index4)/Fs

	return [pitch_period1, pitch_period2, pitch_period3]
