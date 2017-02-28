<?php
/**
 * Created by IntelliJ IDEA.
 * User: xsanda
 * Date: 28/02/2017
 * Time: 07:47
 */
require_once "functions.php";

echo json_encode(run_db(function($db){
    return sqlquery($db,
        "SELECT a.userId as userId, energyUsed from EnergyConsumption as a
          INNER JOIN (
            SELECT userId, MAX(day) as day
            FROM EnergyConsumption
            GROUP BY userId
          ) as b ON a.userID = b.userId AND a.day = b.day",
        [],
        SQL_MULTIPLE);
}));
