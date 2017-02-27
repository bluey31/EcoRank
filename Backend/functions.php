<?php
/**
 * Created by IntelliJ IDEA.
 * User: xsanda
 * Date: 27/02/2017
 * Time: 16:30
 */
require_once "database_access.php";

header('Content-Type: application/json');

function fail($errorCode = 403) {
    http_response_code($errorCode);
    echo "{}";
    die;
}
