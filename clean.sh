# do not delete lunajson, it is a required module
mv lunajson.lua lunajson.tl

trash *.lua

mv lunajson.tl lunajson.lua

# make sure build exists before trying to clean it
mkdir -p build

cd build

trash squashfs-root

cd ../src/utils

trash *.lua

cd ../menu

trash *.lua

cd ../game

trash *.lua
