

## Lei Xie, Zhejiang University of Technology, e-mail:xielei@zjut.edu.cn


####################################################################################
#The inputs of your need 

MS_DTI=/media/brainplan/DATA1/CNsAtlas2024/RGVP_tumor/zxy/data.nii.gz
MS_Bval=/media/brainplan/DATA1/CNsAtlas2024/RGVP_tumor/zxy/bval
MS_Bvec=/media/brainplan/DATA1/CNsAtlas2024/RGVP_tumor/zxy/bvec


Output_fold=/media/brainplan/DATA1/CNsAtlas2024/RGVP_tumor/zxy/Output_fold
Track_out=$Output_fold/Track_out
MaskGatedFronMNI=$Output_fold/MaskGatedFronMNI
mkdir $Track_out
#######################################################################################

##
mrconvert $MS_DTI $Track_out/DWI.mif -fslgrad $MS_Bvec $MS_Bval -force
##
dwi2response tournier $Track_out/DWI.mif $Track_out/response.txt
##
dwi2fod csd $Track_out/DWI.mif $Track_out/response.txt $Track_out/wm_fod.mif
##
####sh2peaks wm_fod.mif peaks.nii.gz

## you can use iFOD1/iFOD2/SD_Stream

#tckgen -algorithm SD_Stream -angle 60 -maxlen 1500 -minlen 20 -step 0.3 -seed_image $MaskGatedFronMNI/CNII_Seedimage.nii.gz -nthreads 12  $Track_out/wm_fod.mif  -select 50000 -cutoff 0.05 $Track_out/SD_Stream_CII.tck -force 

#tckedit $Track_out/SD_Stream_CII.tck $Track_out/SD_Stream_CII.tck -mask $MaskGatedFronMNI/CNII_Seedimage.nii.gz -force
#tckconvert $Track_out/SD_Stream_CII.tck $Track_out/SD_Stream_CII.vtk -force

tckgen -algorithm SD_Stream -angle 60 -maxlen 1500 -minlen 20 -step 0.3 -seed_image $MaskGatedFronMNI/CNIII_Seedimage.nii.gz -nthreads 12  $Track_out/wm_fod.mif  -select 50000 -cutoff 0.03 $Track_out/SD_Stream_CIII.tck -force 

tckedit $Track_out/SD_Stream_CIII.tck $Track_out/SD_Stream_CIII.tck -mask $MaskGatedFronMNI/CNIII_Seedimage.nii.gz -force
tckconvert $Track_out/SD_Stream_CIII.tck $Track_out/SD_Stream_CIII.vtk -force

tckgen -algorithm SD_Stream -angle 60 -maxlen 1500 -minlen 20 -step 0.3 -seed_image $MaskGatedFronMNI/CNV_Seedimage.nii.gz -nthreads 12  $Track_out/wm_fod.mif  -select 50000 -cutoff 0.03 $Track_out/SD_Stream_CNV.tck -force 

tckedit $Track_out/SD_Stream_CNV.tck $Track_out/SD_Stream_CNV.tck -mask $MaskGatedFronMNI/CNV_Seedimage.nii.gz -force

tckconvert $Track_out/SD_Stream_CNV.tck $Track_out/SD_Stream_CNV.vtk -force

tckgen -algorithm SD_Stream -angle 60 -maxlen 1000 -minlen 10 -step 0.3 -seed_image $MaskGatedFronMNI/CNVIIVIII_Seedimage.nii.gz -nthreads 12  $Track_out/wm_fod.mif  -select 50000 -cutoff 0.03 $Track_out/SD_Stream_CNVIIVIII.tck -force 

tckedit $Track_out/SD_Stream_CNVIIVIII.tck $Track_out/SD_Stream_CNVIIVIII.tck -mask $MaskGatedFronMNI/CNVIIVIII_Seedimage.nii.gz -force

tckconvert $Track_out/SD_Stream_CNVIIVIII.tck $Track_out/SD_Stream_CNVIIVIII.vtk -force

 
