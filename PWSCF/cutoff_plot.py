import numpy as np 
import matplotlib.pyplot as plt 

ry2ev = 13.6056980659

He = np.loadtxt('He_energies.txt')
Ne = np.loadtxt('Ne_energies.txt')
AREP = np.loadtxt('AREP_energies.txt')


He_cutoffs = He[:,0]
He_energies = He[:,1]

Ne_cutoffs = Ne[:,0]
Ne_energies = Ne[:,1]

AREP_cutoffs = AREP[:,0]
AREP_energies = AREP[:,1] 


plt.figure(1)
plt.title('ccECP He Core Bulk Si')
plt.plot(He_cutoffs, He_energies, marker='o', label='ccECP')
plt.ylabel('Energy (Ry/prim cell)')
plt.xlabel('Cutoff (Ry)')
plt.ylim(-409, -403)
plt.vlines(900,-409,-407.61950760, colors='green', linestyles='dashed')
plt.text(900,-407.61950760, '900 Ry')
plt.legend(loc='best')
plt.savefig("Cutoff_he_core.png")


plt.figure(2)
# plt.title('ccECP Ne Core Bulk Si')
plt.plot(Ne_cutoffs, Ne_energies, label='ccECP', marker='o')
# plt.plot(Ne_cutoffs, Ne_energies, label='ccECP')
plt.ylabel('Energy (Ry/prim cell)')
plt.xlabel('Cutoff (Ry)')
plt.legend(loc='best')
# plt.savefig("Cutoff_Ne_core.png")
# plt.figtext(0.5, 0.01, "Journal of Chemical Physics 149, 104108 (2018)", ha="center", fontsize=9)

# \n J.R. Trail and R.J. Needs, J. Chem. Phys. 122, 174109 (2005)

plt.figure(2)
plt.title('Ne Core Bulk Si ')
plt.plot(AREP_cutoffs, AREP_energies, label='DF AREP', marker='^')
# plt.plot(AREP_cutoffs, AREP_energies, label='AREP')
plt.ylabel('Energy (Ry/prim cell)')
plt.xlabel('Cutoff (Ry)')
plt.ylim(-15.53, -15.48)
plt.legend(loc='best')
plt.vlines(100,-15.50991544,-15.505, colors='green', linestyles='dashed')
plt.text(100,-15.505, '100 Ry')
plt.savefig("Cutoff_AREP.png")


plt.show()
He_diff=[]
Ne_diff=[]
AREP_diff=[]
for i in range(len(He_energies)-1):
	He_diff.append(abs(He_energies[i+1]-He_energies[i]))
	Ne_diff.append(abs(Ne_energies[i+1]-Ne_energies[i]))
	AREP_diff.append(abs(AREP_energies[i+1]-AREP_energies[i]))

# print(He_diff)

# print("Cutoff(ry)  Energy(Ry)  Difference (Ry)")

# for i in range(len(He_cutoffs)-1):
# 	print("%d\t%.5f\t%.5f" %(He_cutoffs[i], He_energies[i], He_diff[i]))


# print("Cutoff(eV)  Energy(eV)  Difference (eV)")

# for i in range(len(He_cutoffs)-1):
# 	print("%d\t%.5f\t%.5f" %(He_cutoffs[i]*ry2ev, He_energies[i]*ry2ev, He_diff[i]*ry2ev))

print("He core")
print("Cutoff(Ry)  Energy(Ry)  |Difference| (meV)")

for i in range(len(He_cutoffs)-1):
	print("%d\t%.5f\t%.5f" %(He_cutoffs[i], He_energies[i], He_diff[i]*ry2ev*1000))

print("Ne core")
print("Cutoff(Ry)  Energy(Ry)  |Difference| (meV)")

for i in range(len(Ne_cutoffs)-1):
	print("%d\t%.5f\t%.5f" %(Ne_cutoffs[i], Ne_energies[i], Ne_diff[i]*ry2ev*1000))

print("AREP")
print("Cutoff(Ry)  Energy(Ry)  |Difference| (meV)")

for i in range(len(AREP_cutoffs)-1):
	print("%d\t%.5f\t%.5f" %(AREP_cutoffs[i], AREP_energies[i], AREP_diff[i]*ry2ev*1000))


