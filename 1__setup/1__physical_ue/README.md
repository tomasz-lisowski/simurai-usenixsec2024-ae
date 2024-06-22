## Connection to Host 1

`ssh setup1@65.21.243.117 -p 20242 -i simurai_ae.key`


## Connection to UE
UEs can be controled by scrcpy through the remote adb server on Host1.

### Scrcpy Installation
```
# for Debian/Ubuntu
sudo apt install ffmpeg libsdl2-2.0-0 adb wget \
                 gcc git pkg-config meson ninja-build libsdl2-dev \
                 libavcodec-dev libavdevice-dev libavformat-dev libavutil-dev \
                 libswresample-dev libusb-1.0-0 libusb-1.0-0-dev

git clone https://github.com/Genymobile/scrcpy
cd scrcpy
git check out 576e7552a29e30b40205f81f2ff4d461f018313f
./install_release.sh
```