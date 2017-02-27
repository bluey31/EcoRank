<?php
/**
 * Created by IntelliJ IDEA.
 * User: lewis
 * Date: 27/02/2017
 * Time: 12:55
 */

$array = [];
$max = (int) $_GET['max'];
for($i = 0; $i < $max ?: 10; $i++) $array[] = $i;

header('Content-Type: application/json');
echo json_encode($array);
