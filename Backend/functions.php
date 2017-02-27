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
