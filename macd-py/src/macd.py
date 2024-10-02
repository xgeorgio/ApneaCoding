import sys
import numpy as np
import matplotlib
import matplotlib.pyplot as plt

MISSING_VALUE = -1
MACD_LWIN = 26
MACD_SWIN = 12
MACD_GWIN = 9

def read_data_fixed( fname, fix_missing=True ):
    try:
        # import data values as-is from .csv file
        data=np.genfromtxt(fname, delimiter=",", skip_header=1, filling_values=MISSING_VALUE) 
        # select only the numeric column (skip timestamp)
        data=data[:,1]
            
        # correct missing values via averaging of neighbours
        if (fix_missing):
            for i in range(1,len(data)):
                if (data[i]==MISSING_VALUE):
                    #print("missing value at: ",i)
                    data[i]=(data[i-1]+data[i+1])/2
        
        # return data (vector)
        return data
    except:
        return None


def calc_ema_series( rdata, ema_sz=MACD_SWIN ):
    if (ema_sz<1) or (len(rdata)<ema_sz):
        return None
      
    edata=rdata.copy()
    sma=0
    for i in range(0,ema_sz):
        sma += rdata[i]
    sma=sma/ema_sz
    
    for i in range(0,ema_sz):
        edata[i]=sma
    
    w=2/(1+ema_sz)
    for i in range(ema_sz,len(rdata)):
        edata[i] = (rdata[i]-edata[i-1])*w + edata[i-1]
        
    return(edata)
    

def calc_macd_series( rdata, emaS_sz=MACD_SWIN, emaL_sz=MACD_LWIN ):
    if (emaS_sz<1) or (len(rdata)<emaS_sz):
        return None

    if (emaL_sz<emaS_sz) or (len(rdata)<emaL_sz):
        return None

    mdata = calc_ema_series(rdata, emaS_sz) - calc_ema_series(rdata, emaL_sz)
    
    return mdata


def calc_macd_sighist( mdata, emaG_sz=MACD_GWIN ):
    if (emaG_sz<1) or (len(mdata)<emaG_sz):
        return None

    mdata_sig = calc_ema_series(mdata, emaG_sz)
    mdata_hist = mdata - mdata_sig
    
    return mdata_sig, mdata_hist


def main( fname ):
    # import raw data series
    rdata = read_data_fixed(sys.argv[1])
    #print(rdata[0:10])
    
    # calculate the short-term EMA index (default=12)
    #sdata = calc_ema_series(rdata)
    #print(sdata[0:10])
    
    # calculate the long-term EMA index (default=26)
    #ldata = calc_ema_series(rdata)
    #print(ldata[0:10])
    
    # calculate the MACD index from short- and long-term EMA
    mdata = calc_macd_series(rdata)
    #print(mdata[0:10])
    
    # calculate the MACD signal and histogram from MACD index
    mdata_sig,mdata_hist = calc_macd_sighist(mdata,3)
    #print(mdata_sig[0:10])
    #print(mdata_hist[0:10])

    # stack together the calculated MACD series
    macd_data = np.vstack((mdata, mdata_sig, mdata_hist)).T
    print(macd_data)
    idx=range(0,len(rdata))
    
    # plot the raw data series versus MACD calculations
    fig, ax1 = plt.subplots()
    ax2 = ax1.twinx()       # separate raw from other series for secondary Y axis
    
    # sample combined plot
    off1=1000
    off2=off1+500
    ax1.plot(idx[off1:off2],rdata[off1:off2],label='S&P500',color='b')
    ax2.plot(idx[off1:off2],macd_data[off1:off2,0],label='MACD series',color='g')
    ax2.plot(idx[off1:off2],macd_data[off1:off2,1],label='MACD signal',color='c')
    ax2.plot(idx[off1:off2],macd_data[off1:off2,2],label='MACD histogram',color='r')
    plt.legend()
    plt.grid(True)
    plt.title('S&P500 vs. MACD')
    plt.show()

    
if __name__ == "__main__":
    if len(sys.argv)>1:
        main(sys.argv[1])
    else:
        print('Error: No input file')
    