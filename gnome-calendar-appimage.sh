#!/bin/sh

set -eux

ARCH="$(uname -m)"
PACKAGE=gnome-calendar
ICON=/usr/share/icons/hicolor/scalable/apps/org.gnome.Calendar.svg
DESKTOP=/usr/share/applications/org.gnome.Calendar.desktop
URUNTIME="https://raw.githubusercontent.com/pkgforge-dev/Anylinux-AppImages/refs/heads/main/useful-tools/uruntime2appimage.sh"
SHARUN="https://raw.githubusercontent.com/pkgforge-dev/Anylinux-AppImages/refs/heads/main/useful-tools/quick-sharun.sh"
UPDATER="https://github.com/pkgforge-dev/AppImageUpdate-Enhanced-Edition/releases/latest/download/appimageupdatetool+validate-$ARCH.AppImage"

VERSION=$(pacman -Q "$PACKAGE" | awk 'NR==1 {print $2; exit}')
[ -n "$VERSION" ] && echo "$VERSION" > ~/version

export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export OUTNAME="$PACKAGE"-"$VERSION"-anylinux-"$ARCH".AppImage

# Prepare AppDir
mkdir -p ./AppDir/shared/lib

# Copy desktop file & icon
cp -v "$DESKTOP"   ./AppDir/
cp -v "$ICON"      ./AppDir/

# Patch StartupWMClass to work on X11
# Doesn't work when ran in Wayland, as it's 'org.gnome.Calendar' instead.
# It needs to be manually changed by the user in this case.
sed -i '/^\[Desktop Entry\]/a\
StartupWMClass=gnome-calendar
' ./AppDir/*.desktop

# DEPLOY ALL LIBS
wget --retry-connrefused --tries=30 "$SHARUN" -O ./quick-sharun
chmod +x ./quick-sharun
./quick-sharun /usr/bin/gnome-calendar /usr/lib/evolution-data-server/*/* /usr/lib/libgweather*

## Fix hardcoded path for 'libcamel' libraries from 'evolution-data-server'
sed -i 's|/usr/lib|././/lib|g' ./AppDir/shared/lib/libcamel*
echo 'SHARUN_WORKING_DIR=${SHARUN_DIR}' >> ./AppDir/.env

## Copy Locations.bin & fix hardcoded path for 'libgweather' libraries
sed -i 's|/usr/lib|././/lib|g' ./AppDir/shared/lib/libgweather*
cp -r /usr/lib/libgweather*/ ./AppDir/shared/lib/

## Deploy Gstreamer & evolution-data-server binaries manually, as sharun can only handle libraries in /lib/ for now
echo "Deploying evolution-data-server binaries..."
cp -r /usr/lib/evolution-data-server ./AppDir/shared/lib/evolution-data-server

echo "Sharunning evolution-data-server bins..."
bins_to_find="$(find ./AppDir/shared/lib/ -exec file {} \; | grep -i 'elf.*executable' | awk -F':' '{print $1}')"
for bin in $bins_to_find; do
	mv -v "$bin" ./AppDir/shared/bin && ln ./sharun "$bin"
	echo "Sharuned $bin"
done

./quick-sharun l -g

## Copy locale manually, as sharun doesn't do that at the moment
cp -vr /usr/lib/locale           ./AppDir/shared/lib
cp -r /usr/share/locale          ./AppDir/share
find ./AppDir/share/locale -type f ! -name '*glib*' ! -name '*gnome-calendar*' -delete
find ./AppDir/share/locale -type f 
## Fix hardcoded path for locale
sed -i 's|/usr/share|././/share|g' ./AppDir/shared/bin/gnome-calendar
## Needed when locale patch is used
echo 'SHARUN_WORKING_DIR=${SHARUN_DIR}' > ./AppDir/.env

## Copy the icon to AppDir's share, as it's not copied by default
mkdir -p           ./AppDir/share/icons/hicolor/scalable/apps/
cp -v "$ICON"      ./AppDir/"${ICON#/usr/}"

# MAKE APPIMAGE WITH URUNTIME
wget --retry-connrefused --tries=30 "$URUNTIME" -O ./uruntime2appimage
chmod +x ./uruntime2appimage
./uruntime2appimage
