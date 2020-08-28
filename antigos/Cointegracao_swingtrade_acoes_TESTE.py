
import pandas as pd
import statsmodels.api as sm
import statistics
import matplotlib.pyplot as plt
import statsmodels.tsa.stattools as ts

pathh = r'C:\Users\Joao\AppData\Roaming\MetaQuotes\Terminal\FB9A56D617EDDDFE29EE54EBEFFE96C1\MQL5\Files\\'
nomeArq = 'Robo_acoes__PERIOD_D1'
base = pd.read_csv(pathh + nomeArq + '.csv', sep=';')

a = 13
b = 33

y = base.iloc[-100:,a].values
x = base.iloc[-100:,b].values
yn = base.iloc[:,a].name
xn = base.iloc[:,b].name

x = sm.add_constant(x)
model = sm.OLS(y, x).fit()            
adf = ts.adfuller(model.resid, 1)
std = statistics.stdev(model.resid)

print(model.resid[-1])
print(yn, xn)

if adf[1] < .01:
    print('DF: Stationary')

if adf[0] < adf[4]['1%']:
    print('ADF: Stationary')

plt.plot(model.resid)
plt.ylabel('Residual')
plt.axhline(0, color='black',label='mean')
plt.axhline(2*std, color='red', linestyle='--', linewidth=2)
plt.axhline(-2*std, color='green', linestyle='--', linewidth=2)
plt.xlabel('')
plt.margins(0.1)
plt.show()