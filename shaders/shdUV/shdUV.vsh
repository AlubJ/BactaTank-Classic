//
// Simple passthrough vertex shader
//
//attribute vec3 in_Position;                  // (x,y,z)
//attribute vec3 in_Normal;                  // (x,y,z)     unused in this shader.
//attribute vec4 in_Colour;                    // (r,g,b,a)
attribute vec2 in_TextureCoord;              // (u,v)

varying vec2 v_vTexcoord;
varying vec4 v_vColour;

void main()
{
    vec3 object_space_pos = vec3(in_TextureCoord, 0.0);
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * vec4(object_space_pos, 1.0);
    
    v_vColour = vec4(1.0);
    v_vTexcoord = in_TextureCoord;
}
