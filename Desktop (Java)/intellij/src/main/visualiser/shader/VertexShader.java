package main.visualiser.shader;

import org.lwjgl.opengl.ARBVertexShader;

public class VertexShader {

    int vertValue;

    public VertexShader(String source){
        this.vertValue = Shader.createShader(source, ARBVertexShader.GL_VERTEX_SHADER_ARB);
    }

    public int getID(){
        return vertValue;
    }


}
