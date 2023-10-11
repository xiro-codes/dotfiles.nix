precision mediump float;

uniform float time;
uniform sampler2D tex;
varying vec2 v_texcoord;

void main() {
	vec4 pixColor = texture2D(tex, v_texcoord);

    pixColor[2] *= sin(time);

    gl_FragColor = pixColor;
}

