%% SMOOTHING
% Noelia Martinez-Molina & Aleksi Sihvonen, October 2020

clear all
%% Specify paths and list subjects
input_path='G:\Aphasia_project\VBM_v3\data_v3'; %Path for the preprocessing
names= dir(input_path);
names(ismember({names.name},{'.','..'}))=[];
ses='ses-001';
anat='anat';

%% Comment out as appropriate
prep_folder_custom='spm_us_cfm_new_TPM_med_reg_DARTEL_custom_template';
prep_folder_existing='spm_us_cfm_new_TPM_med_reg_DARTEL_existing_template';
prep_folder_old_norm='spm_us_cfm_cleanup_NEW_TPM_med_reg_old_NORM';

%% DARTEL custom template
% for sub=1:size(names,1)
%        % Exclude patients with no lesions: sub-24(ID143); sub-31 (ID154); sub-32(ID155); sub-33(ID157); sub-35(ID159)
%     if ~strcmp(names(sub).name, 'sub-24' )  && ~strcmp(names(sub).name, 'sub-31' ) && ~strcmp(names(sub).name, 'sub-32')  && ~strcmp(names(sub).name, 'sub-33') && ~strcmp(names(sub).name, 'sub-35')
%         display(sub)
%         sub_path1=fullfile(input_path, names(sub).name, ses, anat, prep_folder_custom);
%         mwrc1=spm_select('List', fullfile(sub_path1), '^mwrc1sub.*\.nii$'); %grey matter
%         mwrc2=spm_select('List', fullfile(sub_path1), '^mwrc2sub.*\.nii$'); %white matter
%         matlabbatch{1}.spm.spatial.smooth.data = {
%             fullfile(sub_path1, mwrc1)
%             fullfile(sub_path1, mwrc2)
%             };
%         matlabbatch{1}.spm.spatial.smooth.fwhm = [6 6 6];
%         matlabbatch{1}.spm.spatial.smooth.dtype = 0;
%         matlabbatch{1}.spm.spatial.smooth.im = 0;
%         matlabbatch{1}.spm.spatial.smooth.prefix = 's';
%         spm_jobman ('run', matlabbatch);
%         clear matlabbatch
%     end
% end

%% DARTEL existing template
% for sub=2:size(names,1)
%     % Exclude patients with no lesions: sub-24(ID143); sub-31 (ID154); sub-32(ID155); sub-33(ID157); sub-35(ID159)
%     if ~strcmp(names(sub).name, 'sub-24' )  && ~strcmp(names(sub).name, 'sub-31' ) && ~strcmp(names(sub).name, 'sub-32')  && ~strcmp(names(sub).name, 'sub-33') && ~strcmp(names(sub).name, 'sub-35')
%         display(sub)
%         sub_path1=fullfile(input_path, names(sub).name, ses, anat, prep_folder_existing);
%         mwrc1=spm_select('List', fullfile(sub_path1), '^mwrc1sub.*\.nii$'); %grey matter
%         mwrc2=spm_select('List', fullfile(sub_path1), '^mwrc2sub.*\.nii$'); %white matter
%         matlabbatch{1}.spm.spatial.smooth.data = {
%             fullfile(sub_path1, mwrc1)
%             fullfile(sub_path1, mwrc2)
%             };
%         matlabbatch{1}.spm.spatial.smooth.fwhm = [6 6 6];
%         matlabbatch{1}.spm.spatial.smooth.dtype = 0;
%         matlabbatch{1}.spm.spatial.smooth.im = 0;
%         matlabbatch{1}.spm.spatial.smooth.prefix = 's';
%         spm_jobman ('run', matlabbatch);
%         clear matlabbatch
%     end
% end

%% OLD NORMALIZATION

for sub=1:size(names,1)
    % Exclude patients with no lesions: sub-24(ID143); sub-31 (ID154); sub-32(ID155); sub-33(ID157); sub-35(ID159)
    if ~strcmp(names(sub).name, 'sub-24' )  && ~strcmp(names(sub).name, 'sub-31' ) && ~strcmp(names(sub).name, 'sub-32')  && ~strcmp(names(sub).name, 'sub-33') && ~strcmp(names(sub).name, 'sub-35')
        display(sub)
        sub_path1=fullfile(input_path, names(sub).name, ses, anat, prep_folder_old_norm);
        mwc1=spm_select('List', fullfile(sub_path1), '^mwc1sub.*\.nii$'); %grey matter
        mwc2=spm_select('List', fullfile(sub_path1), '^mwc2sub.*\.nii$'); %white matter
        matlabbatch{1}.spm.spatial.smooth.data = {
            fullfile(sub_path1, mwc1)
            fullfile(sub_path1, mwc2)
            };
        matlabbatch{1}.spm.spatial.smooth.fwhm = [6 6 6]; %size of kernel
        matlabbatch{1}.spm.spatial.smooth.dtype = 0;
        matlabbatch{1}.spm.spatial.smooth.im = 0;
        matlabbatch{1}.spm.spatial.smooth.prefix = 's';
        spm_jobman ('run', matlabbatch);
        clear matlabbatch
    end
end

