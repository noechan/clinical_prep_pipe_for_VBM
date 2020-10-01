%% COPY ORIGINAL DATA TO PREPROCESSING FOLDER
% Noelia Martinez-Molina & Aleksi Sihvonen, October 2020

clear all
%% Specify paths
source_path='G:\Aphasia_project\BIDS\lasa\Nifti\'; %Path with original data
dest_path='G:\Aphasia_project\VBM_v3\data_v3'; %Path for the preprocessing
aux= ls(source_path);
names=deblank(aux(11:60,:));
ses='ses-001';
%% Copy files
for sub=2:size(names,1)
    sub_path1=fullfile(source_path, names(sub,:), ses,'anat');
    [roT1,~]=spm_select('List',sub_path1, '^*roT1w.*\.nii$'); %Manually reoriented to AC T1w
    [roLESION,~]=spm_select('List',sub_path1, '^*roLESION.*\.nii$'); %Manually reoriented to AC Lesions
    cd(dest_path), mkdir(fullfile(names(sub,:), ses,'anat'))
    sub_path2=fullfile(dest_path, names(sub,:), ses,'anat');
    copyfile(fullfile(sub_path1,roT1), sub_path2)
    copyfile(fullfile(sub_path1,roLESION), sub_path2)
end
