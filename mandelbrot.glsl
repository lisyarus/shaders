vec4 make_color (float x)
{
	int count = 4;

	float t[4];
	t[0] = 0.0;
	t[1] = 1.0 / 3.0;
	t[2] = 2.0 / 3.0;
	t[3] = 1.0;

	vec4 c[4];
	c[0] = vec4(0.0, 0.0, 0.0, 0.0);
	c[1] = vec4(1.0, 0.0, 0.0, 0.0);
	c[2] = vec4(1.0, 1.0, 0.0, 0.0);
	c[3] = vec4(1.0, 1.0, 1.0, 0.0);

	if (x < t[0]) return c[0];
	
	for (int i = 1; i < count; ++i)
	{
		if (x < t[i])
		{
			return mix(c[i - 1], c[i], (x - t[i - 1]) / (t[i] - t[i - 1]));
		}
	}

	return c[count - 1];
}

vec4 color ( )
{
	vec2 c = position * 2.0;
	vec2 z = vec2(0.0, 0.0);
	int i;
	int max = 140;
	for (i = 0; i < max; ++i)
	{
		z = vec2(z.x * z.x - z.y * z.y + c.x, 2.0 * z.x * z.y + c.y);
		if (length(z) >= 2.0)
			break;
	}

	return make_color(float(i) / float(max));
}
