INCDIR=include
SRCDIR=src
OBJDIR=obj
BINDIR=bin
LIBDIR=lib
MKDIR=mkdir

UNAME_S = $(shell uname -s)

USE_SDL_FROM_BREW?=false

CXX=g++
ifeq (${UNAME_S},Darwin)
	ifneq (${USE_SDL_FROM_BREW},false)
		CXXFLAGS=-std=c++11 -F/Library/Frameworks -O3 -Werror -Wall -fsigned-char `sdl2-config --cflags` -mmacosx-version-min=10.7 -stdlib=libc++ -pedantic-errors
		LDFLAGS=-std=c++11 -O3 -Werror -Wall -fsigned-char -mmacosx-version-min=10.7 -stdlib=libc++ -F/Library/Frameworks
		LDLIBS=-L/usr/local/lib `sdl2-config --libs` -lSDL2_image -lm -framework OpenGL -framework CoreFoundation
	else
		CXXFLAGS=-std=c++11 -F/Library/Frameworks -I/Library/Frameworks/SDL2.framework/Headers -I/Library/Frameworks/SDL2_image.framework/Headers -O3 -Werror -Wall -fsigned-char -mmacosx-version-min=10.7 -stdlib=libc++ -pedantic-errors
		LDFLAGS=-std=c++11 -O3 -Werror -Wall -fsigned-char -mmacosx-version-min=10.7 -stdlib=libc++ -F/Library/Frameworks
		LDLIBS=-L/usr/local/lib -lm -framework OpenGL -framework SDL2 -framework SDL2_image -framework CoreFoundation
	endif
else
	CXXFLAGS=-std=c++11 -D_GNU_SOURCE=1 -D_THREAD_SAFE -Werror -Wall -fsigned-char `sdl2-config --cflags`
	LDLIBS=-L/usr/local/lib `sdl2-config --libs` -lSDL2_image -lGL
	LDFLAGS=
endif

vpath %.h $(INCDIR)
vpath %.cpp $(SRCDIR)
vpath %.cc $(SRCDIR)
vpath %.o $(OBJDIR)

HEADERS = $(shell find $(INCDIR))
INCLUDES = $(sort $(addprefix -I,$(dir $(HEADERS))))
SRCS = $(shell find $(SRCDIR) -name *.cc) $(shell find $(SRCDIR) -name *.cpp)
OBJS = $(patsubst $(SRCDIR)%,$(OBJDIR)%,$(patsubst %.cc,%.o,$(patsubst %.cpp,%.o,$(SRCS))))
APPNAME = $(BINDIR)/testSdl2

all: createFolders $(APPNAME)

$(APPNAME): $(OBJS) resources
	$(CXX) $(LDFLAGS) -o $@ $(OBJS) $(LDLIBS) -v

$(OBJDIR)/%.o: %.cc
	$(MKDIR) -p $(dir $@)
	$(CXX) $(CXXFLAGS) -o $@ -c $(INCLUDES) $<

$(OBJDIR)/%.o: %.cpp
	$(MKDIR) -p $(dir $@)
	$(CXX) $(CXXFLAGS) -o $@ -c $(INCLUDES) $<

createFolders:
	$(MKDIR) -p $(BINDIR)

resources:
	cp res/* bin

clean:
	$(RM) -rf $(OBJDIR)

cleanall: clean
	$(RM) $(APPNAME)
