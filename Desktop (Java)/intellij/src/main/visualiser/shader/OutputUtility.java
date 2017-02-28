package main.visualiser.shader;

import java.io.PrintStream;
import java.util.ArrayList;

public class OutputUtility {

    final static int TAB_LENGTH = 5;
    static int currentTab = 0;
    static ArrayList<PrintStream> streams;

    public static void increment(){
        currentTab += 1;
    }

    public static void deincrement(){
        currentTab -= 1;
        if(currentTab < 0){
            currentTab = 0;
        }
    }

    public static void outputLine(String line){
        String finalLine = "";
        for(int i = 0; i < currentTab; i++){
            finalLine += "\t";
        }
        finalLine += line;
        output(finalLine);
    }
    private static void output(String line){
        for(PrintStream stream : getStreams()){
            stream.println(line);
        }
    }
    private static void createStreams(){
        streams = new ArrayList<PrintStream>();
        streams.add(System.out);
    }
    
    public static ArrayList<PrintStream> getStreams(){
        if(streams == null){
            createStreams();
        }
        return streams;
    }
    public static void close(){
    	for(PrintStream stream : getStreams()){
    		stream.close();
    	}
    }
}
