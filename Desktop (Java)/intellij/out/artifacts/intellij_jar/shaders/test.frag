varying vec4 texCoord;
varying vec4 vertColor;

uniform float time, xPos, yPos, zoom;
uniform float redConst, blueConst, greenConst;
uniform float enlarge;

void main(){

    const float maximum = 200;

    float x = 0.0;
    float y = 0.0;

    float x0 = (texCoord.x / zoom) + (xPos * enlarge);
    float y0 = (texCoord.y / zoom) + (yPos * enlarge);

    float realX0 = x0;
    float realY0 = y0;

    float red = abs(sin(realX0));
    float blue = abs(sin(realY0));
    float green = abs(cos(sqrt(realX0*realX0 + realY0*realY0 + time))  * sin(time/((realY0 + 1) * 10)) * cos(realX0));

    gl_FragColor = vec4(red, green, blue, 1.0);

}