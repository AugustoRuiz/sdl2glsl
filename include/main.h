#include <string>
#include <fstream>
#include <streambuf>

#include <SDL.h>
#include <SDL_image.h>

#ifdef __APPLE__
#include "CoreFoundation/CoreFoundation.h"
#include <OpenGL/OpenGL.h>

#if ESSENTIAL_GL_PRACTICES_SUPPORT_GL3
#include <OpenGL/gl3.h>
#else
#include <OpenGL/gl.h>
#endif //!ESSENTIAL_GL_PRACTICES_SUPPORT_GL3
#else
#include <SDL_opengl.h>
#include <SDL_opengl_glext.h>
#endif
