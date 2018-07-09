import csv
import numpy as np
import math

# w=final_weights	//to be read from a csv file
# also read features, labels from a csv file
'''with open('test1.csv', newline='') as csvfile:
     spamreader = csv.reader(csvfile, delimiter=',')
     for row in spamreader:
         #print(row)
         print(len(row))
         print(type(row[0]))
         w.append(list(map(float, row)))

#print(w[1][1])
#print(type(w[1][1]))
print(len(w), len(w[0]))'''

SMOOTH_FACTOR = 1
NUM_SECONDS = 2
NUM_TRIALS = 10
Fs = 11025
NET = [15,5]
ETA = [0.25, 0.25]
NUM_LAYERS = len(NET)
R = len(features);	C = len(features[0])

# preprocessing part comes here

# feature extraction part comes here

features = np.array([features, features_test])
feat = sp_smoothen_features(features, SMOOTH_FACTOR)
feat_test = feat[R+1 : (np.shape(feat)[0]), :]
size = np.shape(feat_test)

x=np.transpose(feat_test)
y=[]
v=[]

for i in range(1, NUM_LAYERS+2):
	y.append([])

for i in range(1, NUM_LAYERS+1):
	v.append([])

y[0] = [1]

for iter in range(1, size[0]+1):
	#y[0] = [1].extend(x[:, iter])
	y[0].extend(x[:, iter-1])
	for i in range(1, NUM_LAYERS+1):
		v[i-1] = list(w[i-1].dot(np.transpose(np.array([y[i-1]]))))
		if i != NUM_LAYERS :
			temp = list(map(lambda x: 1/(1+math.exp(-x)), v[i-1]))
			y[i] = [1]
			y[i].extend(temp)

		else:
			y[i] = list(map(lambda x : x, v[i-1]))

	