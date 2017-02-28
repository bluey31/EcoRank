<?php
/**
 * Created by IntelliJ IDEA.
 * User: lewis
 * Date: 27/02/2017
 * Time: 21:09
 */
require_once "functions.php";
$id = $_GET["id"];
if(!is_numeric($id)){
    fail(400,7,"non numeric userID");
}
echo json_encode(run_db(function($db) use ($id) {
    $user = sqlquery($db,
        "SELECT username,longitude,latitude FROM Users where userId= :id",["id"=>$id]
    );
    if($user === false)fail(404,8,"no user in database");
    return $user;
}));