package main.visualiser.shader;

import org.lwjgl.opengl.ARBFragmentShader;

public class FragmentShader {

    int fragValue;

    public FragmentShader(String source){
        this.fragValue = Shader.createShader(source, ARBFragmentShader.GL_FRAGMENT_SHADER_ARB);
    }

    public int getID(){
        return fragValue;
    }

}
