#/bin/bash
#
# This script does the following:
# 1) reads the name all *.avi file in the current directory
# 2) removes the string before the hypen in the filename, inserts a colon at the 10th position in the filename and chos the output into the newfilename variable
# 3) outputs the content of the newfilename variable to the screen
# 4) renames all files in the directory with the *.avi extension to content of the newfilename variable 
#
#
echo " "
echo "Files in this directory will be renamed as follows:"
echo "==================================================="
echo " "
echo "######################################"
echo " "
for file in *.avi; 
do
	#The first instance of sed here removes all characters before the first instance of a hyphen "-" in all filenames
 	#The second instance of sed inserts a colon at the 10th position (9 = 10th position eg: 0-9)
    newfilename=$(echo "$file" | sed 's/^[^-]* - //' | sed 's/^\(.\{9\}\)/\1:/');
    echo $newfilename
    mv "$file" "$newfilename";
done
echo " "
echo "######################################"
echo " "
