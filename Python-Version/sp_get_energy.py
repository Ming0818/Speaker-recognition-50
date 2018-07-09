import numpy
def get_energy(arr):
    arr=numpy.abs(arr)
    arr=numpy.square(arr)
    energy = numpy.sum(arr)
    return energy






