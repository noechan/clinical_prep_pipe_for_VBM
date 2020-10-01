%% NORMALIZE TO MNI SPACE SPM LEGACY 
% Noelia Martinez-Molina & Aleksi Sihvonen, October 2020

clear all
%% Specify paths and list subjects
path='G:\Aphasia_project\VBM_v3\data_v3'; %Path for the preprocessing
names= dir(path);
names(ismember({names.name},{'.','..'}))=[];
ses='ses-001';
anat='anat';
prep_folder='spm_us_cfm_cleanup_NEW_TPM_med_reg_old_NORM'; % Write your preprocessing folder name here

tic
n=1;
%% Prepare inputs
for sub=1:size(names,1)
    % Exclude patients with no lesions: sub-24(ID143); sub-31 (ID154); sub-32(ID155); sub-33(ID157); sub-35(ID159)
    if ~strcmp(names(sub).name, 'sub-24' )  && ~strcmp(names(sub).name, 'sub-31' ) && ~strcmp(names(sub).name, 'sub-32')  && ~strcmp(names(sub).name, 'sub-33') && ~strcmp(names(sub).name, 'sub-35')
        sub_path=fullfile(path, names(sub).name, ses, anat, prep_folder);
        c1{n,1}=spm_select('List', fullfile(sub_path), '^c1.*\.nii$');
        c1_names{n,1}=fullfile(sub_path,c1{n,1});
        c2{n,1}=spm_select('List', fullfile(sub_path), '^c2.*\.nii$');
        c2_names{n,1}=fullfile(sub_path,c2{n,1});
        c3{n,1}=spm_select('List', fullfile(sub_path), '^c3.*\.nii$');
        c3_names{n,1}=fullfile(sub_path,c3{n,1});
        seg_sn{n,1}=spm_select('List', fullfile(sub_path), '^*seg_sn.*\.mat$');
        seg_sn{n,1}=fullfile(sub_path,seg_sn{n,1});
        n=n+1;
    end
end

%% Normalize to MNI
for i=1:size(c1_names,1)
    matlabbatch{i}.spm.tools.oldnorm.write.subj.matname ={seg_sn{i,1}};
    matlabbatch{i}.spm.tools.oldnorm.write.subj.resample = {
        c1_names{i,1}
        c2_names{i,1}
        c3_names{i,1}
        };
    matlabbatch{i}.spm.tools.oldnorm.write.roptions.preserve = 1; %Preserve amounts
    matlabbatch{i}.spm.tools.oldnorm.write.roptions.bb = [-78 -112 -70
        78 76 85];
    matlabbatch{i}.spm.tools.oldnorm.write.roptions.vox = [2 2 2]; %Voxel size
    matlabbatch{i}.spm.tools.oldnorm.write.roptions.interp = 1;
    matlabbatch{i}.spm.tools.oldnorm.write.roptions.wrap = [0 0 0];
    matlabbatch{i}.spm.tools.oldnorm.write.roptions.prefix = 'w';
    spm_jobman ('run', matlabbatch);
end
running_time=toc; 
