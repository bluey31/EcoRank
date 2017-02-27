<?php
/**
 * Created by IntelliJ IDEA.
 * User: xsanda
 * Date: 27/02/2017
 * Time: 16:30
 */
require_once "database_access.php";

header('Content-Type: application/json');

function fail($errorCode = 403, $message = "") {
    http_response_code($errorCode);
    echo json_encode(["error"=>$message]);
    die;
}

function hashPassword($password, $salt){
    $hash = crypt($password, $salt);
    return $hash;
}

function newSalt(){
    $cost = 5;
    $salt = strtr(base64_encode(random_bytes(16)), '+', '.');
    $salt = sprintf("$2a$%02d$", $cost) . $salt;
    return $salt;
}

/**
 * Get header Authorization ( http://stackoverflow.com/a/40582472/2275559 )
 * */
function getAuthorizationHeader(){
    $headers = null;
    if (isset($_SERVER['Authorization'])) {
        $headers = trim($_SERVER["Authorization"]);
    }
    else if (isset($_SERVER['HTTP_AUTHORIZATION'])) { //Nginx or fast CGI
        $headers = trim($_SERVER["HTTP_AUTHORIZATION"]);
    } elseif (function_exists('apache_request_headers')) {
        $requestHeaders = apache_request_headers();
        // Server-side fix for bug in old Android versions (a nice side-effect of this fix means we don't care about capitalization for Authorization)
        $requestHeaders = array_combine(array_map('ucwords', array_keys($requestHeaders)), array_values($requestHeaders));
        //print_r($requestHeaders);
        if (isset($requestHeaders['Authorization'])) {
            $headers = trim($requestHeaders['Authorization']);
        }
    }
    return $headers;
}
/**
 * get access token from header ( http://stackoverflow.com/a/40582472/2275559 )
 * */
function getBearerToken() {
    $headers = getAuthorizationHeader();
    // HEADER: Get the access token from the header
    if (!empty($headers)) {
        if (preg_match('/Bearer\s(\S+)/', $headers, $matches)) {
            return $matches[1];
        }
    }
    return null;
}
