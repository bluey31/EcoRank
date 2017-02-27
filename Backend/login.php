<?php
/**
 * Created by IntelliJ IDEA.
 * User: xsanda
 * Date: 27/02/2017
 * Time: 16:16
 */
require_once "functions.php";

$username = $_POST['username'];
$password = $_POST['password'];

if (!$username){
    fail(403,2,"no username supplied");
}
else if (!$password){
    fail(403,3,"no password supplied");
}
$dbdata = run_db(function($db) use ($username, $password) {
    $user = sqlquery($db,"SELECT * FROM Users WHERE  username = :name", ["name" => $username]);
    if($user === false) fail(401,4,"incorrect username or password");
    if(!password_verify($password,$user["password"])) fail(401,4,"incorrect username or password");
    do {
        $token = strtr(base64_encode(random_bytes(32)), '+', '.');
        $tokenTaken = sqlquery($db,"SELECT userId FROM Sessions WHERE token = :token", ["token" => $token], SQL_SINGLE|SQL_MULTIPLE);
    } while(!empty($tokenTaken));
    sqlstmt($db,"INSERT INTO Sessions (userId, token) VALUES (:userId, :token)",
        ["userId" => $user["userId"],"token" => $token]);
    return [
        "userId" => $user["userId"],
        "token" => $token,
    ];
});

echo json_encode($dbdata) . PHP_EOL;
