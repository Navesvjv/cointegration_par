# Dickey-Fuller (DF) <-> Augmented Dickey Fuller (ADF)
# +2 Compra X - Vende Y
# -2 Compra Y - Vende X
import pandas as pd
import statistics
import statsmodels.api as sm
from scipy.stats import zscore as zs
import statsmodels.tsa.stattools as ts

pathh = r'C:\Users\Joao\AppData\Roaming\MetaQuotes\Terminal\FB9A56D617EDDDFE29EE54EBEFFE96C1\MQL5\Files\daytrade_win\\'
arr = (100, 150, 200, 250, 300, 350, 400, 450, 500, 550, 600, 650, 700, 750, 800, 850, 900, 950, 1000)
pares = pd.DataFrame(columns=('Comprar', 'Vender', 'Periodo', 'Std_atual'))
nomeArq = 'Robo_win_acoes_PERIOD_M10_close_500Candles'

_df, _adf = .1, '10%'

base = pd.read_csv(pathh + nomeArq + '.csv', sep=';')
base.dropna(axis=1, inplace=True)

for i in range(len(arr)):
    y = base.iloc[arr[i]*-1:,1].values
    y = zs(y)
    yName = base.iloc[:,1].name
    for k in range(base.shape[1]-2):
        x = base.iloc[arr[i]*-1:,k+1].values
        x = zs(x)
        xName = base.iloc[:,k+2].name
        x = sm.add_constant(x)
        model = sm.OLS(y, x).fit()            
        adf = ts.adfuller(model.resid, 1)
        if adf[1] < _df and adf[0] < adf[4][_adf]:
            std = statistics.stdev(model.resid)
            desvio = std*2
            stdAtual = model.resid[-1] / std
            if model.resid[-1] > desvio:
                pares = pares.append({'Comprar': xName, 'Vender': yName, 
                                      'Periodo': arr[i], 'Std_atual': stdAtual}, ignore_index=True)
            else:
                if model.resid[-1] < desvio*-1:
                    pares = pares.append({'Comprar': yName, 'Vender': xName, 
                                          'Periodo': arr[i], 'Std_atual': stdAtual}, ignore_index=True)

pares.to_csv(pathh + nomeArq + '_Operar.csv', sep=';', index=False, encoding='utf-8' )                        
print(pares)
print('OK')