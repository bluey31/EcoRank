<?php
/**
 * Created by IntelliJ IDEA.
 * User: xsanda
 * Date: 28/02/2017
 * Time: 06:21
 */

require_once "functions.php";

function newFeature($lat, $long, $last_consumption) {
    return [
        "type" => "Feature",
        "properties" => [
            "consumption" => $last_consumption,
        ],
        "geometry" => [
            "type" => "Point",
            "coordinates" => [$long, $lat],
        ],
    ];
}

$features = [];

run_db(function ($db) use ($features) {
    $users = sqlquery($db, "SELECT userId, latitude, longitude FROM Users", [],
        SQL_MULTIPLE);
    foreach ($users as $user) {
        $last_consumption = sqlquery($db,
            "SELECT energyUsed FROM EnergyConsumption
                WHERE userId=:id AND day=(SELECT MAX(day)
                    FROM EnergyConsumption WHERE userId=:id);",
            ['id' => $user['userId']], SQL_SINGLE);
        $features[] = newFeature($user['latitude'], $user['longitude'],
            $last_consumption);
    }


    echo 'eqfeed_callback('.json_encode([
        "type" => "FeatureCollection",
        "features" => $features,
    ]).');';
});
