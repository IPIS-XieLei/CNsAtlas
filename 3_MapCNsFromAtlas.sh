

## Lei Xie, Zhejiang University of Technology, e-mail:xielei@zjut.edu.cn


####################################################################################
#default input
First_cluster=(01912
01944
02014
02083
02156
02167
02250
02253
02260
02274
02275
02304
02510
02516
02565
02635
02638
02874
00532
00547
02499
02715
02739
02776
02893
02991
03048
03192
03320
03414
03613
03726
03752
03915
03924
03958
04020
04155
04402
04518
04720
04740
04866
04982
00907
01166
01182
01247
01295
05414
05424
05428
05433
05436
05445
05473
05495
05514
05519
05543
05547
05554
05576
05580
05616
05623
05643
05649
05675
05677
05736
05739
05760
05837
05868
05921
05921
05926
05971
00859
00878
01047
01062
01175
01188
01213
01252
01282
01300
01302
01303
05435
05469
05499
05542
05553
05585
05655
05661
05666
05696
05702
05711
05743
05822
05990)
CNs_cluster=(00127
00128
00129
00130
00139
00141
00143
00146
00147
00148
00150
00155
00158
00163
00065
00091
00103
00105
00280
00294
00010
00052
00055
00082
00173
00177
00183
00188
00191
00195
00202
00210
00214
00220
00231
00238
00252
00253
00098
00100
00113
00114
00186
00212
00223
00236
00254
00257)
Input_atlas_First=/media/brainplan/DATA1/CNsAtlas2024/GithubForOpensource/Atlas/Atlas_First/initial_clusters
Input_atlas_Second=/media/brainplan/DATA1/CNsAtlas2024/GithubForOpensource/Atlas/Atlas_Second/initial_clusters
Input_Slicer=/opt/apps/Slicer-4.10.2-linux-amd64/Slicer
Script_VTPTOVTK=/media/brainplan/DATA1/CNsAtlas2024/GithubForOpensource/util/VTK_opera_hem.py
Script_MERGE=/media/brainplan/DATA1/CNsAtlas2024/GithubForOpensource/util/VTK_opera_hem_o.py

#The inputs of your need 
Output_fold=/media/brainplan/DATA1/CNsAtlas2024/RGVP_tumor/zxy/Output_fold
AtlasToSubject_out=$Output_fold/AtlasToSubject_out
mkdir $AtlasToSubject_out
Track_out=$Output_fold/Track_out
tract=$Track_out/CNs


wm_register_to_atlas_new.py -l 20 -mode affine ${tract}/CNs.vtk $Input_atlas_First/atlas.vtp $AtlasToSubject_out/registered_subject_output/

wm_register_to_atlas_new.py -l 20 -mode nonrigid $AtlasToSubject_out/registered_subject_output/CNs/output_tractography/CNs_reg.vtk $Input_atlas_First/atlas.vtp ${AtlasToSubject_out}/nonrigid_registered_subject_output/

wm_cluster_from_atlas.py -j 10 -l 20 ${AtlasToSubject_out}/nonrigid_registered_subject_output/CNs_reg/output_tractography/CNs_reg_reg.vtk $Input_atlas_First/ ${AtlasToSubject_out}/subject_cluster_output/  

VTPFile=${AtlasToSubject_out}/frist_cluster_VTP_select
VTKFile=${AtlasToSubject_out}/First_VTK
OneVTKFile=${AtlasToSubject_out}/OneVTK

mkdir $VTPFile
mkdir $VTKFile
mkdir $OneVTKFile

## MOVE first cluster
for file in ${First_cluster[@]};
do
	
	cp ${AtlasToSubject_out}/subject_cluster_output/CNs_reg_reg/cluster_${file}.vtp ${VTPFile}/cluster_${file}.vtp

	echo "****************************************************"
	echo "data ${file} finish finish finish "

done

## VTP TO VTK
/opt/apps/Slicer-4.10.2-linux-amd64/Slicer --no-main-window --python-script $Script_VTPTOVTK ${VTPFile} ${VTKFile} --python-code 'slicer.app.quit()' 	

## VTK MERGE
/opt/apps/Slicer-4.10.2-linux-amd64/Slicer --no-main-window --python-script $Script_MERGE ${VTKFile} ${OneVTKFile} --python-code 'slicer.app.quit()' 

echo "finished"

## second cluster
wm_cluster_from_atlas.py -j 10 -l 20 ${AtlasToSubject_out}/OneVTK/First_VTK.vtk $Input_atlas_Second/ ${AtlasToSubject_out}/subject_cluster_output_Second/ 


wm_cluster_remove_outliers.py ${AtlasToSubject_out}/subject_cluster_output_Second/First_VTK $Input_atlas_Second/ ${AtlasToSubject_out}/subject_cluster_outlier_removed_output/

## move ON
mkdir ${AtlasToSubject_out}/Second_cluster_select

for file in ${CNs_cluster[@]};
	do
		
		name=${file%%.*}
		
		echo "****************************************************"
		
		cp ${AtlasToSubject_out}/subject_cluster_outlier_removed_output/First_VTK_outlier_removed/cluster_${name}.vtp ${AtlasToSubject_out}/Second_cluster_select/cluster_${name}.vtp

		echo "****************************************************"

	done


