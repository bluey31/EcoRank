package server;

public class Server {

    public static boolean establishConnection(){
        return true;
    }

    public static ServerAccess attemptLogin(String login, char[] password){
        if(login.equals("admin") && new String(password).equals("admin")){
            return ServerAccess.FULL;
        }
        if(login.equals("user") && new String(password).equals("user")) {
            return ServerAccess.USER;
        }
        return ServerAccess.NONE;
    }

}
