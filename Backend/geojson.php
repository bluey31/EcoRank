<?php
/**
 * Created by IntelliJ IDEA.
 * User: xsanda
 * Date: 28/02/2017
 * Time: 06:21
 */

require_once "functions.php";

function newFeature($lat, $long) {
    return [
        "type" => "Feature",
        "geometry" => [
            "type" => "Point",
            "coordinates" => [$long, $lat],
        ],
    ];
}

$features = [];

run_db(function ($db) use ($features) {
    $users = sqlquery($db, "SELECT latitude, longitude FROM Users", [],
        SQL_MULTIPLE);
    foreach ($users as $user) {
        $features[] = newFeature($user['latitude'], $user['longitude']);
    }


    echo 'eqfeed_callback('.json_encode([
        "type" => "FeatureCollection",
        "features" => $features,
    ]).');';
});
