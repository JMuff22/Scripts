import matplotlib.pyplot as plt 
import numpy 


out_300=[1340,450,430,450]
out_300_err = [20,20,10,10]

out_400=[980,460,520,460]
out_400_err = [20,20,50,20]

out_500=[890,540,520,530]
out_500_err = [30,30,30,30]

out_600=[850,610,570,570]
out_600_err = [30,40,30,40]

out_700=[880,530,700,740]
out_700_err = [50,30,100,30]

out_800=[810,570,570,540]
out_800_err = [30,50,30,40]

out_900=[870,520,560,560]
out_900_err = [40,20,30,30]

out_1000=[870,590,800,560]
out_1000_err = [80,20,100,30]

out_1100=[820,640,580,510]
out_1100_err = [30,70,50,20]

out_1200=[800,600,710,550]
out_1200_err = [30,100,30,40]

out_1300=[790,510,700,580]
out_1300_err = [30,20,200,40]


x = [1,2,3,4]

plt.ylabel('Variance')
plt.xlabel('VMC opt cycle #')

# plt.errorbar(x, out_300, yerr=out_300_err,label='300Ry')
# plt.errorbar(x, out_400, yerr=out_400_err,label='400Ry')
# plt.errorbar(x, out_500, yerr=out_500_err,label='500Ry')
# plt.errorbar(x, out_600, yerr=out_600_err,label='600Ry')
# plt.errorbar(x, out_700, yerr=out_700_err,label='700Ry')
# plt.errorbar(x, out_800, yerr=out_800_err,label='800Ry')
# plt.errorbar(x, out_900, yerr=out_900_err,label='900Ry')
# plt.errorbar(x, out_1000, yerr=out_1000_err,label='1000Ry')
# plt.errorbar(x, out_1100, yerr=out_1100_err,label='1100Ry')
# plt.errorbar(x, out_1200, yerr=out_1200_err,label='1200Ry')
# plt.errorbar(x, out_1300, yerr=out_1300_err,label='1300Ry')


# plt.plot(x, out_300, yerr=out_300_err,label='300Ry')
# plt.plot(x, out_400, yerr=out_400_err,label='400Ry')
# plt.plot(x, out_500, yerr=out_500_err,label='500Ry')
# plt.plot(x, out_600, yerr=out_600_err,label='600Ry')
# plt.plot(x, out_700, yerr=out_700_err,label='700Ry')
# plt.plot(x, out_800, yerr=out_800_err,label='800Ry')
# plt.plot(x, out_900, yerr=out_900_err,label='900Ry')
plt.plot(x, out_1000,label='1000Ry', marker='o')
plt.plot(x, out_1100,label='1100Ry', marker='o')
plt.plot(x, out_1200,label='1200Ry', marker='o')
plt.plot(x, out_1300,label='1300Ry', marker='o')

plt.legend(loc='best')

plt.show()