<?php
/**
 * Created by IntelliJ IDEA.
 * User: lewis is the best
 * Date: 27/02/2017
 * Time: 12:55
 */

$array = [];
$max = array_key_exists('max', $_GET) ? $_GET['max'] : 10;
for($i = 0; $i < $max; $i++) $array[] = $i;

header('Content-Type: application/json');
echo json_encode($array);
