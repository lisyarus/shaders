vec4 color ( )
{
	float r = sin(length(position) * 30.0 - time * 7.0);
	float g = sin(atan(position.y, position.x) * 6.0 + time * 10.0) * r;
	float b = -g;
	return vec4(r, g, b, 1.0);
}
