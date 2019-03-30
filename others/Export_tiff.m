% convert vgi to uint16 tif
% This code will:
% Find the VGI file
% Create a new folder in the current directory 
% Open the VGI file in a text editor and find the image size 
% the imagesize is given by nImage,mImage,lImage (size in .vgi file)
% Read the VOL file based on the given image size and output tif file to
% the new folder 'Recon_tif + sample name'
clear all
close all
clc

%% find the VOL size from the VGI file
fileList = dir('*.vgi');
file_name_vgi=fileList.name;
filetext  = fileread(file_name_vgi);
expr = '[^\n]*Size[^\n]*';
matches = regexp(filetext,expr,'match');
disp(matches{1})
expression = '\ ';
splitStr = regexp(matches,expression,'split');
nImage=str2num(cell2mat(splitStr{1,1}(3)));
mImage=str2num(cell2mat(splitStr{1,1}(4)));
lImage=str2num(cell2mat(splitStr{1,1}(5)));
%% create a new folder
Foldername = strcat('Recon_tif_',fileList.name(1:end-4));
mkdir (Foldername)
Foldername = strcat(Foldername,'\',fileList.name(1:end-4));
%%
tic

fileList = dir('*.vol');
file_name_vol=fileList.name;
fid = fopen(file_name_vol);
colormap(gray)
for i=1:lImage
    A = fread(fid, nImage*mImage*1, 'float');
    vol = reshape(A, [nImage, mImage, 1]);    
    vol2 = uint16(vol*100);
    NewFileName=sprintf('%s_convert_%04d.tif',Foldername,i);
    imwrite(vol2(:,:,1),NewFileName,'tif')
end
fclose(fid)
toc
%%