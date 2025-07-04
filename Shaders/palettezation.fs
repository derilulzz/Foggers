uniform vec4 colorOriginal[3];
uniform vec4 colorToSet[3];


vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords)
{
    vec4 c = Texel(tex, texture_coords);


    for (int i = 0; i < 3; i++) {
        if (colorOriginal[i] == c) {
            c = colorToSet[i];
        }
    }


    return c;
}