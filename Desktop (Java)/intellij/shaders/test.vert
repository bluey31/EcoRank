varying vec4 texCoord;
varying vec4 vertColor;

void main (){
    gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
    texCoord = gl_MultiTexCoord0;
    vertColor = gl_Color;
}