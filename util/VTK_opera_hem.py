import vtk
import sys
import os
import re


def VTP2VTK(vtp_path, vtk_path):

    vtp_read = vtk.vtkXMLPolyDataReader()
    vtp_read.SetFileName(vtp_path)
    vtp_read.Update()
    Pnum=vtp_read.GetOutput().GetNumberOfPoints()
    if Pnum == 0:
        return

    surface_filter = vtk.vtkDataSetSurfaceFilter()
    surface_filter.SetInputData(vtp_read.GetOutput())
    surface_filter.Update()
    vtkpolydata = surface_filter.GetOutput()

    vtkWriter = vtk.vtkPolyDataWriter()
    vtkWriter.SetInputData(vtkpolydata)

    vtkWriter.SetFileName(vtk_path)
    vtkWriter.SetFileTypeToBinary()
    vtkWriter.Update()
    vtkWriter.Write()






if __name__ == '__main__':

    # mrml_path = sys.argv[1]
    # vtp_path = sys.argv[2]
    # # output_path = sys.argv[3]
    # VTKMerge(mrml_path,vtp_path)
    # VTPConvert(mrml_path,vtp_path,output_path)
    # VTP = '/media/brainplan/DATA1/CNsAtlas2024/HCP_CreateAtlasData_OUT/CNsAtlas/cluster5000_5/VTP'
    # VTK = '/media/brainplan/DATA1/CNsAtlas2024/HCP_CreateAtlasData_OUT/CNsAtlas/cluster5000_5/VTK'
    VTP = sys.argv[1]
    VTK = sys.argv[2]
    # savepath = '/media/xl/D8EA63E9EA63C1FC/temp/2/'
    # ######################################################
    # dir = os.listdir(VTP)
    # for data in dir:
    #     # vtkdatapath = VTK+"/"+data
    #     # os.makedirs(vtkdatapath)
    #
    #     vtpdatapath = VTP + '/' + data + '/'+ 'Atlas/subinatlas'
    #     vtpdatapath1 = os.listdir(vtpdatapath)
    #     for vtpdata in vtpdatapath1:
    #         # num = vtpdata.split(".")[0]
    #         vtpdatafinal = vtpdatapath + '/'+'cluster_00090.vtp'
    #         vtkdatafinal = vtpdatapath + '/'+'cluster_00090.vtk'
    #         VTP2VTK(vtpdatafinal, vtkdatafinal)
    #
    #
    #         print(vtpdatafinal)
    #         print(vtkdatafinal)
    #
    # #######################################################
    # # ######################################################
    # dir = os.listdir(VTP)
    # for data in dir:
    #     # vtkdatapath = VTK+"/"+data
    #     # os.makedirs(vtkdatapath)
    #     vtpdatapath = '/media/brainplan/DATA1/CNsAtlas2024/HCP_CreateAtlasData_OUT/CNsAtlas/cluster2000/VTP'
    #     vtpdatapath1 = os.listdir(vtpdatapath)
    #     for vtpdata in vtpdatapath1:
    #         num = vtpdata.split(".")[0]
    #         vtpdatafinal = vtpdatapath + '/'+ str(num) +'.vtp'
    #         vtkdatafinal = VTK + '/' + str(num) + '.vtk'
    #         VTP2VTK(vtpdatafinal, vtkdatafinal)
    #
    #
    #         print(vtpdatafinal)
    #         print(vtkdatafinal)

    # #######################################################
    dir = os.listdir(VTP)
    for data in dir:
        num = data.split(".")[0]
        vtpdata=VTP+'/'+str(num)+'.vtp'
        vtkdata=VTK+'/'+str(num)+'.vtk'
        VTP2VTK(vtpdata, vtkdata)






