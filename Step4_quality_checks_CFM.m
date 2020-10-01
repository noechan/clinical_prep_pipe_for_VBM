%%  SEGMENTATIO QUALITY CHECK USING CAT12 TOOLS
% Noelia Martinez-Molina & Aleksi Sihvonen, October 2020
clear all
%% Specify paths and list subjects
input_path='G:\Aphasia_project\VBM_v3\data_v3'; %Path for the preprocessing
output_path='G:\Aphasia_project\VBM_v3\quality_checks'; %Path for the quality checks
names= dir(input_path);
names(ismember({names.name},{'.','..'}))=[];
ses='ses-001';
anat='anat';
prep_folder='spm_us_cfm_new_BET_TPM_cleanup_med_reg_DARTEL_custom'; % Write your preprocessing folder name here
%% Display one slice per tissue class
for sub=1:size(names,1)
      % Exclude patients with no lesions: sub-24(ID143); sub-31 (ID154); sub-32(ID155); sub-33(ID157); sub-35(ID159)
    if ~strcmp(names(sub).name, 'sub-24' )  && ~strcmp(names(sub).name, 'sub-31' ) && ~strcmp(names(sub).name, 'sub-32')  && ~strcmp(names(sub).name, 'sub-33') && ~strcmp(names(sub).name, 'sub-35')
        sub_path1=fullfile(input_path, names(sub).name, ses, anat, prep_folder);
        c1=spm_select('List', fullfile(sub_path1), '^c1sub.*\.nii$'); %grey matter
        c2=spm_select('List', fullfile(sub_path1), '^c2sub.*\.nii$'); %white matter
        c3=spm_select('List', fullfile(sub_path1), '^c3sub.*\.nii$'); %csf
        matlabbatch{1}.spm.tools.cat.tools.showslice.data_vol = {
            fullfile(sub_path1,c1)
            fullfile(sub_path1,c2)
            fullfile(sub_path1,c3)
            };
        matlabbatch{1}.spm.tools.cat.tools.showslice.scale = 0;
        matlabbatch{1}.spm.tools.cat.tools.showslice.orient = 3;
        matlabbatch{1}.spm.tools.cat.tools.showslice.slice = 0;
        spm_jobman ('run', matlabbatch);
        clear matlabbatch
    end
    cd (output_path), mkdir(prep_folder), cd(prep_folder)
    savefig(horzcat('QC_',names(sub).name,'_', ses,'_seg')) 
end
