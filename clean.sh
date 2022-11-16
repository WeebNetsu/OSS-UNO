# do not delete lunajson, it is a required module
mv lunajson.lua lunajson.tl

trash *.lua

mv lunajson.tl lunajson.lua

cd build

trash squashfs-root

cd ../src/utils

trash *.lua

cd ../menu

trash *.lua

cd ../game

trash *.lua
