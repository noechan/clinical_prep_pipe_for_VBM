%% UNIFIED SEGMENTATION WITH CFM AND TPM FROM IXI DATASET IN SPM12
% Noelia Martinez-Molina & Aleksi Sihvonen, October 2020

clear all
%% Specify paths and list subjects
path='G:\Aphasia_project\VBM_v3\data_v3'; %Path for the preprocessing
names= dir(path);
names(ismember({names.name},{'.','..'}))=[];
ses='ses-001';
anat='anat';
prep_folder='spm_us_cfm_cleanup_NEW_TPM_med_reg_old_NORM'; % Write your preprocessing folder name here
%% Unified segmentation with CFM
tic
for sub=1:size(names,1)
      % Exclude patients with no lesions: sub-24(ID143); sub-31 (ID154); sub-32(ID155); sub-33(ID157); sub-35(ID159)
    if ~strcmp(names(sub).name, 'sub-24' )  && ~strcmp(names(sub).name, 'sub-31' ) && ~strcmp(names(sub).name, 'sub-32')  && ~strcmp(names(sub).name, 'sub-33') && ~strcmp(names(sub).name, 'sub-35')
        sub_path1=fullfile(path, names(sub).name, ses, anat);
        T1=spm_select('List', fullfile(sub_path1), '^*roT1w.*\.nii$'); %Your reoriented to AC T1w
        rinv_lesion=spm_select('List', fullfile(sub_path1), '^rinv_.*\.nii$'); %Your inverted lesion mask here. Reslice with MRIcron if needed to match dimensions and orientations with roT1w and append r- prefix.
        cd(sub_path1),  mkdir(prep_folder)
        copyfile(fullfile(sub_path1,T1),fullfile(sub_path1,prep_folder))
        copyfile(fullfile(sub_path1,rinv_lesion),fullfile(sub_path1,prep_folder))
        matlabbatch{1}.spm.tools.oldseg.data ={ fullfile(sub_path1,prep_folder,T1)};
        matlabbatch{1}.spm.tools.oldseg.output.GM = [0 0 1]; %native space
        matlabbatch{1}.spm.tools.oldseg.output.WM = [0 0 1]; %native space
        matlabbatch{1}.spm.tools.oldseg.output.CSF = [0 0 1]; %native space, to calculate TIV
        matlabbatch{1}.spm.tools.oldseg.output.biascor = 1;
        matlabbatch{1}.spm.tools.oldseg.output.cleanup = 1; %light cleanup, check what works better for your dataset
        matlabbatch{1}.spm.tools.oldseg.opts.tpm = {
            'C:\Program Files\spm12\toolbox\OldSeg\TPM_00001.nii' %Grey TPM from SPM12 based on the IXI 555 MNI152 extracted with spm_file_split
            'C:\Program Files\spm12\toolbox\OldSeg\TPM_00002.nii' %White TPM from SPM12 based on the IXI 555 MNI152 extracted with spm_file_split
            'C:\Program Files\spm12\toolbox\OldSeg\TPM_00003.nii' %CSF TPM from SPM12 based on the IXI 555 MNI152 extracted with spm_file_split
            };
        matlabbatch{1}.spm.tools.oldseg.opts.ngaus = [2
            2
            2
            4];
        matlabbatch{1}.spm.tools.oldseg.opts.regtype = 'mni';
        matlabbatch{1}.spm.tools.oldseg.opts.warpreg = 1;
        matlabbatch{1}.spm.tools.oldseg.opts.warpco = 25;
        matlabbatch{1}.spm.tools.oldseg.opts.biasreg = 0.01; %medium_regularisation, check what works better for your dataset
        matlabbatch{1}.spm.tools.oldseg.opts.biasfwhm = 60;
        matlabbatch{1}.spm.tools.oldseg.opts.samp = 3;
        matlabbatch{1}.spm.tools.oldseg.opts.msk = {fullfile(sub_path1,prep_folder, rinv_lesion)};
        spm_jobman ('run', matlabbatch);
        clear matlabbatch
    end
end
running_time=toc;
%% The outputs from the Old Seg can be used for Old Normalization or DARTEL after inital import
