<?php
/**
 * Created by IntelliJ IDEA.
 * User: lewis
 * Date: 27/02/2017
 * Time: 23:52
 */
require_once "functions.php";
$day = $_POST["day"];
$id = $_GET["id"];
$energyUsed = $_POST["energyUsed"];

$token = getBearerToken();
if($token === NULL){
    fail(401,1,"no token provided");
}

if(!is_numeric($id)){
    fail(400,7,"non numeric userID");
}
if(!is_numeric($day)){
    fail(400,11,"day value invalid");
}
if(!is_numeric($energyUsed)){
    fail(400,12,"Nope");
}

run_db(function($db) use ($day,$id,$energyUsed,$token){
    $idFromToken = sqlquery($db,"SELECT userId FROM Sessions WHERE token = :token",["token" => $token],SQL_SINGLE);
    if($idFromToken != $id)fail(401,13,"bad auth token for user");
    sqlstmt($db,
        "INSERT INTO EnergyConsumption (userId, day, energyUsed) VALUES (:id,:day,:energyUsed) ",
        ["id"=>$id,"day"=>$day,"energyUsed"=>$energyUsed]
    );
});
