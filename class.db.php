<?php
if( !defined("INSIGHTS_RUNNING") ) die("Error 211.");

/* usage:
$database = new VOA_DB(
    DATABASE__HOST,
    SELECT_DATABASE,
    DATABASE__USER,
    DATABASE__PASS
);

# available settings commands:
$database->Single()
$database->Multiple()
$database->setSticky(true)      // or false
$database->setReturnData(true)  // or false

# ex#1 - gets all rows:
$rows = $database->Query("show tables");

# ex#2 - gets a single row:
$row = $database->Single->Query(
    "select * from users where id=:id limit 1",
    array(":id" => $_GET['id'])
);

# ex#3 - if you're doing a bunch of single queries,
# and want settings to stick around:
$sql = "select * from users where id=? limit 1";
$database->Single->setSticky(true);
$r1 = $database->Query($sql, array($_GET['user1']) );
$r2 = $database->Query($sql, array($_GET['user2']) );

*/

class VOA_DB {
    private $hostname;
    private $database;
    private $username;
    private $password;

    // default value: false
    // if true, keeps any changed options after query
    // if false, resets to default settings after each query
    public $sticky;

    // default value: false
    // returns single row if true, otherwise multiple rows
    public $single_mode;

    // default value: true
    // if true: on query, fetch rows and return them
    // if false, on query, return $statement
    public $return_data;

    // default: PDO::FETCH_ASSOC
    public $fetch_style;

    // default: null
    public $index;

    function __construct($h, $d, $u, $p) {
        // required
        // operational toggle switches

        $this->hostname = $h;
        $this->database = $d;
        $this->username = $u;
        $this->password = $p;

        $this->setDefaults();
        $this->connect();
    }

    function setDefaults() {
        $this->single_mode = false;
        $this->sticky = false;
        $this->return_data = true;
        $this->fetch_style = PDO::FETCH_ASSOC;
        $this->index = array();
        return( $this );
    }

    function setSticky($v = true) {
        $this->sticky = $v;
    }

    function setReturnData($v = true) {
        $this->return_data = $v;
        return($this);
    }

    function connect() {
        try {
            $this->db = new PDO(
                "mysql:host={$this->hostname};dbname={$this->database}",
                $this->username,
                $this->password
            );
        } catch( Exception $e ) {
            // do some error handling here
            echo "<h4>Error connecting to MySQL</h4>";
            die;
        }
    }

    function Single() {
        $this->single_mode = true;
        return( $this );
    }

    function Multiple() {
        $this->single_mode = false;
        return( $this );
    }

    function Index($field) {
        $this->index[] = $field;
        return( $this );
    }

    // only does two levels of indexing
    // warning: defaults were set prior to this
    function doIndex() {
        $ret = array();
        $data = $this->statement->fetchAll($this->fetch_style);

        foreach( $data as $line ) {
            if( !isset($line[$this->index[0]]) ) {
                throw new Exception(
                    "Index '" . $this->index[0] . "' does not exist in data."
                );
            }
            $key = $line[$this->index[0]];

            if( count($this->index) == 1 ) {
                $ret[$key] = $line;
            } else {
                $key2 = $line[$this->index[1]];
                if( !isset($ret[$key]) ) $ret[$key] = array();
                $ret[$key][$key2] = $line;
            }
        }
        if( $this->sticky == false ) $this->setDefaults();
        return( $ret );
    }

    function Query($sql, $params = array()) {
        if( !is_array($params) ) $params = array($params);

        $this->statement = $this->db->prepare( $sql );
        $this->statement->execute($params);

        if( $this->return_data == false ) {
            return( $this->statement );
        }

        if( $this->single_mode == false ) {
            if( empty($this->index) ) {
                if( $this->sticky == false ) $this->setDefaults();
                return( $this->statement->fetchAll($this->fetch_style) );
            } else {
                return( $this->doIndex() );
            }
        } else {
            if( $this->sticky == false ) $this->setDefaults();
            return( $this->statement->fetch($this->fetch_style) );
        }
    }
}
