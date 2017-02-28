package main.visualiser;

public class LineElement {

    float xPos;
    float beginYPos;
    float endYPos;
    float yPos;
    float time;

    public LineElement(float xPos, float beginYPos, float endYPos){

        this.xPos = xPos;
        this.beginYPos = beginYPos;
        this.endYPos = endYPos;
        this.yPos = beginYPos;
        this.time = 0;

    }

    public void update(float timeIncrement){
        time = timeIncrement;
        //Change this
        float alpha = (float)Math.sin(time * Math.PI);
        this.yPos = ((1 - alpha) * beginYPos) + (alpha * endYPos);
    }

}
