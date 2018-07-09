import numpy as np
import math

def transfer_function(v):
	(rows, cols) = ((v.shape)[0], (v.shape)[1])
	V = np.zeros((rows, cols))
	for i in range(rows):
		for j in range(cols):
			V[i][j] = 2/(1+math.exp(-2*v[i][j])) - 1

	return V

