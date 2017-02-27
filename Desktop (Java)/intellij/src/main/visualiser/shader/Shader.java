package main.visualiser.shader;

import org.lwjgl.opengl.ARBShaderObjects;
import org.lwjgl.opengl.GL11;

import java.util.ArrayList;

import static org.lwjgl.opengl.GL11.GL_TEXTURE_2D;
import static org.lwjgl.opengl.GL11.glBindTexture;

public class Shader {

    int shaderProgram;

    public Shader(int program){
        this.shaderProgram = program;
    }

    public Shader(VertexShader vertex, FragmentShader frag){

        shaderProgram = ARBShaderObjects.glCreateProgramObjectARB();
        ARBShaderObjects.glAttachObjectARB(shaderProgram, vertex.getID());
        ARBShaderObjects.glAttachObjectARB(shaderProgram, frag.getID());
        ARBShaderObjects.glLinkProgramARB(shaderProgram);
        if (ARBShaderObjects.glGetObjectParameteriARB(shaderProgram, ARBShaderObjects.GL_OBJECT_LINK_STATUS_ARB) == GL11.GL_FALSE) {
            System.out.println("Shader failed to link");
        }
        ARBShaderObjects.glValidateProgramARB(shaderProgram);
        if (ARBShaderObjects.glGetObjectParameteriARB(shaderProgram, ARBShaderObjects.GL_OBJECT_VALIDATE_STATUS_ARB) == GL11.GL_FALSE) {
            System.out.println("Shader failed to validate");
        }

    }

    public void enable(){
        ARBShaderObjects.glUseProgramObjectARB(shaderProgram);
    }
    public void disable(){
        ARBShaderObjects.glUseProgramObjectARB(0);
    }

    //Ripped from LWJGL shader tutorial
    //Does not resolve errors when reading. Shaders must have no source errors.
    public static int createShader(String filename, int shaderType){

        //Section 1, reads source code from the file
        ArrayList<String> sourceCode = FileUtility.readFile(filename);
        StringBuilder builder = new StringBuilder();
        for(String string : sourceCode){
            builder.append(string);
            builder.append("\n");
        }
        String code = builder.toString();

        //Section 2, compiles source into the graphics card
        int id = ARBShaderObjects.glCreateShaderObjectARB(shaderType); //Creates space for the shader in memory (I think)
        ARBShaderObjects.glShaderSourceARB(id, code);
        ARBShaderObjects.glCompileShaderARB(id);

        if (ARBShaderObjects.glGetObjectParameteriARB(id, ARBShaderObjects.GL_OBJECT_COMPILE_STATUS_ARB) == GL11.GL_FALSE) {
            String output = ARBShaderObjects.glGetInfoLogARB(id, ARBShaderObjects.GL_OBJECT_INFO_LOG_LENGTH_ARB);

            OutputUtility.outputLine("-SHADER ERROR-");
            OutputUtility.increment();
            OutputUtility.outputLine("Problem: shader did not compile");
            OutputUtility.outputLine("Shader path: '" + filename + "'");
            OutputUtility.outputLine("Shader Type: " + shaderType);
            OutputUtility.outputLine("Log: " + output);
            OutputUtility.deincrement();

            ARBShaderObjects.glDeleteObjectARB(id);

            return 0;

        }

        return id;

    }

    public void bindTexture(int texture){
        glBindTexture(GL_TEXTURE_2D, texture);
    }
    public void unBindTexture(int texture){
        glBindTexture(GL_TEXTURE_2D, 0);
    }

    public int getShaderProgram() {
        return shaderProgram;
    }
}
