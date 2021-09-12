#!/usr/bin/python3

import numpy as np 
import random
import math
import sys

def distance_calc(p1, p2):
	d = math.sqrt(math.pow(p1[0] - p2[0], 2) +
		math.pow(p1[1] - p2[1], 2) +
		math.pow(p1[2] - p2[2], 2)* 1.0)

	return d

def main():
	original_stdout = sys.stdout
	L=50
	N=108
	sigma=3.4
	pos_arr = np.zeros((N,3))

	# Generate inital position
	pos_arr[0][:,] = random.uniform(-1.0*L/2, L/2), random.uniform(-1.0*L/2, L/2), random.uniform(-1.0*L/2, L/2)

	for i in range(1,N):
		pos_arr[i][:,] = random.uniform(-1.0*L/2, L/2), random.uniform(-1.0*L/2, L/2), random.uniform(-1.0*L/2, L/2)
		for j in range(0,i):
			d = distance_calc(pos_arr[j],pos_arr[i])
			# print("Calculating distance between {}th point and {}th point".format(i,j))
			# print("{}th coordinates: {} {} {}. {}th coordinates: {} {} {}. Distance: {}".format(i,pos_arr[i][0], pos_arr[i][1], pos_arr[i][2],j,pos_arr[j][0], pos_arr[j][1], pos_arr[j][2], d))
			while(d<sigma):
				# print("Old distance is: {}".format(d))
				# print("{} is less than {}! Recalculating coordinates...".format(d,sigma))
				pos_arr[i][:,] = random.uniform(-1.0*L/2, L/2), random.uniform(-1.0*L/2, L/2), random.uniform(-1.0*L/2, L/2)
				d = distance_calc(pos_arr[j],pos_arr[i])
				# print("New distance is: {}".format(d))
				# print("New Coordinates are: {} {} {}".format(pos_arr[i][0],pos_arr[i][1], pos_arr[i][2]))
				

	with open('data.{}'.format('Ar'), 'w') as file:
		sys.stdout = file
		print("# LAMMPS data file written by Jake Muff via python")
		print("{} atoms".format(N))
		print("{} atom types".format(1))
		print("{} {} xlo xhi".format(-1.0*(L/2), L/2))
		print("{} {} ylo yhi".format(-1.0*(L/2), L/2))
		print("{} {} zlo zhi".format(-1.0*(L/2), L/2))
		print("\n")
		print("Masses\n")
		print("{} {} # Ar\n".format(1,39.948))
		# print("\n")
		print("Atoms #atomic\n")
		print("{} {} {} {} {}".format(1,1,pos_arr[0][0],pos_arr[0][1], pos_arr[0][2]))
		for k in range(1,N):
			print("{} {} {} {} {}".format(k+1,1,pos_arr[k][0],pos_arr[k][1], pos_arr[k][2]))

		sys.stdout = original_stdout


	sys.exit('All done.')




if __name__ == '__main__':
    main()





	


