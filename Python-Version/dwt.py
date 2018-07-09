import numpy as np
import pywt
import math

def wenergy(arr, wavlet, levelOfDecomp):
	deCompMat = wt(arr,wavlet,levelOfDecomp)
	en = []
	ea = 0
	ed = []
	for i in xrange(len(deCompMat)):
		en.append(sum(j*j for j in deCompMat[i]))
	Ten = sum(en)
	for i in range(len(deCompMat)):
		if i == len(deCompMat)-1:
			ea = (en[i]/Ten)*100
		else:
			ed.append((en[i]/Ten)*100)
	retval = []
	retval.append(ea)
	retval.extend(ed)
	return retval

def wt(arr, wavlet, levelOfDecomp):
	cA, cD = pywt.dwt(arr, wavlet)
	deCompMat = []
	deCompMat.append(cD.tolist())
	if(levelOfDecomp > math.log(len(arr))/math.log(2)):
		print('invalid levels of decomposition')
	elif (levelOfDecomp>1 and levelOfDecomp<=math.log(len(arr))/math.log(2)):
		for i in range(1,levelOfDecomp):
			cA, cD = pywt.dwt(cA, wavlet)
			if (i < levelOfDecomp):
				deCompMat.append(cD.tolist())
			elif (i==levelOfDecomp):
				deCompMat.append(cD.tolist())
				deCompMat.append(cA.tolist())
	return deCompMat

