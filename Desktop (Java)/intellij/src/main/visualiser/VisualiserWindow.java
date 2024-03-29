package main.visualiser;

import org.lwjgl.LWJGLException;
import org.lwjgl.opengl.*;

public class VisualiserWindow implements Runnable{

    protected boolean open = false;
    protected Visualiser vis;
    Thread thread;

    public VisualiserWindow(Visualiser vis){
        this.vis = vis;
    }

    boolean isOpen(){
        return open;
    }

    public void open(){

        this.open = true;
        this.thread = new Thread(this);
        this.thread.start();

    }
    public void close(){

        this.open = false;

    }

    @Override
    public void run() {


        try {
            Display.setDisplayMode(new DisplayMode(800,600));
            Display.create();
        } catch (LWJGLException e) {
            e.printStackTrace();
        }

        GL11.glMatrixMode(GL11.GL_PROJECTION);
        GL11.glLoadIdentity();
        GL11.glOrtho(-1, 1, -1, 1, 1, -1);
        GL11.glMatrixMode(GL11.GL_MODELVIEW);

        vis.init();

        while(this.open == true && Display.isCloseRequested() == false){
            Display.update();
            vis.update();
            vis.render();
            try {
                thread.sleep(16);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }

        Display.destroy();

    }
}
