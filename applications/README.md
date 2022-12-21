# Applications installation guide

# dmenu-patched

1. Extract the archive
 
```sh
  tar -xvf dmenu-patched-5.2.tar.gz
```
2. Install

```sh
  cd dmenu-5.2/
  sudo make install 
```

# ueberzug

1. Install dependancies.
 
```sh
  pacman -S tk
```
2. Extract the archive

```sh
  tar -xvf ueberzug.18.1.9.tar.gz
```
3. Install the package using python

```sh
  sudo python setup.py install
```

Please refer the note for testing: https://github.com/Prakhil-tp/vim-wiki-notes/blob/master/ueberzug.md

## paleofetch (superfast neofetch alternative)

neofetch written in c

```
cp paleofetch ~/.local/bin/
```
