varying vec4 texCoord;
varying vec4 vertColor;

uniform float time;
uniform float zoom;
uniform float xZoom;
uniform float yZoom;

void main(){

    float x = texCoord.x * (4.0 / 3.0) * zoom + xZoom;
    float y = texCoord.y * zoom + yZoom;

    float amount = 100.0;
    float stop = 0.0;

    float xPos = x;
    float yPos = y;

    for(float i = 0.0; i < amount; i++){
        stop = i;
        if(xPos*xPos + yPos*yPos > 4.0){
            break;
        }

        float xTemp = xPos*xPos - yPos*yPos + x;
        float yTemp = 2.0 * xPos * yPos + y;
        xPos = xTemp;
        yPos = yTemp;
    }


    float red = mod(stop, mod(time, 12.0)) / mod(time, 12.0);
    float green = mod(stop, mod(time + 23.0, 40.0)) / mod(time + 23.0, 40.0);
    float blue = mod(stop, mod(time + 2.0, 7.0)) / mod(time + 2.0, 7.0);

    gl_FragColor = vec4(red, green, blue, 1.0);

}
