<?php
/**
 * Created by IntelliJ IDEA.
 * User: lewis
 * Date: 27/02/2017
 * Time: 20:59
 */
require_once "functions.php";

echo json_encode(run_db(function($db){
    return sqlquery($db,"SELECT userId from Users",[],SQL_SINGLE|SQL_MULTIPLE);
}));