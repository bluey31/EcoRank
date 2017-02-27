<?php
/**
 * Created by IntelliJ IDEA.
 * User: xsanda
 * Date: 27/02/2017
 * Time: 16:07
 */

define("SQL_MULTIPLE",0b1);
define("SQL_SINGLE", 0b10);

/**
 * Executes one or more SQL statements.
 *
 * This function produces a prepared statement, populates it with the variables from the `$values` array, then executes it. If `$sql` contains an array of statements, rather than just one, each of these is run in turn.
 *
 * @param \SQLite3 $db This is a reference to an open database, in which the commands are executed.
 *
 * @param string|string[] $sql This is the statement or statements to be executed.
 *
 * @param array $values This is an optional array of values to insert into the prepared statement(s). The values in this array will be inserted wherever their key appears in a string in `$sql` preceded by a colon.
 */
function sqlstmt($db, $sql, $values=[]) {
    # Determine whether $sql is an array
    $multistatement = is_array($sql);

    # If it is, then…
    if ($multistatement) {
        # Iterate over each statement, and…
        foreach ($sql as $line) {
            # Run each line as a separate statement
            sqlstmt($db, $line, $values);
        }
        # Otherwise…
    } else {
        while (true) {
            try {
                # Produce a prepared statement
                $query = $db->prepare($sql);

                # Bind each value in the $values array to the prepared statement
                foreach ($values as $var => $val) {
                    $query->bindValue(":$var", $val);
                }

                # Execute the statement
                $query->execute();
                break;
            } catch (SQLite3Exception $e) {
                if ($e->getCode() != 5) throw $e;
            }
        }


        # Close the prepared statement
        $query->close();
    }
}

/**
 * Executes an SQL query, optionally preceded by one or more SQL statements.
 *
 * This function produces a prepared query, populates it with the variables from the `$values` array, then executes it and returns the results. If `$sql` contains an array, rather than just a string, each of the strings is executed as a statement, and then the final string is executed as a query.
 *
 * @param \SQLite3 $db This is a reference to an open database, in which the commands are executed.
 *
 * @param string|string[] $sql This is the query, or statements followed by a query, to be executed.
 *
 * @param array $values This is an optional array of values to insert into the prepared query (and statements). The values in this array will be inserted wherever their key appears in a string in `$sql` preceded by a colon.
 *
 * @param int $flags This is an integer produced by combining the following flags: `SQL_MULTIPLE` will return an array of database rows, rather than a single row. `SQL_SINGLE` will return a single cell, used when only one column is requested. When both are used in conjunction (`SQL_MULTIPLE|SQL_SINGLE`), an array of cells in from a single column is returned.
 *
 * @retval mixed[]|mixed[][]|mixed By default this function will return an array representing a row in the database. However, this can be changed by the `$flags` argument: see above for details.
 */
function sqlquery($db, $sql, $values=[],$flags=0) {
    # If $values is not an array, treat it as the flags
    if (!is_array($values)) {
        $flags = $values;
        $values = [];
    }

    # Check for flags
    $multiple = !!($flags & SQL_MULTIPLE);
    $single = !!($flags & SQL_SINGLE);

    # Determine whether $sql is an array
    $multistatement = is_array($sql);

    # If it is, then…
    if ($multistatement) {
        # Run each statement but the last
        sqlstmt($db, array_slice($sql,0,-1), $values);

        # And set the final query as the one to be run
        $sql = end($sql);
    }

    try {
        # Produce a prepared statement
        $query = @$db->prepare($sql);

        # Log the query on error
        if ($db->lastErrorCode())
            throw new SQLite3Exception($db, $sql);

        # Bind each value in the $values array to the prepared statement
        foreach ($values as $var => $val)
            $query->bindValue(":$var", $val);

        # Execute the query
        $exec = $query->execute();

        # Log the query on error
        if ($db->lastErrorCode())
            throw new SQLite3Exception($db, $sql);

        # If the $multiple flag is set, then…
        if ($multiple) {
            # Fetch each row (cell if $single is set) into an array
            $result = [];

            while ($next = $exec->fetchArray(SQLITE3_ASSOC)) {
                $result[] = $single ? $next[0] : $next;
            }
        } else {
            # Fetch the first row (cell if $single is set)
            $result = $exec->fetchArray(SQLITE3_ASSOC);
            if ($single) $result = $result[0];
        }
    } catch (Exception $e) {
        throw $e;
    } finally {
        # Close the prepared query
        if (@$query) $query->close();
    }

    # Return the row, cell or array of rows or cells
    return $result;
}

