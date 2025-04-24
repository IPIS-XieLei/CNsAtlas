

## Lei Xie, Zhejiang University of Technology, e-mail:xielei@zjut.edu.cn


####################################################################################
#default input

Slicer=/opt/apps/Slicer-4.10.2-linux-amd64/
DWIConvert=/opt/apps/Slicer-4.10.2-linux-amd64/lib/Slicer-4.10
UKF=/usr/local/ukf_build_run/UKFTractography-build/UKFTractography/bin/UKFTractography
B0_PY=/media/brainplan/DATA1/CNsAtlas2024/GithubForOpensource/util/B0.py
bval0=/media/brainplan/DATA1/CNsAtlas2024/GithubForOpensource/util/bval0
bvec0=/media/brainplan/DATA1/CNsAtlas2024/GithubForOpensource/util/bvec0

#The inputs of your need 
MS_DTI=/media/brainplan/DATA1/CNsAtlas2024/RGVP_tumor/zxy/data.nii.gz
MS_Bval=/media/brainplan/DATA1/CNsAtlas2024/RGVP_tumor/zxy/bval
MS_Bvec=/media/brainplan/DATA1/CNsAtlas2024/RGVP_tumor/zxy/bvec

Output_fold=/media/brainplan/DATA1/CNsAtlas2024/RGVP_tumor/zxy/Output_fold
Track_out=$Output_fold/Track_out
mkdir $Track_out
MaskGatedFronMNI=$Output_fold/MaskGatedFronMNI
####################################################################################

SS_DTI=$Track_out/data.nii.gz
SS_Bvec=$Track_out/bvecs
SS_Bval=$Track_out/bvals

#1. extract B=1000 from HCP data
dwiextract $MS_DTI $SS_DTI -fslgrad $MS_Bvec $MS_Bval -shells 0,1000 -singleshell -export_grad_fsl $SS_Bvec $Track_out/bval_5 -force
python $B0_PY $Track_out/bval_5 $SS_Bvec $SS_Bval
rm -rf $Track_out/bval_5


#3. convert nifti data to nrrd including dMRI, UKF_mask, and UKF_label
CNII_SEED_nrrd=$Track_out/CNII_Seedimage.nrrd
CNIII_SEED_nrrd=$Track_out/CNIII_Seedimage.nrrd
CNV_SEED_nrrd=$Track_out/CNV_Seedimage.nrrd
CNVIIVIII_SEED_nrrd=$Track_out/CNVIIVIII_Seedimage.nrrd
CN_MASK_nrrd=$Track_out/CN_MASK.nrrd

cd $DWIConvert
#CN_seed_TO NRRD
$DWIConvert/DWIConvert --inputBVectors $bvec0 --inputBValues $bval0 -o $CNII_SEED_nrrd --conversionMode FSLToNrrd --inputVolume $MaskGatedFronMNI/CNII_Seedimage.nii.gz --allowLossyConversion
$DWIConvert/DWIConvert --inputBVectors $bvec0 --inputBValues $bval0 -o $CNIII_SEED_nrrd --conversionMode FSLToNrrd --inputVolume $MaskGatedFronMNI/CNIII_Seedimage.nii.gz --allowLossyConversion
$DWIConvert/DWIConvert --inputBVectors $bvec0 --inputBValues $bval0 -o $CNV_SEED_nrrd --conversionMode FSLToNrrd --inputVolume $MaskGatedFronMNI/CNV_Seedimage.nii.gz --allowLossyConversion
$DWIConvert/DWIConvert --inputBVectors $bvec0 --inputBValues $bval0 -o $CNVIIVIII_SEED_nrrd --conversionMode FSLToNrrd --inputVolume $MaskGatedFronMNI/CNVIIVIII_Seedimage.nii.gz --allowLossyConversion

#CN_DATA_TO NRRD
DTI_NRRD=$Track_out/data.nrrd
$DWIConvert/DWIConvert --inputBVectors $SS_Bvec --inputBValues $SS_Bval -o $DTI_NRRD --conversionMode FSLToNrrd --inputVolume $SS_DTI --allowLossyConversion

#4. UKF Tractography
# Maybe you need change para for clinical data
$UKF --Ql 50 --Qm 0.001 --numTensor 2 --numThreads 10 --stoppingFA 0.01 --seedingThreshold 0.02 --seedsPerVoxel 6 --tracts $Track_out/ukf_CNII.vtk --maskFile $CNII_SEED_nrrd --labels 32767 --seedsFile $CNII_SEED_nrrd --dwiFile $DTI_NRRD
$UKF --Ql 150 --Qm 0.001 --numTensor 2 --numThreads 10 --stoppingFA 0.01 --seedingThreshold 0.01 --seedsPerVoxel 6 --tracts $Track_out/ukf_CNIII.vtk --maskFile $CNIII_SEED_nrrd --labels 32767 --seedsFile $CNIII_SEED_nrrd --dwiFile $DTI_NRRD
$UKF --Ql 300 --Qm 0.001 --numTensor 2 --numThreads 10 --stoppingFA 0.05 --seedingThreshold 0.06 --stoppingThreshold 0.06 --seedsPerVoxel 6 --tracts $Track_out/ukf_CNV.vtk --maskFile $CNV_SEED_nrrd --labels 32767 --seedsFile $CNV_SEED_nrrd --dwiFile $DTI_NRRD
$UKF --Ql 50 --Qm 0.001 --numTensor 2 --numThreads 10 --stoppingFA 0.05 --seedingThreshold 0.02 --seedsPerVoxel 6 --tracts $Track_out/ukf_CNVIIVIII.vtk --maskFile $CNVIIVIII_SEED_nrrd --labels 32767 --seedsFile $CNVIIVIII_SEED_nrrd --dwiFile $DTI_NRRD

mkdir $Track_out/CNs
tckconvert $Track_out/ukf_CNII.vtk $Track_out/CNs/ukf_CNII.tck -force
tckedit $Track_out/CNs/ukf_CNII.tck $Track_out/CNs/ukf_CNII.tck -minlength 20 -force

tckconvert $Track_out/ukf_CNIII.vtk $Track_out/CNs/ukf_CNIII.tck -force
tckedit $Track_out/CNs/ukf_CNIII.tck $Track_out/CNs/ukf_CNIII.tck -minlength 20 -force

tckconvert $Track_out/ukf_CNV.vtk $Track_out/CNs/ukf_CNV.tck -force
tckedit $Track_out/CNs/ukf_CNV.tck $Track_out/CNs/ukf_CNV.tck -minlength 20 -force

tckconvert $Track_out/ukf_CNVIIVIII.vtk $Track_out/CNs/ukf_CNVIIVIII.tck -force
tckedit $Track_out/CNs/ukf_CNVIIVIII.tck $Track_out/CNs/ukf_CNVIIVIII.tck -minlength 20 -force

cd $Track_out/CNs
tckedit *.tck CNs.tck -force
tckconvert $Track_out/CNs/CNs.tck $Track_out/CNs/CNs.vtk -force



