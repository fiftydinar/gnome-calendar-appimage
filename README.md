# gnome-calendar-appimage
Test of Gnome Calendar AppImage, not intended for daily-driving yet.

## Known issues / TO-DO
- Build `gnome-calendar` from source instead of relying on Arch repos
- Integrate self-updater
- Some icons are not available
- It depends on the host for reading the calendar database (`${XDG_DATA_HOME}/evolution/`), so if you want to isolate the dotfiles without using `bubblewrap`, then only use portable `.config` folder.
- Need to refactor it to use newer template & to not bundle `mesa`
