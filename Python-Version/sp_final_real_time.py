import numpy as np
import scipy
import data_acquisition as voice
import preprocessing
import featureExtraction as fe
import smoothen
from transferFunction import transfer_function
import scipy.io as sio
seed = sio.loadmat('../seed1.mat')

Fs = 11025
smooth_factor = 1
NoOfSeconds = 3
NoOfTrials = 1
NUM_LAYERS = len(seed['net'][0])
print("Subject get ready")
audio = voice.record(NoOfSeconds, NoOfTrials, Fs)
filtered_audio = preprocessing.preprocess(audio, Fs)
features_test = fe.extract(filtered_audio,Fs)
features = seed['features'].tolist()
features.extend(features_test)
feat = smoothen.features(features)
feat_test = feat[750:751]
size = np.shape(feat_test)
w = seed['final_weights']
x=np.transpose(feat_test)
v=[]	#list of numpy arrays
output = []

y = []
for _ in range(1, NUM_LAYERS+2):
	y.append([])

for it in range(1,2):
	v = []
	y[0] = [1]
	y[0].extend(x[:, it-1])
	for j in range(1, NUM_LAYERS+1):
		v.append(w[0][j-1].dot(np.transpose([y[j-1]])))
		if j != NUM_LAYERS:
			y[j] = [1]
			y[j].extend(transfer_function(v[j-1]))
		else:
			y[j] = transfer_function(v[j-1])
	output.append(y[-1])
#print(output)
speaker_op = []
for i in range(len(output)):
	k = 1
	for j in range(len(output[i])):
		if output[i][j] >= 0.5:
			speaker_op.append([j+1, output[i][j][0]*100])

print(speaker_op)
