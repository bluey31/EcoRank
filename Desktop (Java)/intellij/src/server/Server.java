package server;

import javax.net.ssl.HttpsURLConnection;
import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.MalformedURLException;
import java.net.ProtocolException;
import java.net.URL;
import java.util.ArrayList;

public class Server {

    final public static String LOGIN_URL = "https://ecorank.xsanda.me/login";
    final static String JSON_URL = "https://ecorank.xsanda.me/users";

    static ArrayList<User> userDatabase;

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
    public static boolean establishConnection(String url) {
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
        //System.out.println("\nSending 'POST' request");
        //System.out.println("Post parameters : " + urlParameters);
        //System.out.println("Response Code : " + responseCode);


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
        //System.out.println("\nSending 'GET' request to " + con.getURL().toString());
        //System.out.println("Response Code : " + responseCode);

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
    public static String getJSON(String extension){
        HttpsURLConnection con = createConnection(JSON_URL + extension);
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

    public static ArrayList<User> getUserDatabase() {
        return userDatabase;
    }

    public static String seekTo(String data, String name){

        int start = 0;
        boolean found = false;
        for(int i = 0; i < data.length(); i++){
            if(data.substring(i, i + name.length()).equals(name)) {
                start = i + name.length();
                found = true;
                break;
            }
        }
        if(found == false){
            return "";
        }

        String output = "";
        for(int i = start; i < data.length(); i++){
            if(data.charAt(i) == ',' || data.charAt(i) == '}'){
                break;
            }
            output += data.charAt(i);

        }
        return output;

    }

    public static UserHistory extractHistory(String data){
        String day = seekTo(data, "day\":");
        String energy = seekTo(data, "energyUsed\":");
        UserHistory history = new UserHistory();
        history.setDay(Long.parseLong(day));
        history.setEnergyUsed(Double.parseDouble(energy));
        return history;
    }

    public static void setHistoricalData(User user, String historicalData){

        for(int i = 0; i < historicalData.length(); i++){
            if(historicalData.charAt(i) == '{'){
                for(int b = i; b < historicalData.length(); b++){
                    if(historicalData.charAt(b) == '}'){
                        user.historicalData.add(extractHistory(historicalData.substring(i + 1, b - 1)));
                        break;
                    }

                }
            }
        }
        if(user.historicalData.size() == 0){
            user.setCorrupt(true);
        }

    }

    public static void setUserData(User user) {
        String accountData = getJSON("/" + user.getUserID());
        String historicalData = getJSON("/" + user.getUserID() + "/consumption");
        try {

            String username = seekTo(accountData, "username\":");
            username = username.substring(1, username.length()-1);

            String longitude = seekTo(accountData, "longitude\":");
            String latitude = seekTo(accountData, "latitude\":");

            if(longitude.equals("") || latitude.equals("")){
                user.setCorrupt(true);
                System.out.printf("User " + user.getUserID() + " is corrupt");
            }else{
                user.setLongitude(Double.parseDouble(seekTo(accountData, "longitude\":")));
                user.setLongitude(Double.parseDouble(seekTo(accountData, "latitude\":")));
                user.setUsername(username);
                user.setCorrupt(false);
            }
        }catch(Exception e){
            user.setCorrupt(true);
            System.out.printf("User " + user.getUserID() + " is corrupt");
        }

        setHistoricalData(user, historicalData);

    }

    public static void initialiseUserDatabase(){
        userDatabase = new ArrayList<User>();
        String userList = getJSON("");
        //System.out.println("User ID List: " + userList);
        int idCurrent = 0;
        for(int i = 0; i < userList.length(); i++){
            if(userList.charAt(i) == '['){
                continue;
            }
            if(userList.charAt(i) == ']' || userList.charAt(i) == ','){
                User u = new User();
                u.setUserID(idCurrent);
                setUserData(u);
                userDatabase.add(u);
                idCurrent = 0;
                System.out.print(".");
                continue;
            }
            idCurrent = (idCurrent * 10) + Integer.parseInt("" + userList.charAt(i));
        }
        System.out.println("Initialised user database");

    }
}
