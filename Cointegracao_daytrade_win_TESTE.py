
import pandas as pd
import statsmodels.api as sm
import statistics
import matplotlib.pyplot as plt
from scipy.stats import zscore as zs
import statsmodels.tsa.stattools as ts

pathh = r'C:\Users\Joao\AppData\Roaming\MetaQuotes\Terminal\FB9A56D617EDDDFE29EE54EBEFFE96C1\MQL5\Files\daytrade_win\\'
nomeArq = 'Robo_win_acoes_PERIOD_M10_close_500Candles'
base = pd.read_csv(pathh + nomeArq + '.csv', sep=';')

atvA = 'CMIG4'
atvB = 'WINV20'

period = 350
_df, _adf = .1, '10%'
desvio = 2

yi, xi = 0, 0
for i in range(base.shape[1]-1):
    yn = base.iloc[:,i].name
    xn = base.iloc[:,i].name
    if yn == atvA:
        yi = i
    if xn == atvB:
        xi = i
        
period = period*-1
y = base.iloc[period:,yi].values
y = zs(y)
x = base.iloc[period:,xi].values
x = zs(x)
ynn = base.iloc[:,yi].name
xnn = base.iloc[:,xi].name

x = sm.add_constant(x)
model = sm.OLS(y, x).fit()            
adf = ts.adfuller(model.resid, 1)
std = statistics.stdev(model.resid)

if model.resid[-1] > desvio*std or model.resid[-1] < desvio*std*-1:
    print('Pode Operar!')
print(ynn, xnn)

if adf[1] < _df:
    print('DF: Stationary')

if adf[0] < adf[4][_adf]:
    print('ADF: Stationary')

print('df: {} / adf: {}' .format(_df, _adf))

plt.plot(model.resid)
plt.ylabel('Residual')
plt.axhline(0, color='black',label='mean')
plt.axhline(desvio*std, color='red', linestyle='--', linewidth=2)
plt.axhline(-desvio*std, color='green', linestyle='--', linewidth=2)
plt.xlabel('')
plt.margins(0.1)
plt.show()