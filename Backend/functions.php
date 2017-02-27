<?php
/**
 * Created by IntelliJ IDEA.
 * User: xsanda
 * Date: 27/02/2017
 * Time: 16:30
 */
require_once "database_access.php";

header('Content-Type: application/json');

function fail($errorCode = 403) {
    http_response_code($errorCode);
    echo "{}";
    die;
}

function hashPassword($password, $salt){
    $hash = crypt($password, $salt);
    return $hash;
}

function newSalt(){
    echo time();
    $cost = 20;
    $salt = strtr(base64_encode(random_bytes(16)), '+', '.');
    $salt = sprintf("$2a$%02d$", $cost) . $salt;
    echo time();
    return $salt;
}