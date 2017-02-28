<?php
/**
 * Created by IntelliJ IDEA.
 * User: lewis
 * Date: 28/02/2017
 * Time: 00:51
 */
require_once "functions.php";
$day = json_decode(@$_GET["day"]);
$id = $_GET["id"];

if(!is_numeric($id)){
    fail(400,7,"non numeric userID");
}

run_db(function($db) use ($day,$id){
    if(is_array($day)) {
        $return = [];
        foreach ($day as $d) $return[] = dayConsumption($db, $d, $id);
        echo json_encode($return);
    }
    else if (is_numeric($day)) {
        echo json_encode(dayConsumption($db,$day,$id));
    } else echo json_encode(sqlquery($db,
        "SELECT day, energyUsed FROM EnergyConsumption WHERE userId = :id", ["id"=>$id], SQL_MULTIPLE));
});

function dayConsumption($db,$day,$id){
    return sqlquery($db,"SELECT energyUsed FROM EnergyConsumption WHERE day =:day AND userId = :id",
        ["day"=> $day, "id"=>$id],SQL_SINGLE);
}