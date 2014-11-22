vec4 color ( )
{
	int count = 4;

	float t = time;

	mat2 rt = mat2(cos(t), sin(t), -sin(t), cos(t));

	vec2 pos[4];
	pos[0] = rt * vec2(-0.83, -0.5);
	pos[1] = rt * vec2(0.83, -0.5);
	pos[2] = rt * vec2(0.0, 1.0);
	pos[3] = mouse;

	float mass[4];
	mass[0] = 10.0;
	mass[1] = 10.0;
	mass[2] = 10.0;
	mass[3] = 10.0;
	
	float s = 30.0;

	vec2 f = vec2(0.0, 0.0);

	for (int i = 0; i < count; ++i)
	{
		vec2 r = pos[i] - position;
		f = f + r / pow(length(r), 3) * mass[i];
	}

	float l = length(f) / s;

	l = floor(l * 16.0) / 16.0;

	float r = l;
	float g = l;
	float b = l;

	return vec4(r, g, b, 0.0);
}
