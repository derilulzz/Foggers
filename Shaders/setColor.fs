uniform vec4 colorToSet = vec4(0.0, 0.0, 0.0, 1.0);


vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords)
{
    vec4 c = Texel(tex, texture_coords);
    return vec4(colorToSet.r, colorToSet.g, colorToSet.b, colorToSet.a * c.a);
}