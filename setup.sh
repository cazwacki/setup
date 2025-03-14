# quicktile for easy kb-kased window management
sudo apt-get install -y python3 python3-pip python3-setuptools python3-gi python3-xlib python3-dbus gir1.2-glib-2.0 gir1.2-gtk-3.0 gir1.2-wnck-3.0
sudo -H pip3 install https://github.com/ssokolow/quicktile/archive/master.zip --break-system-packages
cp ./quicktile.cfg ~/.config/quicktile.cfg
cp Quicktile.desktop ~/.config/autostart/Quicktile.desktop

# emacs for development
sudo apt-get install emacs
mkdir ~/.emacs.d
cp init.el ~/.emacs.d/init.el
