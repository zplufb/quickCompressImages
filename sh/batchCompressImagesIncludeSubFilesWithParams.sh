#!/bin/bash
read_dir(){
    echo 'start walk through dir of'$1
	suffixJpg='.jpg'
	suffixJpeg='.jpeg'
	suffixPng='.png'
	for file in `ls -a $1`
    do
        if [ -d $1"/"$file ]
        then
            if [[ $file != '.' && $file != '..' ]]
            then
                read_dir $1"/"$file
            fi
        else
            echo $1"/"$file
            if [[ ${file:0-4:4} == ${suffixJpg} ||  ${file:0-5:5} == ${suffixJpeg} ]]
            then
				magick  $1"/"$file -resize $2% -quality $3%  $1"/"op_$file
			fi
			if [[ ${file:0-4:4} == ${suffixPng} ]]
            then
				magick  $1"/"$file -resize $2% -quality $3%  $1"/"op_$file.jpg
			fi
        fi
    done
    echo 'walk complete for dir of'$1
}
read_dir $1 $2 $3
