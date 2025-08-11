# gnome-calendar-appimage
Test of Gnome Calendar AppImage, not intended for daily-driving yet.

## Known issues / TO-DO
- Some icons are not available
- Search integration doesn't work (tried to make it work, but was unsuccessful)
- It depends on the host for reading the calendar database (`${XDG_DATA_HOME}/evolution/`), so if you want to isolate the dotfiles without using `bubblewrap`, then only use portable `.config` folder.