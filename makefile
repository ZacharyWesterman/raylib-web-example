NAME = demo
VER_MAJOR = 0
VER_MINOR = 0

RAYLIB_VER = 6.0

LFLAGS = $(RLDIR)/lib/libraylib.a -lGL -lm -lpthread -ldl -lrt -lX11
CFLAGS = -I$(RLDIR)/include -std=c++20

CC = g++

OBJECTS = obj/main.o

RLDIR = lib/raylib-$(RAYLIB_VER)_linux_amd64

#########################################
# Phony rules
#########################################

.PHONY: web web-debug clean pristine

linux: RLDIR = lib/raylib-$(RAYLIB_VER)_linux_amd64
linux: bin/$(NAME)

web: CC = em++
web: RLDIR = lib/raylib-$(RAYLIB_VER)_webassembly
web: LFLAGS += -sASYNCIFY -sUSE_GLFW=3
web: bin/$(NAME).js

web-debug: CC = em++
web-debug: RLDIR = lib/raylib-$(RAYLIB_VER)_webassembly
web-debug: LFLAGS += --emrun -sASYNCIFY -sUSE_GLFW=3
web-debug: bin/$(NAME).html

raylib: lib/raylib

clean:
	rm -rf bin obj

pristine: clean
	rm -rf lib emsdk

#########################################
# Actual rules
#########################################

# Web build
bin/$(NAME).html: $(OBJECTS) | bin/$(NAME).js
	$(CC) -o $@ $^ $(LFLAGS)

bin/$(NAME).js: $(OBJECTS) | bin/$(NAME).wasm
	$(CC) -o $@ $^ $(LFLAGS)

bin/$(NAME).wasm: $(OBJECTS) | bin $(RLDIR)/lib/libraylib.a
	$(CC) -o $@ $^ $(LFLAGS)

# Linux build
bin/$(NAME): $(OBJECTS) | bin $(RLDIR)/lib/libraylib.a
	$(CC) -o $@ $^ $(LFLAGS)

# Objects
obj/main.o: src/main.cpp | obj
	$(CC) $(CFLAGS) -o $@ -c $<

obj/%.o: src/%.cpp src/%.hpp | obj
	$(CC) $(CFLAGS) -o $@ -c $<

# Raylib rules.
# The exact version of raylib will change depending on the target environment.

lib/raylib-$(RAYLIB_VER)_%: lib/raylib-$(RAYLIB_VER)_%/lib/libraylib.a

lib/raylib-$(RAYLIB_VER)_linux_%/lib/libraylib.a: lib/raylib-$(RAYLIB_VER)_linux_%.tar.gz
	tar xzf $< -C lib/

lib/raylib-$(RAYLIB_VER)_%/lib/libraylib.a: lib/raylib-$(RAYLIB_VER)_%.zip
	unzip $< -d lib/

lib/raylib-$(RAYLIB_VER)_webassembly/lib/libraylib.a: lib/raylib-$(RAYLIB_VER)_webassembly.zip
	unzip $< -d lib/
	mv $(dir $@)/libraylib.web.a $@

lib/raylib-%.tar.gz: | lib
	wget https://github.com/raysan5/raylib/releases/download/$(RAYLIB_VER)/$(notdir $@) -O $@

lib/raylib-%.zip: | lib
	wget https://github.com/raysan5/raylib/releases/download/$(RAYLIB_VER)/$(notdir $@) -O $@

# Directory rules.
# These make sure the directories exist without rebuilding if their contents change.

bin: bin/.sentinel
obj: obj/.sentinel
lib: lib/.sentinel

%/.sentinel:
	mkdir -p $(dir $@)
	@touch $@

