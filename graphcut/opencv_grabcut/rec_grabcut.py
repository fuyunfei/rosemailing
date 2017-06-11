import numpy as np
import cv2
from matplotlib import pyplot as plt
img = cv2.imread('../../pic/b.jpg') 

mask = np.zeros(img.shape[:2],np.uint8)

bgdModel = np.zeros((1,65),np.float64)
fgdModel = np.zeros((1,65),np.float64)

rect = (0,0,200,200)
cv2.grabCut(img,mask,rect,bgdModel,fgdModel,5,cv2.GC_INIT_WITH_RECT)

mask2 = np.where((mask==2)|(mask==0),0,1).astype('uint8')
img = img*mask2[:,:,np.newaxis]

plt.imshow(img),plt.colorbar(),plt.show()


newmask = cv2.imread('mask1.jpg',0)

mask[newmask == 0] = 0
mask[newmask == 255] = 1

mask, bgdModel, fgdModel = cv2.grabCut(img,mask,None,bgdModel,fgdModel,5,cv2.GC_INIT_WITH_MASK)
mask = np.where((mask==2)|(mask==0),0,1).astype('uint8')

img = img*mask[:,:,np.newaxis]
plt.imshow(img),plt.colorbar(),plt.show()



#cv2.grabCut(img,mask,rect,bgdModel,fgdModel,15,cv2.GC_INIT_WITH_RECT)
#mask2 = np.where((mask==2)|(mask==0),0,1).astype('uint8')
#plt.imshow(mask2)
#plt.show()
#img = img*mask2[:,:,np.newaxis]
#plt.imshow(img),plt.colorbar(),plt.show()
