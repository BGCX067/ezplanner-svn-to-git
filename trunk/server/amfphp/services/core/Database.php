<?php
	include_once("../utils/Constants.php");
	
	class Database {		
		
		private $dbHost;
		private $dbUsername;
		private $dbPassword;
		private $dbName;
		var $sql;
		
		public function connect($host="localhost", $un="root" , $pw="", $db="ezplanner") {
			$this->dbHost = $host;
			$this->dbUsername = $un;
			$this->dbPassword = $pw;
			$this->dbName = $db;
			
			$this->sql = mysqli_connect($this->dbHost, $this->dbUsername, $this->dbPassword, $this->dbName);
			
			if(mysqli_error($this->sql)) {
				trigger_error("DB_CONNECTION_ERROR");
			}
		}
		
		public function execute($query) {
			if(!$this->sql) {
				$this->connect("localhost", "root", "", "ezplanner");	 /* use while local */
				/* $this->connect();  use while hosted */
			}
			
			$r = mysqli_query($this->sql, $query);
			
			if(!$r) {
				trigger_error("DB_SCRIPT_ERROR: ". mysqli_error($this->sql));
			}
			
			return $r;
		}

	}
	
?>