
# Dickey-Fuller (DF) <-> Augmented Dickey Fuller (ADF)
# +2 Compra X - Vende Y
# -2 Compra Y - Vende X

import pandas as pd
import statistics
import statsmodels.api as sm
import statsmodels.tsa.stattools as ts

pathh = r'C:\Users\Joao\AppData\Roaming\MetaQuotes\Terminal\FB9A56D617EDDDFE29EE54EBEFFE96C1\MQL5\Files\\'
#arr = (100, 110, 120, 130, 140, 150, 160, 170, 180, 190, 200, 210, 220, 230, 240, 250, 260, 270, 280, 290, 300)
arr = (250, 300)
comprar = []
vender = []

nomeArq = 'Robo_acoes__PERIOD_D1'

base = pd.read_csv(pathh + nomeArq + '.csv', sep=';')

def listarPares(y, x, period):
    print('Par: {} <-> {} ->> Periodo: {}' .format(str(y), str(x), str(period)))

for i in range(len(arr)):
    for j in range(base.shape[1]-1):
        y = base.iloc[arr[i]*-1:,j+1].values
        yName = base.iloc[:,j+1].name
        for k in range(base.shape[1]-2-j):
            x = base.iloc[arr[i]*-1:,k+j+2].values
            xName = base.iloc[:,k+j+2].name
            x = sm.add_constant(x)
            model = sm.OLS(y, x).fit()            
            adf = ts.adfuller(model.resid, 1)
            if adf[1] < .01 and adf[0] < adf[4]['1%']:
                desvio = statistics.stdev(model.resid)*2
                if model.resid[-1] > desvio:
                    listarPares(yName, xName, arr[i])
                else:
                    if model.resid[-1] < desvio*-1:
                        listarPares(yName, xName, arr[i])
                        
print('OK')