extern vec2 pixelsize;
extern float size;
extern float smoothness;

vec4 effect(vec4 color, Image texture, vec2 uv, vec2 fc) {
    float alpha = Texel(texture, uv).a;
    float outline = 0.0;

    // Sample in a cross pattern (reduces lookups)
    outline += Texel(texture, uv + vec2(-size, 0) * pixelsize).a;
    outline += Texel(texture, uv + vec2(size, 0) * pixelsize).a;
    outline += Texel(texture, uv + vec2(0, -size) * pixelsize).a;
    outline += Texel(texture, uv + vec2(0, size) * pixelsize).a;

    // Normalize and smooth
    outline = smoothstep(0.0, smoothness, outline);

    // Keep original texture color but modify alpha for outline effect
    return vec4(color.rgb, max(alpha, outline));
}
