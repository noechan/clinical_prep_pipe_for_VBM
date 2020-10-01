%% DARTEL INITIAL IMPORT
% Noelia Martinez-Molina & Aleksi Sihvonen, October 2020

clear all
%% Specify paths and list subjects
path='G:\Aphasia_project\VBM_v3\data_v3'; %Path for the preprocessing
names= dir(path);
names(ismember({names.name},{'.','..'}))=[];
ses='ses-001';
anat='anat';
prep_folder='spm_us_cfm_cleanup_new_TPM_med_reg_DARTEL_custom';  % Write your preprocessing folder name here

tic
%% Initial import
for sub=1:size(names,1)
    % Exclude patients with no lesions: sub-24(ID143); sub-31 (ID154); sub-32(ID155); sub-33(ID157); sub-35(ID159)
    if ~strcmp(names(sub).name, 'sub-24' )  && ~strcmp(names(sub).name, 'sub-31' ) && ~strcmp(names(sub).name, 'sub-32')  && ~strcmp(names(sub).name, 'sub-33') && ~strcmp(names(sub).name, 'sub-35')
        sub_path=fullfile(path, names(sub).name, ses, anat, prep_folder);
        sn=spm_select('List', fullfile(sub_path), '^*_seg_sn.*\.mat$'); %segmentation parameters from Old Seg
        matlabbatch{1}.spm.tools.dartel.initial.matnames =cellstr(fullfile(sub_path,sn));
        matlabbatch{1}.spm.tools.dartel.initial.odir =cellstr(sub_path);
        matlabbatch{1}.spm.tools.dartel.initial.bb = [NaN NaN NaN
            NaN NaN NaN];
        matlabbatch{1}.spm.tools.dartel.initial.vox = 1.5;
        matlabbatch{1}.spm.tools.dartel.initial.image = 0;
        matlabbatch{1}.spm.tools.dartel.initial.GM = 1;
        matlabbatch{1}.spm.tools.dartel.initial.WM = 1;
        matlabbatch{1}.spm.tools.dartel.initial.CSF = 0;
         spm_jobman ('run', matlabbatch);
        clear matlabbatch
    end
end
running_time=toc;