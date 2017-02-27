<?php
/**
 * Created by IntelliJ IDEA.
 * User: xsanda
 * Date: 27/02/2017
 * Time: 16:16
 */
require_once "functions.php";

$username = $_POST['username'];
$password = $_POST['password'];

if (!$username || !$password) fail(403);

print "hi";
