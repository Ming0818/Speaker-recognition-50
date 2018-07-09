def features(feat):
	r = len(feat)
	c = len(feat[0])
	for i in xrange(c):
		column_mean = 0
		column_sum = 0
		column_max = feat[0][i]
		for rows in xrange(r):
			column_sum = column_sum+feat[rows][i]
			if(feat[rows][i]>column_max):
				column_max = feat[rows][i]

		column_mean = column_sum/(rows+1)
		for rows in xrange(r):
			feat[rows][i] = (feat[rows][i] - column_mean)/column_max
	return feat
