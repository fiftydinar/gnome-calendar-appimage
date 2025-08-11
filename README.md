# gnome-calendar-appimage
Test of Gnome Calendar AppImage, not intended for daily-driving yet.

## Known issues / quirks / TO-DO
- Search integration doesn't work (depends on `dbus`, which is not working in AppImages)
- It depends on the `evolution-data-server` on the host for reading the calendar database (`${XDG_DATA_HOME}/evolution  
  If you want to isolate the dotfiles without using `bubblewrap` profile, then only use portable `.config` folder.
- Find a way if it's possible to debloat it (it's around the same size with or without `mesa`, which is weird)
