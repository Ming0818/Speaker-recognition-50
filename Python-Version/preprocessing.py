import scipy as sp
import numpy as np
import scipy.io as sio

def preprocess(audio, fs):
	rows = audio.shape[0]
	#audio_stripped = np.zeros((rows,audio.shape))
	filtered_audio = np.zeros((rows,), dtype="object");

	for r in range(rows):
		#audio_stripped[r] = remove_silence_part(audio[r])
		filtered_audio[r] = remove_trailing_zeros(remove_silence_part(audio[r],fs))
		filtered_audio[r] = butterworth_filter(filtered_audio[r], fs,'band', [150,250,3000,3200],10)
	return filtered_audio

def remove_silence_part(audio, fs):
	### Threshold ###
	baseline = 1 #second
	noise_length = baseline*fs;
	scaling_factor = 0.7;
	max_val = max(audio[20:noise_length], key=abs)
	threshold = scaling_factor*max_val
	### end threshold ###
	### Removing silence part ###
	frame_dur = 0.01
	if(audio.shape[0] > frame_dur*fs):
		frame_len = np.floor(fs * frame_dur)
		n = audio.shape[0]
		num_frames = np.floor(n / frame_len)
	
	else:
		audio.shape[0]
		frame_len = audio.shape[0]
		n = audio.shape[0]
		num_frames = 1

	count = 0
	processed_audio = np.zeros((n))
	for k in range(1,int(num_frames)):		
		frame = audio[int((k-1)*frame_len) :int(frame_len*k)]
		frame = frame - np.mean(frame)
		frame_max = max(frame)
		if(frame_max > threshold):
			count = count + 1
			processed_audio[int((count-1)*frame_len) : int(frame_len*count)] = frame
	return processed_audio
		###End removing silence part ###

def remove_trailing_zeros(audio):
	for i in range(audio.shape[0]-1,0,-1):
		if(audio[i]!=0):
			break
	i = i+1
	new_sig = np.zeros((i,));
	new_sig = audio[:i]
	return new_sig

def butterworth_filter(audio, fs, filter_type, cutoff, order=-1):
	rp = 1
	rs = 60
	if(len(cutoff)==4):
		ws1 = 2.0*cutoff[0]/fs
		wp1 = 2.0*cutoff[1]/fs
		wp2 = 2.0*cutoff[2]/fs
		ws2 = 2.0*cutoff[3]/fs
		wn = [wp1, wp2]
	elif(len(cutoff)==2):
		wp1 = 2.0*cutoff[0]/fs
		ws1 = 2.0*cutoff[1]/fs
		wn = wp1

	elif(len(cutoff)==1):
		wp1 = 2.0*cutoff/fs
		wn = wp1

	else:
		print("Error, give proper cut-off values")

	if(order==-1):
		if(len(cutoff==2)):
			order, wn = sp.signal.buttord(wp1,ws1,rp,rs)
		elif(len(cutoff)==4):
			order, wn = sp.signal.buttord([wp1,wp2], [ws1, ws2], rp, rs)
		else:
			print("ERROR: provide proper values")
	b, a = sp.signal.butter(order, wn, filter_type)	
	audio1 = sp.signal.lfilter(b,a,audio)
	return audio1
