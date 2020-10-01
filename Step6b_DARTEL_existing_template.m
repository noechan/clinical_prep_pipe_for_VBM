%% DARTEL EXISTING TEMPLATE
% Noelia Martinez-Molina & Aleksi Sihvonen, October 2020

clear all
%Specify paths
source_path='G:\Aphasia_project\VBM_v3\data_v3'; %Path for the preprocessing
names= dir(source_path);
names(ismember({names.name},{'.','..'}))=[];
ses='ses-001';
anat='anat';
prep_folder_custom='spm_us_cfm_new_TPM_med_reg'; % Write your source preprocessing folder name here
prep_folder_existing='spm_us_cfm_new_TPM_med_reg_DARTEL_existing_template';  % Write your destination preprocessing folder name here

%% If running multiple normalization approaches to fine tune the prep pipe, the outputs from the Old Seg can be copied from a source prep folder to a destination prep folder as shown below
for sub=1:size(names,1)
    % Exclude patients with no lesions: sub-24(ID143); sub-31 (ID154); sub-32(ID155); sub-33(ID157); sub-35(ID159)
    if ~strcmp(names(sub).name, 'sub-24' )  && ~strcmp(names(sub).name, 'sub-31' ) && ~strcmp(names(sub).name, 'sub-32')  && ~strcmp(names(sub).name, 'sub-33') && ~strcmp(names(sub).name, 'sub-35')
        sub_path1=fullfile(source_path, names(sub,:).name, ses,anat);
        rc1=spm_select('List', fullfile(sub_path1,prep_folder_custom), '^rc1.*\.nii$');
        rc2=spm_select('List', fullfile(sub_path1, prep_folder_custom), '^rc2.*\.nii$');
        cd(sub_path1), mkdir(prep_folder_existing)
        copyfile(fullfile(sub_path1,prep_folder_custom, rc1), fullfile(sub_path1,prep_folder_existing))
        copyfile(fullfile(sub_path1,prep_folder_custom, rc2), fullfile(sub_path1,prep_folder_existing))
    end
end
%% Prepare inputs
clear rc1 rc2
tic
n=1;
for sub=1:size(names,1)
    if ~strcmp(names(sub).name, 'sub-24' )  && ~strcmp(names(sub).name, 'sub-31' ) && ~strcmp(names(sub).name, 'sub-32')  && ~strcmp(names(sub).name, 'sub-33') && ~strcmp(names(sub).name, 'sub-35')
        sub_path2=fullfile(source_path, names(sub).name, ses, anat, prep_folder_existing);
        rc1{n,1}=spm_select('List', fullfile(sub_path2), '^rc1.*\.nii$');
        rc1_names{n,1}=fullfile(sub_path2,rc1{n,1});
        rc2{n,1}=spm_select('List', fullfile(sub_path2), '^rc2.*\.nii$');
        rc2_names{n,1}=fullfile(sub_path2,rc2{n,1});
        n=n+1;
    end
end
 %% Registration to existing template from the IXI 555 MNI 152 dataset (from the CAT12 toolbox)
matlabbatch{1}.spm.tools.dartel.warp1.images ={
                                               rc1_names
                                               rc2_names
                                               }'; %imported tissue images after affine registration;
matlabbatch{1}.spm.tools.dartel.warp1.settings.rform = 0;
matlabbatch{1}.spm.tools.dartel.warp1.settings.param(1).its = 3;
matlabbatch{1}.spm.tools.dartel.warp1.settings.param(1).rparam = [4 2 1e-06];
matlabbatch{1}.spm.tools.dartel.warp1.settings.param(1).K = 0;
matlabbatch{1}.spm.tools.dartel.warp1.settings.param(1).template = {'C:\Program Files\spm12\toolbox\cat12\templates_1.50mm\Template_1_IXI555_MNI152.nii'};
matlabbatch{1}.spm.tools.dartel.warp1.settings.param(2).its = 3;
matlabbatch{1}.spm.tools.dartel.warp1.settings.param(2).rparam = [2 1 1e-06];
matlabbatch{1}.spm.tools.dartel.warp1.settings.param(2).K = 0;
matlabbatch{1}.spm.tools.dartel.warp1.settings.param(2).template = {'C:\Program Files\spm12\toolbox\cat12\templates_1.50mm\Template_2_IXI555_MNI152.nii'};
matlabbatch{1}.spm.tools.dartel.warp1.settings.param(3).its = 3;
matlabbatch{1}.spm.tools.dartel.warp1.settings.param(3).rparam = [1 0.5 1e-06];
matlabbatch{1}.spm.tools.dartel.warp1.settings.param(3).K = 1;
matlabbatch{1}.spm.tools.dartel.warp1.settings.param(3).template = {'C:\Program Files\spm12\toolbox\cat12\templates_1.50mm\Template_3_IXI555_MNI152.nii'};
matlabbatch{1}.spm.tools.dartel.warp1.settings.param(4).its = 3;
matlabbatch{1}.spm.tools.dartel.warp1.settings.param(4).rparam = [0.5 0.25 1e-06];
matlabbatch{1}.spm.tools.dartel.warp1.settings.param(4).K = 2;
matlabbatch{1}.spm.tools.dartel.warp1.settings.param(4).template = {'C:\Program Files\spm12\toolbox\cat12\templates_1.50mm\Template_4_IXI555_MNI152.nii'};
matlabbatch{1}.spm.tools.dartel.warp1.settings.param(5).its = 3;
matlabbatch{1}.spm.tools.dartel.warp1.settings.param(5).rparam = [0.25 0.125 1e-06];
matlabbatch{1}.spm.tools.dartel.warp1.settings.param(5).K = 4;
matlabbatch{1}.spm.tools.dartel.warp1.settings.param(5).template = {'C:\Program Files\spm12\toolbox\cat12\templates_1.50mm\Template_5_IXI555_MNI152.nii'};
matlabbatch{1}.spm.tools.dartel.warp1.settings.param(6).its = 3;
matlabbatch{1}.spm.tools.dartel.warp1.settings.param(6).rparam = [0.25 0.125 1e-06];
matlabbatch{1}.spm.tools.dartel.warp1.settings.param(6).K = 6;
matlabbatch{1}.spm.tools.dartel.warp1.settings.param(6).template = {'C:\Program Files\spm12\toolbox\cat12\templates_1.50mm\Template_6_IXI555_MNI152.nii'};
matlabbatch{1}.spm.tools.dartel.warp1.settings.optim.lmreg = 0.01;
matlabbatch{1}.spm.tools.dartel.warp1.settings.optim.cyc = 3;
matlabbatch{1}.spm.tools.dartel.warp1.settings.optim.its = 3;
spm_jobman ('run', matlabbatch);
clear matlabbatch
running_time=toc;
