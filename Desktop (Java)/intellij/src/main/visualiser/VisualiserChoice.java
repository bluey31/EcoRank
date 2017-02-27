package main.visualiser;

import main.Main;
import server.ServerAccess;

import javax.swing.*;
import java.awt.*;

public class VisualiserChoice extends JFrame {

    /**
     * Creates new form VisualiserWindow
     */

    public static void openChoices(ServerAccess access){
        VisualiserChoice choice = new VisualiserChoice(access);

        Dimension dim = Toolkit.getDefaultToolkit().getScreenSize();
        choice.setLocation((int)dim.getWidth()/2 - choice.getWidth()/2, (int)dim.getHeight()/2 - choice.getHeight()/2);
        choice.setVisible(true);

    }

    ServerAccess access;
    VisualiserWindow heatmap;
    VisualiserWindow lineChart;

    public VisualiserChoice(ServerAccess access) {
        this.access = access;
        this.heatmap = new VisualiserWindow(new Heatmap());
        this.lineChart = new VisualiserWindow(new LineChart());
        initComponents();
    }

    // Variables declaration - do not modify
    private javax.swing.JButton jButton2;
    private javax.swing.JButton jButton3;
    private javax.swing.JButton jButton5;
    private javax.swing.JLabel jLabel1;
    // End of variables declaration

    /**
     * This method is called from within the constructor to initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is always
     * regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">
    private void initComponents() {

        jButton2 = new javax.swing.JButton();
        jButton3 = new javax.swing.JButton();
        jButton5 = new javax.swing.JButton();
        jLabel1 = new javax.swing.JLabel();

        setDefaultCloseOperation(javax.swing.WindowConstants.EXIT_ON_CLOSE);

        jButton2.setText("View Heatmap");
        jButton2.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton2ActionPerformed(evt);
            }
        });

        jButton3.setText("View History");
        jButton3.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton3ActionPerformed(evt);
            }
        });

        jButton5.setText("Logout");
        jButton5.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton5ActionPerformed(evt);
            }
        });

        if(access == ServerAccess.FULL){
            jLabel1.setText("Connected as Admin");
        }
        if(access == ServerAccess.USER){
            jLabel1.setText("Connected as User");
        }

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(getContentPane());
        getContentPane().setLayout(layout);
        layout.setHorizontalGroup(
                layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                        .addGroup(layout.createSequentialGroup()
                                .addContainerGap()
                                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                                        .addComponent(jButton5)
                                        .addComponent(jLabel1, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                                        .addComponent(jButton2, javax.swing.GroupLayout.DEFAULT_SIZE, 108, Short.MAX_VALUE)
                                        .addComponent(jButton3, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );
        layout.setVerticalGroup(
                layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                        .addGroup(layout.createSequentialGroup()
                                .addContainerGap()
                                .addComponent(jLabel1)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jButton2)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jButton3)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                .addComponent(jButton5)
                                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );

        pack();
    }// </editor-fold>

    private void jButton2ActionPerformed(java.awt.event.ActionEvent evt) {
        if(heatmap.isOpen()){
            return;
        }
        if(lineChart.isOpen()){
            lineChart.close();
        }
        heatmap.open();
    }

    private void jButton3ActionPerformed(java.awt.event.ActionEvent evt) {
        if(lineChart.isOpen()){
            return;
        }
        if(heatmap.isOpen()){
            heatmap.close();
        }
        lineChart.open();
    }

    private void jButton5ActionPerformed(java.awt.event.ActionEvent evt) {
        this.setVisible(false);
        Main.main(null);
    }




}
