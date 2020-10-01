%% INVERT THE BINARY LESION MASK TO USE CFM IN OLD SEG
% Noelia Martinez-Molina & Aleksi Sihvonen, October 2020

clear all
%% Specify paths and list subjects
path='G:\Aphasia_project\VBM_v3\data_v3'; %Path for the preprocessing
names= dir(path);
names(ismember({names.name},{'.','..'}))=[];
ses='ses-001';
anat='anat';
%% Invert the lesion mask
for sub=1:size(names,1)
    % Exclude patients with no lesions: sub-24(ID143); sub-31 (ID154); sub-32(ID155); sub-33(ID157); sub-35(ID159)
    if ~strcmp(names(sub).name, 'sub-24' )  && ~strcmp(names(sub).name, 'sub-31' ) && ~strcmp(names(sub).name, 'sub-32')  && ~strcmp(names(sub).name, 'sub-33') && ~strcmp(names(sub).name, 'sub-35')
        sub_path1=fullfile(path, names(sub).name, ses, anat);
        lesion=spm_select('List', fullfile(sub_path1), '^*roLESION.*\.nii$');
        matlabbatch{1}.spm.util.imcalc.input ={fullfile(sub_path1,lesion)};
        matlabbatch{1}.spm.util.imcalc.output =['inv_' lesion];
        matlabbatch{1}.spm.util.imcalc.outdir = {fullfile(sub_path1)};
        matlabbatch{1}.spm.util.imcalc.expression = '(i1.*-1)+1';
        matlabbatch{1}.spm.util.imcalc.var = struct('name', {}, 'value', {});
        matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
        matlabbatch{1}.spm.util.imcalc.options.mask = 0;
        matlabbatch{1}.spm.util.imcalc.options.interp = 1;
        matlabbatch{1}.spm.util.imcalc.options.dtype = 4;
        spm_jobman ('run', matlabbatch);
        clear matlabbatch
    end
end

