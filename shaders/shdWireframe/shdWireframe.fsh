//
// Simple passthrough fragment shader
//
varying vec4 v_vColour;
uniform vec4 colour;

void main()
{
    gl_FragColor = colour;
}
