package main.visualiser.shader;

import java.io.*;
import java.util.ArrayList;

/*

File utility class for reading, writing, deleting and creating files.

 */

public class FileUtility {

    //Returns null if file does not exist
    public static ArrayList<String> readFile (String path) {

        try {

            BufferedReader reader = new BufferedReader(new FileReader(new File(path)));
            ArrayList<String> contents = new ArrayList<String>();

            String data = "";

            while((data = reader.readLine()) != null){
                contents.add(data);
            }

            reader.close();

            return contents;

        }catch(Exception e){

            System.out.println("File not found '" + path + "'");
            return null;

        }

    }

    public static void writeFile (String path, ArrayList<String> contents) {

        if(doesFileExist(path) == false){
            createFile(path);
        }

        File file = new File(path);

        try {

            BufferedWriter writer = new BufferedWriter(new FileWriter(file));

            for(String data : contents){
                writer.write(data);
                writer.newLine();
            }

            writer.close();

        } catch (IOException e) {
            e.printStackTrace();
        }

    }

    //Returns null if cannot
    public static PrintStream getFileWriter(String path){
        File file = new File(path);
        try {
            FileOutputStream stream = new FileOutputStream(file, false);
            return new PrintStream(stream);
        }catch(FileNotFoundException e){
            return null;
        }
    }

    public static boolean doesFileExist(String path){
        return new File(path).exists();
    }

    public static void createFile(String path){
        File file = new File(path);
        try {
            file.createNewFile();
        } catch (IOException e) {
            System.out.println("Could not create file: " + path);
        }
    }

    public static void deleteFile(String path){
        File file = new File(path);
        file.delete();
    }

}
