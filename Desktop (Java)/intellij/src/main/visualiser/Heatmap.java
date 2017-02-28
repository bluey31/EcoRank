package main.visualiser;

import main.visualiser.shader.FragmentShader;
import main.visualiser.shader.GameShader;
import main.visualiser.shader.Shader;
import main.visualiser.shader.VertexShader;
import org.lwjgl.input.Keyboard;
import org.lwjgl.opengl.Display;

import static org.lwjgl.opengl.ARBShaderObjects.glGetUniformLocationARB;
import static org.lwjgl.opengl.ARBShaderObjects.glUniform1fARB;
import static org.lwjgl.opengl.GL11.*;

public class Heatmap extends Visualiser {

    Shader shader;
    int timeID;
    int zoom;
    int zoomx;
    int zoomy;

    float zoomVal = 1;
    float zoomX = 0;
    float zoomY = 0;

    @Override
    public void init() {
        Display.setTitle("Historical Usage Heatmap");

        shader = new Shader(new VertexShader("shaders/test.vert"), new FragmentShader("shaders/test.frag"));
        shader.enable();
        this.timeID = glGetUniformLocationARB(shader.getShaderProgram(), "time");
        this.zoom = glGetUniformLocationARB(shader.getShaderProgram(), "zoom");
        this.zoomx = glGetUniformLocationARB(shader.getShaderProgram(), "xZoom");
        this.zoomy = glGetUniformLocationARB(shader.getShaderProgram(), "yZoom");
        setShaderFloat(timeID, 0);
        setShaderFloat(zoom, 1);
        setShaderFloat(zoomx, 0);
        setShaderFloat(zoomy, 0);
        shader.disable();
    }

    @Override
    public void update() {

        if(Keyboard.isKeyDown(Keyboard.KEY_E)){
            zoomVal *= 0.999f;
        }
        if(Keyboard.isKeyDown(Keyboard.KEY_Q)){
            zoomVal /= 0.999f;
        }

        if(Keyboard.isKeyDown(Keyboard.KEY_A)){
            zoomX -= 0.00001f * zoom;
        }
        if(Keyboard.isKeyDown(Keyboard.KEY_D)){
            zoomX += 0.00001f * zoom;;
        }

        if(Keyboard.isKeyDown(Keyboard.KEY_W)){
            zoomY += 0.00001f * zoom;
        }
        if(Keyboard.isKeyDown(Keyboard.KEY_S)){
            zoomY -= 0.00001f * zoom;;
        }

    }

    float timeVal = 0;

    @Override
    public void render() {

        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

        shader.enable();
        setShaderFloat(timeID, timeVal);
        setShaderFloat(zoom, zoomVal);
        setShaderFloat(zoomx, zoomX);
        setShaderFloat(zoomy, zoomY);
        timeVal += 0.001f;

// set the color of the quad (R,G,B,A)
        glColor3f(0.5f, 0.5f, 1.0f);

// draw quad
        glBegin(GL_QUADS);
        glTexCoord2f(-1, -1);
        glVertex2f(-1, -1);
        glTexCoord2f(1, -1);
        glVertex2f(1, -1);
        glTexCoord2f(1, 1);
        glVertex2f(1, 1);
        glTexCoord2f(-1, 1);
        glVertex2f(-1, 1);
        glEnd();

        shader.disable();

    }
    private void setShaderFloat(int id, float value){
        int location = id;
        glUniform1fARB(location, value);
    }

}
