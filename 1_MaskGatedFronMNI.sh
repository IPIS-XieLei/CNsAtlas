

## Lei Xie, Zhejiang University of Technology, e-mail:xielei@zjut.edu.cn


####################################################################################
#default input
MIN_T1=/media/brainplan/DATA1/CNsAtlas2024/CNs_MNI/MNI152_T1_1mm.nii.gz
MNI_CNII=/media/brainplan/DATA1/CNsAtlas2024/CNs_MNI/MNI152_CNII_Mask.nii.gz
MNI_CNIII=/media/brainplan/DATA1/CNsAtlas2024/CNs_MNI/MNI152_CNIII_Mask.nii.gz
MNI_CNV=/media/brainplan/DATA1/CNsAtlas2024/CNs_MNI/MNI152_CNV_Mask.nii.gz
MNI_CNVIIVIII=/media/brainplan/DATA1/CNsAtlas2024/CNs_MNI/MNI152_CNVIIVIII_Mask.nii.gz
brainstem_ROI=/media/brainplan/DATA1/CNsAtlas2024/CNs_MNI/brainstem_ROI.nii.gz

#The inputs of your need 
T1=/media/brainplan/DATA1/CNsAtlas2024/RGVP_tumor/zxy/T12data.nii.gz
Output_fold=/media/brainplan/DATA1/CNsAtlas2024/RGVP_tumor/zxy/Output_fold
mkdir $Output_fold
#######################################################################################

MaskGatedFronMNI=$Output_fold/MaskGatedFronMNI
mkdir $MaskGatedFronMNI

#registrate MNI_CNs to individual T1 as ROI
flirt -in $MIN_T1 -ref $T1 -out $MaskGatedFronMNI/MNI2HCP_T1.nii.gz -omat $MaskGatedFronMNI/MNI2HCP.mat
rm -rf $MaskGatedFronMNI/MNI2HCP_T1.nii.gz
flirt -in $MNI_CNII -ref $T1 -out $MaskGatedFronMNI/CNII_ROI.nii.gz -init $MaskGatedFronMNI/MNI2HCP.mat -applyxfm
flirt -in $MNI_CNIII -ref $T1 -out $MaskGatedFronMNI/CNIII_ROI.nii.gz -init $MaskGatedFronMNI/MNI2HCP.mat -applyxfm
flirt -in $MNI_CNV -ref $T1 -out $MaskGatedFronMNI/CNV_ROI.nii.gz -init $MaskGatedFronMNI/MNI2HCP.mat -applyxfm
flirt -in $MNI_CNVIIVIII -ref $T1 -out $MaskGatedFronMNI/CNVIIVIII_ROI.nii.gz -init $MaskGatedFronMNI/MNI2HCP.mat -applyxfm
flirt -in $brainstem_ROI -ref $T1 -out $MaskGatedFronMNI/brainstem_ROI.nii.gz -init $MaskGatedFronMNI/MNI2HCP.mat -applyxfm

#CNII_seed
mrcalc $MaskGatedFronMNI/CNII_ROI.nii.gz 0.1 -ge $MaskGatedFronMNI/CNII_Seedimage.nii.gz -datatype uint8 -force

#CNIII_seed
mrcalc $MaskGatedFronMNI/CNIII_ROI.nii.gz $MaskGatedFronMNI/brainstem_ROI.nii.gz -add $MaskGatedFronMNI/CNIII_Seedimage.nii.gz -force
mrcalc $MaskGatedFronMNI/CNIII_Seedimage.nii.gz 0.1 -ge $MaskGatedFronMNI/CNIII_Seedimage.nii.gz -datatype uint8 -force

#CNV_seed
mrcalc $MaskGatedFronMNI/CNV_ROI.nii.gz $MaskGatedFronMNI/brainstem_ROI.nii.gz -add $MaskGatedFronMNI/CNV_Seedimage.nii.gz -force
mrcalc $MaskGatedFronMNI/CNV_Seedimage.nii.gz 0.1 -ge $MaskGatedFronMNI/CNV_Seedimage.nii.gz -datatype uint8 -force

#CNVIIVIII_seed
mrcalc $MaskGatedFronMNI/CNVIIVIII_ROI.nii.gz $MaskGatedFronMNI/brainstem_ROI.nii.gz -add $MaskGatedFronMNI/CNVIIVIII_Seedimage.nii.gz -force
mrcalc $MaskGatedFronMNI/CNVIIVIII_Seedimage.nii.gz 0.1 -ge $MaskGatedFronMNI/CNVIIVIII_Seedimage.nii.gz -datatype uint8 -force



