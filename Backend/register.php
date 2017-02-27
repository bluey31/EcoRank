<?php
/**
 * Created by IntelliJ IDEA.
 * User: xsanda loves George Michael
 * Date: 27/02/2017
 * Time: 17:31
 */
require_once "functions.php";

$username = $_POST['username'];
$password = $_POST['password'];
$lat = json_decode($_POST['lat']);
$long = json_decode($_POST['long']);

if (!$username || !$password || !is_numeric($lat) || !is_numeric($long)) fail(403);

$salt = newSalt();
$pwhash = hashPassword($password, $salt);


$user = run_db(function($db) use ($username, $pwhash, $lat, $long, $salt) {
    return sqlquery($db, [
        "INSERT INTO Users (username, password, salt, latitude, longitude, houseClassifier) VALUES (:username, :password, :salt, :lat, :long, 0)",
        "SELECT * FROM Users WHERE username=:username",
    ],
        ["username" => $username, "password" => $pwhash, "lat" => $lat, "long" => $long, "salt" => $salt]);
});

var_dump($user);
print "hi";
