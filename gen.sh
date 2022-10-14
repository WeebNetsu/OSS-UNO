generate() {
    cd $1

    for files in `ls *.tl | grep -iwv d.tl` #list of all .lua files (except .d.lua)
    do
        tl gen $files
        # cp $files $files.bck #make a backup of the file
        # sed '1d' -i $files #remove the first line of the file
    done

    sed -i '/^require/d' *.lua
    sed -i '/^local _tl_compat/d' *.lua
}

generate .
generate src/utils
# sed '1d' -i utils.lua
generate ../menu
generate ../game
# for files in `ls *.lua | grep -iwv d.lua | grep -iwv uno` #list of all .lua files (except .d.lua and uno.lua)
# do
#     # cp $files $files.bck #make a backup of the file
#     sed '1d' -i $files #remove the first line of the file
# done
