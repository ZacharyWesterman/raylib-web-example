This repository is a basic skeleton project demonstrating how to compile a raylib project for both desktop and web without changing any application code.

# Dependencies
First install any missing dependencies.
If on Ubuntu, run `./install_deps.sh`.
If you're on some other distro or OS, I'm so sorry.

# Building

**WARNING**: If you change the build target, make sure to run `make clean` or you will get compilation errors!

- If building for linux, just run `make linux` and then you can run `./bin/demo`.
- If building for web, run `./webenv.sh` and then
  - If you want a debug html page, run `make web-debug`, and then run `emrun bin/enchanter.html`.
  - If you don't need the debug page, run `make web`.
