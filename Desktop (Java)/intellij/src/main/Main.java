package main;

import login.LoginWindow;
import main.visualiser.Heatmap;
import main.visualiser.Visualiser;
import main.visualiser.VisualiserChoice;
import main.visualiser.VisualiserWindow;
import server.Server;
import server.ServerAccess;

import javax.swing.*;
import java.awt.*;

public class Main {

    static ServerAccess access;

    public static void main(String[] args){

        boolean connection = Server.establishConnection(Server.LOGIN_URL);
        System.out.println("Connection established: " + connection);
        if(!connection){
            JOptionPane.showMessageDialog(new JFrame(), "Connection failed");
            System.exit(0);
        }

        LoginWindow.createLoginWindow();

        //VisualiserWindow window = new VisualiserWindow(new Heatmap());
        //window.open();

    }

    public static boolean attemptLogin(String username, char[] password){

        String pass = new String(password);

        System.out.println("Attempting Login: " + username + " " + pass);
        access = Server.attemptLogin(username, password);

        if(access == ServerAccess.NONE){
            return false;
        }

        return true;

    }

    public static void login(){

        System.out.println("Server Access: " + access);
        VisualiserChoice.openChoices(access);


    }

    /*

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
    */

}