/**
 * Provides a wrapper for database operations.
 *
 * This function opens the SQLite3 database file, ensures that the relevant tables and settings exist, runs the code block passed in `$function`, then closes the database.
 *
 * @param callable $function This is a code block that is called with the parameter `$db`, so that the database can be interacted with. In order to access variables from the calling scope, use `use`: `run_db(function($db) use (&$var) {…});`
 *
 * @retval mixed Returns the return value of the `$function` parameter.
 */
function run_db($function) {
    static $build_check;

    # Open the database for editing
    try {
        $db = new SQLite3("../db/database.db");
    } catch (Exception $e) {
        $build_check = false;
        error_log("SQL opening error: $e at ".__FILE__.":".__LINE__);
        return;
    }

    # If the database has not yet been built for the PHP instance, build it (create any tables that have not yet been built, and fill in the default tiles)
    if ($build_check === null) {
        try {
            build_db($db);
            $build_check = true;
        } catch (Exception $e) {
            error_log("SQL building error: $e at ".__FILE__.":".__LINE__);
            $build_check = false;
            throw $e;
        }
    }

    # Throw a SQLite3Exception rather than an error if something goes wrong with the database or function
    set_error_handler("SQLite3Exception_thrower",E_WARNING);

    # Run the passed function, passing it the SQLite object as a parameter
    $ret = $function($db);

    restore_error_handler();

    # Close the database
    $db->close();

    return $ret;
}

/**
 * Ensures that the database has all the necessary tables and settings before processing any database functions.
 *
 * This function enables foreign keys, tries to create all the databases if they don't exist, then deletes any expired sessions.
 *
 * @param callable $db This is a code block that is called with the parameter `$db`, so that the database can be interacted with.
 *
 * @retval null
 */
function build_db($db) {
    # Set the length of time to wait before failing
    $db->busyTimeout(20000);

    # Run the schema file
    $db->exec(file_get_contents("db/schema.sql"));

    # If this isn’t zero (there was an error), throw SQLite3Exception
    if ($db->lastErrorCode() != 0) {
        throw new SQLite3Exception($db, "<initial setup SQL>");
    }
}

/**
 * Used to be able to catch errors raised by the SQLite databate connection
 */
class SQLite3Exception extends Exception {
    protected $query = "";

    /**
     * Create the exception
     * @param SQLite3 $db  The database connection instance
     * @param string $query  The query that triggered the error
     * @param Exception|null $previous [description]
     */
    public function __construct($db, $query='', Exception $previous = null) {
        # Store the error message and code using Exception::__construct()
        parent::__construct($db->lastErrorMsg(), $db->lastErrorCode(), $previous);

        # Store the erroneous query
        $this->query = $query;
    }

    /** Custom string representation of object */
    public function __toString() {
        error_log(__CLASS__ . ": [{$this->code}]: {$this->message}.\n".
            "Query: {$this->query}\n{$this->getTraceAsString()}\n");

        return __CLASS__ . ": [{$this->code}]: {$this->message}.\n".
            "Query: {$this->query}\n{$this->getTraceAsString()}\n";
    }
}

/**
 * Throw an SQLite3Exception
 * @param int $e_no  error level
 * @param string $e_str  error message (string)
 * @param string $e_f  error file
 * @param int $e_l  error line
 * @param array $vars  the variables when the error was called
 */
function SQLite3Exception_thrower($e_no,$e_str,$e_f,$e_l,$vars){
    # If the error was related to SQLite3
    if (preg_match('~SQLite3~',$e_str)) {
        # Throw an SQLite3Exception
        throw new SQLite3Exception($vars["db"],@$vars["sql"]);
        # Handle the error no more
        return true;
    }

    # Use native error handling if the error is unrelated
    return false;
}
