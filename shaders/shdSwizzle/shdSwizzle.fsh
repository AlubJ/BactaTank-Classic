//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform bool uFlipGreen;

void main()
{
	vec4 col = texture2D( gm_BaseTexture, v_vTexcoord ).agbr;
	
	if (uFlipGreen)
	{
		col.g = 1.0 - col.g;
	}
	
    gl_FragColor = col;
}
