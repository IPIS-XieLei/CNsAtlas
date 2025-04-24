

## Lei Xie, Zhejiang University of Technology, e-mail:xielei@zjut.edu.cn


####################################################################################
#default input
Script_VTPTOVTK=/media/brainplan/DATA1/CNsAtlas2024/GithubForOpensource/util/VTK_opera_hem.py
Script_MERGE=/media/brainplan/DATA1/CNsAtlas2024/GithubForOpensource/util/VTK_opera_hem_o.py
Input_Slicer=/opt/apps/Slicer-4.10.2-linux-amd64/Slicer

#The inputs of your need 
Output_fold=/media/brainplan/DATA1/CNsAtlas2024/RGVP_tumor/zxy/Output_fold
AtlasToSubject_out=$Output_fold/AtlasToSubject_out

####################################################################################

wm_harden_transform.py -j 10 -i -t ${AtlasToSubject_out}/nonrigid_registered_subject_output/CNs_reg/output_tractography/itk_txform_CNs_reg.tfm ${AtlasToSubject_out}/Second_cluster_select/ ${AtlasToSubject_out}/transformed_cluster_output_nonrigid/ $Input_Slicer

mkdir ${AtlasToSubject_out}/Final_results

wm_harden_transform.py -j 10 -i -t ${AtlasToSubject_out}/registered_subject_output/CNs/output_tractography/itk_txform_CNs.tfm ${AtlasToSubject_out}/transformed_cluster_output_nonrigid/ ${AtlasToSubject_out}/Final_results/CNs_all_VTP/ $Input_Slicer

## VTP TO VTK
mkdir ${AtlasToSubject_out}/Final_results/CNs_all_VTK

/opt/apps/Slicer-4.10.2-linux-amd64/Slicer --no-main-window --python-script $Script_VTPTOVTK ${AtlasToSubject_out}/Final_results/CNs_all_VTP/ ${AtlasToSubject_out}/Final_results/CNs_all_VTK/ --python-code 'slicer.app.quit()' 	

## VTK MERGE
/opt/apps/Slicer-4.10.2-linux-amd64/Slicer --no-main-window --python-script $Script_MERGE ${AtlasToSubject_out}/Final_results/CNs_all_VTK ${AtlasToSubject_out}/Final_results --python-code 'slicer.app.quit()' 

	

