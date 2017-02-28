package server;

import java.util.ArrayList;

public class User {

    String username;
    int userID;
    double longitude, latitude;
    ArrayList<UserHistory> historicalData;
    boolean corrupt;

    public User(){
        historicalData = new ArrayList<UserHistory>();
    }

    public int getUserID() {
        return userID;
    }

    public boolean isCorrupt() {
        return corrupt;
    }

    public void setCorrupt(boolean corrupt) {
        this.corrupt = corrupt;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public void setLongitude(double longitude) {
        this.longitude = longitude;
    }

    public void setLatitude(double latitude) {
        this.latitude = latitude;
    }

    public String getUsername() {
        return username;
    }

    public double getLongitude() {
        return longitude;
    }

    public double getLatitude() {
        return latitude;
    }

    public ArrayList<UserHistory> getHistoricalData() {
        return historicalData;
    }
}
