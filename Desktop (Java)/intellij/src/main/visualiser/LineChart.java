package main.visualiser;

import org.lwjgl.opengl.Display;
import server.Server;
import server.User;
import server.UserHistory;

import java.util.ArrayList;
import static org.lwjgl.opengl.GL11.*;

public class LineChart extends Visualiser {


    String JSON;
    ArrayList<User> database;
    User currentUser;
    int currentID = 0;
    float time = 0;

    ArrayList<LineElement> elements;

    public void locateNewUser(){
        boolean found = false;
        while(!found){
            currentID++;
            if(currentID >= database.size()){
                currentID = 0;
            }
            currentUser = database.get(currentID);
            if(currentUser.isCorrupt() == false){
                found = true;
            }
        }
        if(found){
            elements = new ArrayList<LineElement>();
            long biggestX = 0;
            long shortestX = 0;
            float biggestY = 0;
            float shortestY = 0;
            for(UserHistory history : currentUser.getHistoricalData()){
                if(biggestX == 0 && shortestX == 0){
                    biggestX = history.getDay();
                    shortestX = history.getDay();
                    biggestY = (float)history.getEnergyUsed();
                    shortestY = (float)history.getEnergyUsed();
                }
                if(history.getDay() > biggestX){
                    biggestX = history.getDay();
                }
                if(history.getDay() < shortestX){
                    shortestX = history.getDay();
                }
                if(history.getEnergyUsed() > biggestY){
                    biggestY = (float)history.getEnergyUsed();
                }
                if(history.getEnergyUsed() < shortestY){
                    shortestY = (float)history.getEnergyUsed();
                }
            }
            for(UserHistory history : currentUser.getHistoricalData()){
                long xPos = history.getDay();
                float yPos = (float)history.getEnergyUsed();
                elements.add(new LineElement(
                        (((float)(biggestX - xPos)) / ((float)(biggestX - shortestX))) * 2.0f - 1.0f,
                        -1,
                        ((((float)(biggestY - yPos)) / ((float)(biggestY - shortestY))) * 2.0f - 1.0f)
                ));
            }

        }
    }

    @Override
    public void init() {
        Display.setTitle("Historical Usage Chart");
        database = Server.getUserDatabase();
        locateNewUser();
    }

    @Override
    public void update() {
        time += 0.002f;
        if(time >= 1f){
            locateNewUser();
            time = 0f;
        }
        for(LineElement element : elements){
            element.update(time);
        }


    }

    @Override
    public void render() {

        glColor3f(0, 0, 0);
        glBegin(GL_QUADS);
        glVertex2f(-2, -2);
        glVertex2f(2, -2);
        glVertex2f(2, 2);
        glVertex2f(-2, 2);
        glEnd();


        glColor3f(0.4f, 0.4f, 0.4f);
        glLineWidth(2f);
        glBegin(GL_LINE_STRIP);
        for(LineElement element : elements){
            glVertex2f(element.xPos, element.yPos);
        }
        glEnd();

        glPointSize(4f);
        glColor3f(1f, 1f, 1f);
        glBegin(GL_POINTS);
        for(LineElement element : elements){
            glVertex2f(element.xPos, element.yPos);
        }
        glEnd();

    }
}
