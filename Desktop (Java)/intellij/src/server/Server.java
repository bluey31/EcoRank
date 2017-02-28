package server;

import javax.net.ssl.HttpsURLConnection;
import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.MalformedURLException;
import java.net.ProtocolException;
import java.net.URL;

public class Server {

    final public static String LOGIN_URL = "https://ecorank.xsanda.me/login";
    final static String JSON_URL = "https://ecorank.xsanda.me/users";

    public static HttpsURLConnection createConnection(String url){

        URL obj = null;
        try {
            obj = new URL(url);
        } catch (MalformedURLException e) {
            e.printStackTrace();
            return null;
        }

        HttpsURLConnection con;
        try {
            con = (HttpsURLConnection) obj.openConnection();
        } catch (IOException e) {
            e.printStackTrace();
            return null;
        }


        return con;
    }

    public static boolean establishConnection(String url){
        HttpsURLConnection connection = createConnection(url);
        return (connection != null);
    }


    public static String sendPOST(HttpsURLConnection con, String params) throws Exception {
        con.setRequestMethod("POST");
        con.setRequestProperty("User-Agent", "");
        con.setRequestProperty("Accept-Language", "en-US,en;q=0.5");
        String urlParameters = params;


        // Send post request
        con.setDoOutput(true);
        DataOutputStream wr = new DataOutputStream(con.getOutputStream());
        wr.writeBytes(urlParameters);
        wr.flush();
        wr.close();

        int responseCode = con.getResponseCode();
        System.out.println("\nSending 'POST' request");
        System.out.println("Post parameters : " + urlParameters);
        System.out.println("Response Code : " + responseCode);


        if(responseCode == 200){



            BufferedReader in = new BufferedReader(
                    new InputStreamReader(con.getInputStream()));
            String inputLine;
            StringBuffer response = new StringBuffer();

            while ((inputLine = in.readLine()) != null) {
                response.append(inputLine);
            }
            in.close();

            return response.toString();

        }else{
            System.out.println("Connection POST Error");
            return "";
        }

    }
    public static String sendGET(HttpsURLConnection con) throws Exception{
        // optional default is GET
        con.setRequestMethod("GET");

        //add request header
        con.setRequestProperty("User-Agent", "");

        int responseCode = con.getResponseCode();
        System.out.println("\nSending 'GET' request");
        System.out.println("Response Code : " + responseCode);

        BufferedReader in = new BufferedReader(
                new InputStreamReader(con.getInputStream()));
        String inputLine;
        StringBuffer response = new StringBuffer();

        while ((inputLine = in.readLine()) != null) {
            response.append(inputLine);
        }
        in.close();

        //print result
        return response.toString();
    }

    public static String getJSON(){
        HttpsURLConnection con = createConnection(JSON_URL);
        if(con == null){
            System.out.println("JSON Connection error");
            return "";
        }
        try {
            String JSON = sendGET(con);
            return JSON;
        } catch (Exception e) {
            System.out.println("JSON Reading error");
            return "";

        }
    }

    public static ServerAccess attemptLogin(String login, char[] password){

        HttpsURLConnection con = createConnection(LOGIN_URL);
        if(con == null){
            return ServerAccess.NONE;
        }
        try {
            String response = sendPOST(con, "username=" + login + "&password=" + new String(password));
            System.out.println("Server Response: " + response);
            return ServerAccess.FULL;
        } catch (Exception e) {
            e.printStackTrace();
            return ServerAccess.NONE;
        }


        //print result
        /*
        if(login.equals("admin") && new String(password).equals("admin")){
            return ServerAccess.FULL;
        }
        if(login.equals("user") && new String(password).equals("user")) {
            return ServerAccess.USER;
        }
        return ServerAccess.NONE;
        */

        //Position
    }

}
