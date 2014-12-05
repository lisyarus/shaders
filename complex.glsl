vec2 c_mult (vec2 a, vec2 b)
{
	return vec2(a.x * b.x - a.y * b.y, a.x * b.y + a.y * b.x);
}

vec2 c_inv (vec2 a)
{
	return vec2(a.x, -a.y) / dot(a, a);
}

vec2 c_div (vec2 a, vec2 b)
{
	return c_mult(a, c_inv(b));
}

vec4 c_color (vec2 z)
{
	float r = length(z);

	float a = atan(z.y, z.x);

	vec4 red     = vec4(1.0, 0.0, 0.0, 0.0);
	vec4 yellow  = vec4(1.0, 1.0, 0.0, 0.0);
	vec4 green   = vec4(0.0, 1.0, 0.0, 0.0);
	vec4 cyan    = vec4(0.0, 1.0, 1.0, 0.0);
	vec4 blue    = vec4(0.0, 0.0, 1.0, 0.0);
	vec4 magenta = vec4(1.0, 0.0, 1.0, 0.0);

	float p = 3.1415926535 / 3.0;

	a = a / p;

	vec4 c = vec4(0.0, 0.0, 0.0, 0.0);

	if (a < - 2.0)
		c = mix(cyan, blue, a + 3.0);
	else if (a < - 1.0)
		c = mix(blue, magenta, a + 2.0);
	else if (a < 0.0)
		c = mix(magenta, red, a + 1.0);
	else if (a < 1.0)
		c = mix(red, yellow, a + 0.0);
	else if (a < 2.0)
		c = mix(yellow, green, a - 1.0);
	else if (a < 3.0)
		c = mix(green, cyan, a - 2.0);

	if (r < 1.0)
		return mix(vec4(0.0, 0.0, 0.0, 0.0), c, r);
	else
		return mix(c, vec4(1.0, 1.0, 1.0, 0.0), 0.0 * pow(1.0 - 1.0 / r, 200000.0));
}

float sinh (float x)
{
	return (exp(x) - exp(-x)) * 0.5;
}

float cosh (float x)
{
	return (exp(x) + exp(-x)) * 0.5;
}

vec2 c_sin (vec2 a)
{
	return vec2(sin(a.x) * cosh(a.y), sinh(a.y) * cos(a.x));
}

vec2 c_exp (vec2 a)
{
	return exp(a.x) * vec2(cos(a.y), sin(a.y));
}
