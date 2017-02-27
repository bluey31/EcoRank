package main;

import javax.swing.*;
import java.awt.*;

public class Main extends JPanel {

    public static void main(String[] args){
        JFrame jFrame = new JFrame("EcoRank Admin Portal");
        jFrame.setSize(800, 600);
        jFrame.setVisible(true);
        jFrame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

        jFrame.add(new Main());

    }

    public Main(){
        repaint();
    }

    @Override
    public void paint(Graphics g){
        g.setColor(new Color(76, 147, 227));
        g.fillRect(0, 0, 800/3, 600);
        g.setColor(new Color(167, 221, 100));
        g.fillRect(800/3, 0, 800/3, 600);
        g.setColor(new Color(238, 96, 85));
        g.fillRect(1600/3, 0, 800/3, 600);
        //g.drawString("Wagwarnen", 300, 200);
    }

}
