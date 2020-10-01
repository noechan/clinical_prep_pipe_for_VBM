
## Script for cropping T1 and skull-stripping with FSL commands ##

#!/bin/bash

# Set up path

path='/media/cbru/LASA_Noelia/Aphasia_project/VBM_v2/data'

# Loop over all subjects and execute commands


for id in `seq -w 1 50` ; do
	sub="sub-$id"
	echo "===> Starting preparation of $sub"
	cd $path/$sub/ses-001/anat/

	echo cropping T1
	robustfov -i ${sub}_ses-001_roT1w.nii -r ${sub}_ses-001_roT1w_cropped.nii

	echo skull-stripping with a fractional intensity threshold of 0.15 and a vertical gradient threshold of -0.3
	bet2 ${sub}_ses-001_roT1w_cropped.nii ${sub}_roT1w_cropped_f015_g-03_brain.nii -f 0.15 -g -0.3 #These values seem to work well with 
        #most of the subjects in this dataset but do visual checks and tune if needed

done;


