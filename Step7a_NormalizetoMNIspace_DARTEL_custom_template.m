%% DARTEL CUSTOM TEMPLATE NORMALIZE TO MNI SPACE
% Noelia Martinez-Molina & Aleksi Sihvonen, October 2020

clear all
%% Specify paths and list subjects
path='G:\Aphasia_project\VBM_v2\data_v2'; %Path for the preprocessing
names= dir(path);
names(ismember({names.name},{'.','..'}))=[];
ses='ses-001';
anat='anat';
prep_folder='spm_us_cfm_new_TPM_med_reg_DARTEL_custom_template'; % Write your preprocessing folder name here

%% Prepare inputs
tic
n=1;
for sub=1:size(names,1)
    % Exclude patients with no lesions: sub-24(ID143); sub-31 (ID154); sub-32(ID155); sub-33(ID157); sub-35(ID159)
    if ~strcmp(names(sub).name, 'sub-24' )  && ~strcmp(names(sub).name, 'sub-31' ) && ~strcmp(names(sub).name, 'sub-32')  && ~strcmp(names(sub).name, 'sub-33') && ~strcmp(names(sub).name, 'sub-35')
        sub_path=fullfile(path, names(sub).name, ses, anat, prep_folder);
        rc1{n,1}=spm_select('List', fullfile(sub_path), '^rc1.*\.nii$');
        rc1_names{n,1}=fullfile(sub_path,rc1{n,1});
        rc2{n,1}=spm_select('List', fullfile(sub_path), '^rc2.*\.nii$');
        rc2_names{n,1}=fullfile(sub_path,rc2{n,1});
        flowfield{n,1}=spm_select('List', fullfile(sub_path), '^u_rc1.*\.nii$');
        flowfield_names{n,1}=fullfile(sub_path,flowfield{n,1});
        n=n+1;
    end
    if sub==1 %Final DARTEL template is stored in the folder from the first subject
        DARTEL_Template=spm_select('List', fullfile(path, names(sub).name, ses, anat, prep_folder), '^Template_6.*\.nii$'); %final created template
        DARTEL_Template_name=fullfile(path, names(sub).name, ses, anat, prep_folder, DARTEL_Template);
    end
end

%% Normalize rpX_affine to MNI space
for i=1:size(rc1_names,1)
    matlabbatch{i}.spm.tools.dartel.mni_norm.template = {DARTEL_Template_name};
    matlabbatch{i}.spm.tools.dartel.mni_norm.data.subjs.flowfields ={flowfield_names{i,1}};
    matlabbatch{i}.spm.tools.dartel.mni_norm.data.subjs.images = {
        rc1_names(i,1)
        rc2_names(i,1)
        };
    matlabbatch{i}.spm.tools.dartel.mni_norm.vox = [2 2 2]; %Voxel size
    matlabbatch{i}.spm.tools.dartel.mni_norm.bb = [NaN NaN NaN
        NaN NaN NaN];
    matlabbatch{i}.spm.tools.dartel.mni_norm.preserve = 1; %Preserve Amounts (modulated, grey/white matter volume)
    matlabbatch{i}.spm.tools.dartel.mni_norm.fwhm = [0 0 0]; %Smoothing
    spm_jobman ('run', matlabbatch);
end
running_time=toc;

