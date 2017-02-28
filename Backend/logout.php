<?php
/**
 * Created by IntelliJ IDEA.
 * User: lewis
 * Date: 27/02/2017
 * Time: 20:31
 */
require_once "functions.php";

$token = getBearerToken();
if($token === NULL){
    fail(401,1,"no token provided");
}
run_db(function($db) use ($token) {
    $userId = sqlquery($db,"SELECT userId FROM Sessions WHERE  token = :token", ["token" => $token],SQL_SINGLE);
    if($userId === null) return;
    sqlstmt($db,"DELETE FROM Sessions WHERE token = :token",["token"=>$token]);
});