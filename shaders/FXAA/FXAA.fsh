//
// Fast Approximate Anti-Aliasing
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec2 u_texel;
uniform float u_strength;

void main()
{
    float reducemul = 1.0 / 8.0;
    float reducemin = 1.0 / 128.0;
    
    vec3 basecol = texture2D(gm_BaseTexture, v_vTexcoord).rgb;
    vec3 baseNW = texture2D(gm_BaseTexture, v_vTexcoord - u_texel).rgb;
    vec3 baseNE = texture2D(gm_BaseTexture, v_vTexcoord + vec2(u_texel.x, -u_texel.y)).rgb;
    vec3 baseSW = texture2D(gm_BaseTexture, v_vTexcoord + vec2(-u_texel.x, u_texel.y)).rgb;
    vec3 baseSE = texture2D(gm_BaseTexture, v_vTexcoord + u_texel).rgb;
    
    vec3 gray = vec3(0.299, 0.587, 0.114);
    float monocol = dot(basecol, gray);
    float monoNW = dot(baseNW, gray);
    float monoNE = dot(baseNE, gray);
    float monoSW = dot(baseSW, gray);
    float monoSE = dot(baseSE, gray);
    
    float monomin = min(monocol, min(min(monoNW, monoNE), min(monoSW, monoSE)));
    float monomax = max(monocol, max(max(monoNW, monoNE), max(monoSW, monoSE)));
    
    vec2 dir = vec2(-((monoNW + monoNE) - (monoSW + monoSE)), ((monoNW + monoSW) - (monoNE + monoSE)));
    float dirreduce = max((monoNW + monoNE + monoSW + monoSE) * reducemul * 0.25, reducemin);
    float dirmin = 1.0 / (min(abs(dir.x), abs(dir.y)) + dirreduce);
    dir = min(vec2(u_strength), max(vec2(-u_strength), dir * dirmin)) * u_texel;
    
    vec4 resultA = 0.5 * (texture2D(gm_BaseTexture, v_vTexcoord + dir * -0.166667) +
                          texture2D(gm_BaseTexture, v_vTexcoord + dir * 0.166667));
    vec4 resultB = resultA * 0.5 + 0.25 * (texture2D(gm_BaseTexture, v_vTexcoord + dir * -0.5) +
                                           texture2D(gm_BaseTexture, v_vTexcoord + dir * 0.5));
    float monoB = dot(resultB.rgb, gray);
    
    if(monoB < monomin || monoB > monomax) {
        gl_FragColor = resultA * v_vColour;
    } else {
        gl_FragColor = resultB * v_vColour;
    }
}