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

        for(int i = 0; i < 4; i++){
            alpha += (float)Math.sin(time * Math.PI * (3 + i*2))/(3f + i*2);

        }


        this.yPos = ((1 - alpha) * beginYPos) + (alpha * endYPos);
    }

}
