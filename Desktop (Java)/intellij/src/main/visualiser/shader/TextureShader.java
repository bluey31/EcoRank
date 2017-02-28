package main.visualiser.shader;

import static org.lwjgl.opengl.ARBShaderObjects.glGetUniformLocationARB;
import static org.lwjgl.opengl.ARBShaderObjects.glUniform1iARB;
import static org.lwjgl.opengl.GL13.GL_TEXTURE0;
import static org.lwjgl.opengl.GL13.glActiveTexture;

public class TextureShader extends Shader {

    String sampler2DName;
    int samplerID;

    public TextureShader(int program, String sampler2DName) {
        super(program);
        init(sampler2DName);
    }
    public TextureShader(VertexShader vertex, FragmentShader frag, String sampler2DName) {
        super(vertex, frag);
        init(sampler2DName);
    }

    public void init(String sampler2DName){
        this.sampler2DName = sampler2DName;
        this.samplerID = glGetUniformLocationARB(this.getShaderProgram(), sampler2DName);
    }

    @Override
    public void bindTexture(int texture) {
        //glEnable(GL_TEXTURE_2D);
        glActiveTexture(GL_TEXTURE0 + texture);
        glUniform1iARB(this.samplerID, texture);
        super.bindTexture(texture);
    }

    @Override
    public void unBindTexture(int texture) {
        super.unBindTexture(texture);
        glActiveTexture(GL_TEXTURE0);
    }
}
