import sounddevice as sd
import numpy as np

def record(noOfSeconds, noOfTrials, Fs):
	duration = noOfSeconds;
	fs = Fs;

	sd.default.samplerate = fs;

	myrecording = np.zeros((noOfTrials,duration*fs))
	for i in range(noOfTrials):	
		print("Speak now")
		myrecording[i]=np.transpose(np.array(sd.rec(duration*fs, samplerate=fs, channels=1, blocking=True)))

	return myrecording
