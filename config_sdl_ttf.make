# SDL3_ttf for nxdk Make builds (no CMake). Include after config_sdl.make:
#
#   include $(NXDK_SDL3_DIR)/config_sdl.make
#   include $(NXDK_SDL3_DIR)/config_sdl_ttf.make
#   CFLAGS += $(SDL3_FLAGS) $(SDL3_TTF_FLAGS)
#   main.exe: libSDL3_ttf.lib libSDL3.lib
#
# Uses SDL_ttf's vendored FreeType (SDL_ttf/external/freetype). HarfBuzz and
# PlutoSVG are off, as in nxdk-sdl3's CMake example (neither builds cleanly
# with nxdk), so there is no complex-script shaping and no SVG/color glyphs.

CONFIG_SDL_TTF_DIR := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))

SDL3_TTF_DIR = $(CONFIG_SDL_TTF_DIR)SDL_ttf
SDL3_FT_DIR = $(SDL3_TTF_DIR)/external/freetype

# FreeType's own default source set (external/freetype/CMakeLists.txt
# BASE_SRCS), with the generic ftsystem/ftdebug backends.
SDL3_FT_SRCS := $(addprefix $(SDL3_FT_DIR)/, \
	src/autofit/autofit.c \
	src/base/ftbase.c \
	src/base/ftbbox.c \
	src/base/ftbdf.c \
	src/base/ftbitmap.c \
	src/base/ftcid.c \
	src/base/ftdebug.c \
	src/base/ftfstype.c \
	src/base/ftgasp.c \
	src/base/ftglyph.c \
	src/base/ftgxval.c \
	src/base/ftinit.c \
	src/base/ftmm.c \
	src/base/ftotval.c \
	src/base/ftpatent.c \
	src/base/ftpfr.c \
	src/base/ftstroke.c \
	src/base/ftsynth.c \
	src/base/ftsystem.c \
	src/base/fttype1.c \
	src/base/ftwinfnt.c \
	src/bdf/bdf.c \
	src/bzip2/ftbzip2.c \
	src/cache/ftcache.c \
	src/cff/cff.c \
	src/cid/type1cid.c \
	src/gzip/ftgzip.c \
	src/lzw/ftlzw.c \
	src/pcf/pcf.c \
	src/pfr/pfr.c \
	src/psaux/psaux.c \
	src/pshinter/pshinter.c \
	src/psnames/psnames.c \
	src/raster/raster.c \
	src/sdf/sdf.c \
	src/sfnt/sfnt.c \
	src/smooth/smooth.c \
	src/svg/svg.c \
	src/truetype/truetype.c \
	src/type1/type1.c \
	src/type42/type42.c \
	src/winfonts/winfnt.c)

SDL3_TTF_CORE_SRCS := $(addprefix $(SDL3_TTF_DIR)/src/, \
	SDL_ttf.c \
	SDL_hashtable.c \
	SDL_hashtable_ttf.c \
	SDL_renderer_textengine.c \
	SDL_surface_textengine.c \
	SDL_gpu_textengine.c)

SDL3_TTF_SRCS := $(SDL3_FT_SRCS) $(SDL3_TTF_CORE_SRCS)
SDL3_TTF_FLAGS = -I$(SDL3_TTF_DIR)/include

SDL3_FT_OBJS = $(addsuffix .obj, $(basename $(SDL3_FT_SRCS)))
SDL3_TTF_CORE_OBJS = $(addsuffix .obj, $(basename $(SDL3_TTF_CORE_SRCS)))
SDL3_TTF_OBJS = $(SDL3_FT_OBJS) $(SDL3_TTF_CORE_OBJS)

$(SDL3_FT_OBJS): CFLAGS += -I$(SDL3_FT_DIR)/include -DFT2_BUILD_LIBRARY -w
$(SDL3_TTF_CORE_OBJS): CFLAGS += $(SDL3_FLAGS) $(SDL3_TTF_FLAGS) -I$(SDL3_FT_DIR)/include \
	-DTTF_USE_HARFBUZZ=0 -DTTF_USE_PLUTOSVG=0

libSDL3_ttf.lib: $(SDL3_TTF_OBJS)
