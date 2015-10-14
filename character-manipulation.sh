#/bin/bash
#read in a list of file names
for file in *.avi; 
do
	#The first instance of sed here removes all characters before the first instance of a hyphen "-" in all filenames
 	#The second instance of sed inserts a colon at the 10th position (9 = 10th position eg: 0-9)
	echo "$file" | sed 's/^[^-]* - //' | sed 's/^\(.\{9\}\)/\1:/'
done
echo "##########################"
