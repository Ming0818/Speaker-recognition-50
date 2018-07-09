import numpy as np
def params(arr):
	y = arr
	x = [i for i in range(len(arr))]
	jactivity = np.var(y,ddof=1)
	dy_dx = np.diff(y)
	dy_dx = np.concatenate((np.zeros((1,)), dy_dx))
	jmobility = np.sqrt(np.var(dy_dx,ddof=1)/jactivity)

	dy_dx2 = np.diff(dy_dx)
	dy_dx2 = np.concatenate((np.zeros((1,)), dy_dx2))
	jmobility2 = np.sqrt(np.var(dy_dx2,ddof=1)/jactivity)
	jcomplexity = jmobility2/jmobility

	return (jactivity, jmobility, jcomplexity)