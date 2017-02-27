package main.visualiser;

import org.lwjgl.LWJGLException;
import org.lwjgl.opengl.Display;
import org.lwjgl.opengl.DisplayMode;


public abstract class Visualiser{

    public abstract void init();
    public abstract void update();
    public abstract void render();


}
