shader_type canvas_item;
uniform vec3      iResolution;           // viewport resolution (in pixels)
uniform float     iTime;                 // shader playback time (in seconds)
uniform float     iTimeDelta;            // render time (in seconds)
uniform float     iFrameRate;            // shader frame rate
uniform int       iFrame;                // shader playback frame
uniform float     iChannelTime[4];       // channel playback time (in seconds)
uniform vec3      iChannelResolution[4]; // channel resolution (in pixels)
uniform vec4      iMouse;                // mouse pixel coords. xy: current (if MLB down), zw: click
uniform sampler2D iChannel0;		         // input channel. XX = 2D/Cube
uniform sampler2D iChannel1;		         // input channel. XX = 2D/Cube
uniform sampler2D iChannel2;		         // input channel. XX = 2D/Cube
uniform sampler2D iChannel3;		         // input channel. XX = 2D/Cube
uniform vec4      iDate;                 // (year, month, day, time in seconds)

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
}

//modified from https://www.shadertoy.com/view/ltfXWS, tested a few different versions of this same function and this one seemed to have the nicest results
vec4 texture2DAA(sampler2D tex, vec2 uv) {
    vec2 texsize = vec2(textureSize(tex,0));
    vec2 uv_texspace = uv*texsize;
    vec2 seam = floor(uv_texspace+.5);
    uv_texspace = (uv_texspace-seam)/fwidth(uv_texspace)+seam;
    uv_texspace = clamp(uv_texspace, seam-.5, seam+.5);
    return texture(tex, uv_texspace/texsize);
}


void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = fragCoord/iResolution.xx*(sin(iTime*.2)+1.5)-vec2(.5, .5);
    uv *= mat2(vec2(sin(iTime * 0.1), cos(iTime * 0.1)), vec2(-cos(iTime * 0.1), sin(iTime * 0.1)));

    if(fragCoord.x/iResolution.x < .5){
        fragColor = texture2DAA(iChannel0, uv); //anti aliased scaling (iChannel0 is set to "linear" scaling)
    } else {
        fragColor = texture(iChannel1, uv); //nearest neighbor scaling (iChannel1 is set to "nearest" scaling)
    }
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
