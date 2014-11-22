#include <SDL2/SDL.h>

#define GL_GLEXT_PROTOTYPES
#include <GL/gl.h>

#include <iostream>
#include <fstream>
#include <sstream>
#include <vector>
#include <cmath>

int main (int argc, char ** argv)
{
	if (argc != 2)
	{
		std::cerr << "Usage: " << argv[0] << " <shader-file>" << std::endl;
		return 1;
	}

	SDL_Init(SDL_INIT_VIDEO);

	SDL_Window * window = SDL_CreateWindow("Shaders", SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, 600, 600, SDL_WINDOW_OPENGL | SDL_WINDOW_RESIZABLE);

	SDL_GLContext gl_context = SDL_GL_CreateContext(window);

	GLenum shader_program = 0;
	
	std::string saved_source;

	GLint time_location = -1;
	GLint mouse_location = -1;

	auto reload = [&]()
	{
		char const * common = "varying vec2 position;\nuniform float time;uniform vec2 mouse;\n";

		std::string shader_text;
		{
			std::ifstream ifs(argv[1]);
			std::ostringstream oss;
			oss << ifs.rdbuf();
			shader_text = oss.str();
		}
		if (saved_source == shader_text) return;
		saved_source = shader_text;

		if (shader_program)
			glDeleteProgram(shader_program);

		shader_program = glCreateProgram();

		GLenum vertex_shader = glCreateShader(GL_VERTEX_SHADER);
		{
			char const * s = "void main ( ) { gl_Position = gl_Vertex; position = (gl_ModelViewMatrix * gl_Vertex).xy; }\n";
			char const * source[] = {common, s};
			glShaderSource(vertex_shader, 2, source, nullptr);
		}
		glCompileShader(vertex_shader);
		{
			std::vector<char> log(4096);
			GLsizei length;
			glGetShaderInfoLog(vertex_shader, log.size(), &length, log.data());
			std::cout << "Vertex shader compilation log:\n" << log.data() << std::flush;
		}
		
		GLenum fragment_shader = glCreateShader(GL_FRAGMENT_SHADER);	
		{
			char const * s = "void main ( ) { gl_FragColor = color(); }";
			char const * source[] = {common, shader_text.c_str(), s};
			glShaderSource(fragment_shader, 3, source, nullptr);
		}
		glCompileShader(fragment_shader);
		{
			std::vector<char> log(4096);
			GLsizei length;
			glGetShaderInfoLog(fragment_shader, log.size(), &length, log.data());
			std::cout << "Fragment shader compilation log:\n" << log.data() << std::flush;
		}

		glAttachShader(shader_program, vertex_shader);
		glAttachShader(shader_program, fragment_shader);
		glLinkProgram(shader_program);

		glUseProgram(shader_program);

		time_location = glGetUniformLocation(shader_program, "time");
		mouse_location = glGetUniformLocation(shader_program, "mouse");
	};

	bool quit = false;

	std::size_t frame_number = 0;

	int width = 600, height = 600;

	float screen_ratio = 1.0;

	float mouse_x, mouse_y;

	bool lbutton = false;

	float cx = 0.0, cy = 0.0, scale = 1.0, rscale = 1.0;

	while (!quit)
	{
		SDL_Event event;
		while (SDL_PollEvent(&event)) switch (event.type)
		{
		case SDL_QUIT:
			quit = true;
			break;
		case SDL_WINDOWEVENT:
			switch (event.window.event)
			{
			case SDL_WINDOWEVENT_RESIZED:
				width = event.window.data1;
				height = event.window.data2;
				glViewport(0, 0, width, height);
				screen_ratio = static_cast<float>(width) / height;
				break;
			}
			break;
		case SDL_KEYDOWN:
			switch (event.key.keysym.sym)
			{
			case SDLK_ESCAPE:
				quit = true;
				break;
			case SDLK_l:
				reload();
				break;
			}
			break;
		case SDL_MOUSEBUTTONDOWN:
			if (event.button.button == SDL_BUTTON_LEFT)
			{
				lbutton = true;
			}
			break;
		case SDL_MOUSEBUTTONUP:
			if (event.button.button == SDL_BUTTON_LEFT)
			{
				lbutton = false;
			}
			break;
		case SDL_MOUSEMOTION:
		{
			float old_x = mouse_x;
			float old_y = mouse_y;
			mouse_x = (2.0 * event.motion.x - width) / width * screen_ratio;
			mouse_y = -(2.0 * event.motion.y - height) / height;
			if (lbutton)
			{
				cx -= (mouse_x - old_x) * scale;
				cy -= (mouse_y - old_y) * scale;
			}
			break;
		}
		case SDL_MOUSEWHEEL:
		{
			scale *= std::pow(0.8, event.wheel.y);
			break;
		}
		}

		if (frame_number % 20 == 0)
			reload();

		if (time_location != -1)
			glUniform1f(time_location, frame_number * 0.01f);

		if (mouse_location != -1)
			glUniform2f(mouse_location, mouse_x * rscale + cx, mouse_y * rscale + cy);

		glClearColor(0.0, 0.0, 0.0, 0.0);
		glClear(GL_COLOR_BUFFER_BIT);

		glLoadIdentity();
		glTranslated(cx, cy, 0.0);
		glScaled(rscale, rscale, 1.0);
		glScaled(screen_ratio, 1.0, 1.0);

		glBegin(GL_QUADS);
		glVertex2d(-1.0, -1.0);
		glVertex2d( 1.0, -1.0);
		glVertex2d( 1.0,  1.0);
		glVertex2d(-1.0,  1.0);
		glEnd();

		SDL_GL_SwapWindow(window);

		++frame_number;

		{
			float old_rscale = rscale;
			rscale += (scale - rscale) * 0.25;

			cx += mouse_x * (old_rscale - rscale);
			cy += mouse_y * (old_rscale - rscale);
		}
	}

	SDL_GL_DeleteContext(gl_context);
	SDL_DestroyWindow(window);
}
