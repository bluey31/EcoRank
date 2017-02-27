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

if (!$username || !$password || !$lat || !$long) fail(403);

//run_db(function($db) use ($username, $password) {
//    $user = sqlquery($db, "SELECT * FROM Users WHERE username=:username",
//        ["username" => $username]);
//    var_dump($user);
//});
//
//print "hi";
