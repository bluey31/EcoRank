<?php
/**
 * Created by IntelliJ IDEA.
 * User: xsanda
 * Date: 27/02/2017
 * Time: 17:31
 */
require_once "functions.php";

$username = $_POST['username'];
$password = $_POST['password'];
$lat = json_decode($_POST['lat']);
$long = json_decode($_POST['long']);

if (!$username){
    fail(403,"no username supplied");
}
else if (!$password){
    fail(403,"no password supplied");
}
else if (!is_numeric($lat) || !is_numeric($long)){
    fail(403, "Location is NaN");
}

$salt = newSalt();
$pwhash = hashPassword($password, $salt);


$dbdata = run_db(function($db) use ($username, $pwhash, $lat, $long, $salt) {
    $existingUser = sqlquery($db,"SELECT userId FROM Users WHERE username = :name", ["name" => $username], SQL_SINGLE|SQL_MULTIPLE);
    if (!empty($existingUser)) fail(409, "username already exists");
    $user = sqlquery($db, [
        "INSERT INTO Users (username, password, salt, latitude, longitude, houseClassifier) VALUES (:username, :password, :salt, :lat, :long, 0)",
        "SELECT * FROM Users WHERE username=:username",
    ],
        ["username" => $username, "password" => $pwhash, "lat" => $lat, "long" => $long, "salt" => $salt]);
    do {
        $token = random_bytes(32);
        $tokenTaken = sqlquery($db,"SELECT userId FROM Sessions WHERE token = :token", ["token" => $token], SQL_SINGLE|SQL_MULTIPLE);
    } while(!empty($tokenTaken));
    sqlstmt($db,"INSERT INTO Sessions (userId, token) VALUES (:userId, :token)",
        ["userId" => $user["userId"],"token" => $token]);
    return [
        "userId" => $user["userId"],
        "token" => $token,
    ];
});

echo json_encode($dbdata);
