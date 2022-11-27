#!/bin/sh
sudo pacman -S ffmpegthumbnailer imagemagick poppler djvulibre --noconfirm
sudo pip install Pillow
cd /tmp
git clone https://github.com/marianosimone/epub-thumbnailer.git
cd epub-thumbnailer
sudo python install.py install
cd /tmp
git clone https://github.com/sdushantha/fontpreview
cd fontpreview
sudo make install
cd /tmp
rm -rf epub-thumbnailer fontpreview

