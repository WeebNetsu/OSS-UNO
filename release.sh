#!/bin/sh

# https://love2d.org/wiki/Game_Distribution

./gen.sh

# zip all files into a .love zip
zip -9 -r ossuno.love .

mv ossuno.love build

cd build
chmod +x appimagetool-x86_64.AppImage
chmod +x love-11.4-x86_64.AppImage

./love-11.4-x86_64.AppImage --appimage-extract

cat squashfs-root/bin/love ossuno.love > squashfs-root/bin/ossuno

chmod +x squashfs-root/bin/ossuno

cd squashfs-root

sed -i '/Name=LÖVE/d' love.desktop
sed -i '/Comment=The unquestionably awesome 2D game engine/d' love.desktop
sed -i '/Exec=love %f/d' love.desktop
sed -i '/Categories=Development;Game;/d' love.desktop

sed -i 's/\[Desktop Entry\]/\[Desktop Entry\]\nCategories=Game;/' love.desktop
sed -i 's/\[Desktop Entry\]/\[Desktop Entry\]\nExec=ossuno %f/' love.desktop
sed -i 's/\[Desktop Entry\]/\[Desktop Entry\]\nComment=Free and Open Source UNO Game/' love.desktop
sed -i 's/\[Desktop Entry\]/\[Desktop Entry\]\nName=OSS UNO/' love.desktop

cd ..

./appimagetool-x86_64.AppImage squashfs-root OSSUNO.AppImage

trash ossuno.love

mv OSSUNO.AppImage ..

cd ..

./clean.sh