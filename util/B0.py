from dipy.io.gradients import read_bvals_bvecs
import numpy as np
import sys



if __name__ == "__main__":
    hardi_fbval=sys.argv[1]
    hardi_fbvec=sys.argv[2]
    save_bval=sys.argv[3]
    bvals, bvecs = read_bvals_bvecs(hardi_fbval, hardi_fbvec)
    bval=np.round(bvals/100)*100
    np.savetxt(save_bval, bval, fmt='%d', delimiter=' ', newline=' ')
