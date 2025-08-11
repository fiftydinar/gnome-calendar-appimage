# gnome-calendar-appimage
Test of Gnome Calendar AppImage, not intended for daily-driving yet.

## Known issues / quirks / TO-DO
- Search integration doesn't work (depends on `dbus` service, which I don't know how to integrate)
- It depends on the `evolution-data-server` on the host for reading the calendar database (`${XDG_DATA_HOME}/evolution`)  
  If you want to isolate the dotfiles without using `bubblewrap` profile, then only use portable `.config` folder.
- Debloat it by not bundling `evolution-data-server`, as it depends on the host anyway, just like flatpak
