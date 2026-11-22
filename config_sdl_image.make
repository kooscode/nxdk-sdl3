# SDL3_image for nxdk Make builds (no CMake). Include after config_sdl.make:
#
#   include $(NXDK_SDL3_DIR)/config_sdl.make
#   include $(NXDK_SDL3_DIR)/config_sdl_image.make
#   CFLAGS += $(SDL3_FLAGS) $(SDL3_IMAGE_FLAGS)
#   main.exe: libSDL3_image.lib libSDL3.lib
#
# Formats: PNG (load and save through SDL3's own PNG code), JPEG (stb_image),
# BMP, GIF, QOI and TGA. No external libraries are needed.

CONFIG_SDL_IMAGE_DIR := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))

SDL3_IMAGE_DIR = $(CONFIG_SDL_IMAGE_DIR)SDL_image

# Every loader file is compiled; the ones whose LOAD_* define is not set
# compile to "not supported" stubs, which IMG.c still links against.
# IMG_WIC.c and the ImageIO (.m) backend are Windows/Apple only.
SDL3_IMAGE_SRCS := $(filter-out $(SDL3_IMAGE_DIR)/src/IMG_WIC.c, \
	$(wildcard $(SDL3_IMAGE_DIR)/src/*.c))

SDL3_IMAGE_FLAGS = -I$(SDL3_IMAGE_DIR)/include

SDL3_IMAGE_OBJS = $(addsuffix .obj, $(basename $(SDL3_IMAGE_SRCS)))

$(SDL3_IMAGE_OBJS): CFLAGS += $(SDL3_FLAGS) $(SDL3_IMAGE_FLAGS) \
	-DUSE_STBIMAGE -DLOAD_PNG -DSAVE_PNG=1 -DLOAD_JPG -DSAVE_JPG=0 \
	-DLOAD_BMP -DLOAD_GIF -DLOAD_QOI -DLOAD_TGA

libSDL3_image.lib: $(SDL3_IMAGE_OBJS)
