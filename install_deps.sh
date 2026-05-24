#!/usr/bin/env bash

git clone https://github.com/emscripten-core/emsdk.git
cd emsdk || exit 1
./emsdk install latest
./emsdk activate latest

# This only works for ubuntu!
sudo apt install libasound2-dev libx11-dev libxrandr-dev libxi-dev libgl1-mesa-dev libglu1-mesa-dev libxcursor-dev libxinerama-dev libwayland-dev libxkbcommon-dev
