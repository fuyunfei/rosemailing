import matplotlib.pyplot as plt
import matplotlib.animation as animation
import numpy as np
import scipy.io as sio
from matplotlib.path import Path
import matplotlib.patches as patches
from scipy.interpolate import spline

a=sio.loadmat('hair.mat')
b=a['hair'][0]
for i in range(1,1333):
    x=b[i][:,1]
    y = b[i][:,0]
    x_smooth=np.linspace(x.min(),x.max(),20)
    y_smooth=spline(x,y,x_smooth)
    plt.plot(x,y)
plt.gca().invert_yaxis()
plt.axis('equal')
plt.show()
