<?php
/**
 * Created by IntelliJ IDEA.
 * User: lewis
 * Date: 27/02/2017
 * Time: 21:44
 */
require_once "functions.php";
$deviceId = $_GET["id"];
if($deviceId === NULL){
    fail(403,9,"no device id provided");
}
$csv = file("devices.csv");

foreach ($csv as $line){
    $matches = [];
    preg_match('/("?)((?:[^"].*)?)\1,([\d\.]+)\s*/', $line,$matches);
    if($matches[2] == $deviceId) {
        echo json_encode($matches[3]);
        die;
    }
}
fail(404,10,"deviceId not found");