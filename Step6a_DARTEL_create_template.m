%% DARTEL CREATE TEMPLATE
% Noelia Martinez-Molina & Aleksi Sihvonen, October 2020
clear all
%% Specify paths and list subjects
path='G:\Aphasia_project\VBM_v3\data_v3'; %Path for the preprocessing
names= dir(path);
names(ismember({names.name},{'.','..'}))=[];
ses='ses-001';
anat='anat';
prep_folder='spm_us_cfm_new_TPM_med_reg'; % Write your preprocessing folder name here

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
        n=n+1;
    end
end

%% Create custom template
        matlabbatch{1}.spm.tools.dartel.warp.images = {
                                               rc1_names
                                               rc2_names
                                               }'; %imported tissue images after affine registration
        matlabbatch{1}.spm.tools.dartel.warp.settings.template = 'Template';
        matlabbatch{1}.spm.tools.dartel.warp.settings.rform = 0;
        matlabbatch{1}.spm.tools.dartel.warp.settings.param(1).its = 3;
        matlabbatch{1}.spm.tools.dartel.warp.settings.param(1).rparam = [4 2 1e-06];
        matlabbatch{1}.spm.tools.dartel.warp.settings.param(1).K = 0;
        matlabbatch{1}.spm.tools.dartel.warp.settings.param(1).slam = 16;
        matlabbatch{1}.spm.tools.dartel.warp.settings.param(2).its = 3;
        matlabbatch{1}.spm.tools.dartel.warp.settings.param(2).rparam = [2 1 1e-06];
        matlabbatch{1}.spm.tools.dartel.warp.settings.param(2).K = 0;
        matlabbatch{1}.spm.tools.dartel.warp.settings.param(2).slam = 8;
        matlabbatch{1}.spm.tools.dartel.warp.settings.param(3).its = 3;
        matlabbatch{1}.spm.tools.dartel.warp.settings.param(3).rparam = [1 0.5 1e-06];
        matlabbatch{1}.spm.tools.dartel.warp.settings.param(3).K = 1;
        matlabbatch{1}.spm.tools.dartel.warp.settings.param(3).slam = 4;
        matlabbatch{1}.spm.tools.dartel.warp.settings.param(4).its = 3;
        matlabbatch{1}.spm.tools.dartel.warp.settings.param(4).rparam = [0.5 0.25 1e-06];
        matlabbatch{1}.spm.tools.dartel.warp.settings.param(4).K = 2;
        matlabbatch{1}.spm.tools.dartel.warp.settings.param(4).slam = 2;
        matlabbatch{1}.spm.tools.dartel.warp.settings.param(5).its = 3;
        matlabbatch{1}.spm.tools.dartel.warp.settings.param(5).rparam = [0.25 0.125 1e-06];
        matlabbatch{1}.spm.tools.dartel.warp.settings.param(5).K = 4;
        matlabbatch{1}.spm.tools.dartel.warp.settings.param(5).slam = 1;
        matlabbatch{1}.spm.tools.dartel.warp.settings.param(6).its = 3;
        matlabbatch{1}.spm.tools.dartel.warp.settings.param(6).rparam = [0.25 0.125 1e-06];
        matlabbatch{1}.spm.tools.dartel.warp.settings.param(6).K = 6;
        matlabbatch{1}.spm.tools.dartel.warp.settings.param(6).slam = 0.5;
        matlabbatch{1}.spm.tools.dartel.warp.settings.optim.lmreg = 0.01;
        matlabbatch{1}.spm.tools.dartel.warp.settings.optim.cyc = 3;
        matlabbatch{1}.spm.tools.dartel.warp.settings.optim.its = 3;
        spm_jobman ('run', matlabbatch);
        clear matlabbatch
running_time=toc;


