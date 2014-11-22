vec2 c_mult (vec2 a, vec2 b)
{
	return vec2(a.x * b.x - a.y * b.y, a.x * b.y + a.y * b.x);
}

vec2 c_conj (vec2 a)
{
	return vec2(a.x, -a.y);
}

vec2 c_inv (vec2 a)
{
	return c_conj(a) / dot(a, a);
}

vec2 c_div (vec2 a, vec2 b)
{
	return c_mult(a, c_inv(b));
}

vec4 color ( )
{
	vec2 z = position;
	for (int i = 0; i < 40; ++i)
	{
		z = z - c_div(c_mult(c_mult(z, z), z) - vec2(1.0, 0.0), 3.0 * c_mult(z, z));
	}

	float a = atan(z.y, z.x);
	float pi = 3.1415926535;

	vec4 red = vec4(1.0, 0.0, 0.0, 0.0);
	vec4 green = vec4(0.0, 1.0, 0.0, 0.0);
	vec4 blue = vec4(0.0, 0.0, 1.0, 0.0);

/*
	if (a < - pi / 3.0)
		return blue;
	if (a < pi / 3.0)
		return red;
	return green;
*/
	if (a < - 2.0 * pi / 3.0)
		return mix(green, blue, 3.0 * a / 2.0 / pi + 2.0);
	if (a < 0.0)
		return mix(blue, red, 3.0 * a / 2.0 / pi + 1.0);
	if (a < 2.0 * pi / 3.0)
		return mix(red, green, 3.0 * a / 2.0 / pi);
	return mix(green, blue, 3.0 * a / 2.0 / pi - 1.0);
}
