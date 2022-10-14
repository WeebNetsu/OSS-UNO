generate() {
    cd $1

    tl gen *.tl

    for files in `ls *.lua` #list of all .dat file
    do
        # cp $files $files.bck #make a backup of the file
        sed '1d' -i $files #remove the first line of the file
    done
}

generate .

generate src/utils

generate ../menu

generate ../game
