<?php
/**
 * Created by IntelliJ IDEA.
 * User: lewis
 * Date: 28/02/2017
 * Time: 00:37
 */
require_once "functions.php";
$token = getBearerToken();
if($token===NULL){
    echo json_encode(false);
    die;
}
run_db(function($db) use ($token){
    $tokenDB = sqlquery($db,"SELECT token FROM Sessions WHERE token = :token",["token"=>$token],SQL_SINGLE);
    if($tokenDB === NULL){
        echo json_encode(false);
    }
    else{
        echo json_encode(true);
    }
});