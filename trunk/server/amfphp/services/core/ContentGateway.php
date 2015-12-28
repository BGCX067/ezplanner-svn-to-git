<?php
	
	include_once("../vo/Transaction.php");
	include_once("../vo/TaskVO.php");
	include_once("Database.php");
	
	class ContentGateway {		
	
		private $db;
	
		function __construct() {
			$this->db = new Database();
		}
		
		function tester($string) {
			return "Testing String : ". $string;
		}	
		
		function login($username, $password) {
			if(!$username || !$password) {
				trigger_error("INVALID_LOGIN");
			}
      
			if(!$this->db) {
				trigger_error("DB_CONNECTION_ERROR");
			} 
			
			$q = "select * from users where userName='".$username."' and password='".md5($password)."'"; 
			$d = $this->db->execute($q);
			
			if($d->num_rows < 1) {
				trigger_error("INVALID_LOGIN");
			} else {
				$r = mysqli_fetch_object($d);
				return $r->id;
			}
		}
		
		function logout() {
		}
    
    function getUserDetails($uid) {
      $q = "select a.id, fullName, userName, displayName from users a, usertype b where a.id = ".$uid." and b.id = a.type;";
      $d = $this->db->execute($q);
      
      return mysqli_fetch_object($d);
    }
		
		function isOldUser($username) {
			if(!$this->db) {
				trigger_error("DB_CONNECTION_ERROR");
			}
			
			$q = "select * from users where userName='".$username."'"; 
			$d = $this->db->execute($q);
			
			if($d->num_rows < 1) {
				return false;
			} else {
				return true;
			}
		}
		
		function addNewUser($username, $password, $fullname, $usertype) {
			if($this->isOldUser($username)) {
				trigger_error("USER_EXISTS");
			}
      
			$q = "insert into users (userName, password, fullName, type)  values ('".$username."', '".md5($password)."', '".$fullname."', $usertype);";
			$d = $this->db->execute($q);
			$id = $this->db->sql->insert_id;
			
			return $id;
		}

		function addNewUserType($displayName, $description) {
           $q = "insert into usertype (displayName, description) values ('". $displayName ."', '". $description ."')"; 
           $d = $this->db->execute($q);
     
          return $d; 
        }

		function addNewEventType($eventId, $eventName) {
           $q = "insert into eventtype (eventId, eventName) values ('". $eventId ."', '". $eventName ."')"; 
           $d = $this->db->execute($q);
     
          return $d; 
        }

        function addNewEvent($userId, $description, $type, $startDate, $endDate) {

			$q = "insert into users_event (userId, description, type, status, startDate, endDate) values ( '".$userId."', '".$description."', '".$type."', '1', '".$startDate."', '".$endDate."');";
			$d = $this->db->execute($q);
			
			return $d;
		}

		function updateEvent($userId, $description,  $startDate, $endDate){
		  $q = "update users_event set 'description' = '".$description."','startdate' = '"+$startDate+"' = '".$endDate."' where userid ='".userId."' limit 1";
		  $d = $this->db->execute($q);

		  return $d;
		}

		function isEventAdded($userId) {
			if(!$this->db) {
				trigger_error("DB_CONNECTION_ERROR");
			}
			
			$q = "select * from users_event where userid='".$userId."'"; 
			$d = $this->db->execute($q);
			
			return mysqli_fetch_object($d);
		}



		function getTasksFromDate($userId, $date)	{
			$q = "select * from user_calendar_details where userid='".$userId."' and date='".$date."'"; 
			$d = $this->db->execute($q);
			

			$ret = array();
				while ($row = mysqli_fetch_object($d)) {
				$tmp = new TaskVO();
				$tmp->id = $row->id;
				$tmp->userid = $row->userid;
				$tmp->date = $row->date;
				$tmp->time = $row->time;
				$tmp->description = $row->description;
				$tmp->reminders = $row->reminders;
				$tmp->noReminder = $row->noReminder;
				$ret[] = $tmp;
			}
			mysqli_free_result($d);
			return $ret;
		}

		public function addDaysTask($tasks) {
			$query = "";
			$dataObj;
			$len = sizeof($tasks);
			$coma = "";
			for($i =0; $i<$len; $i++)	{
				$TaskVO = $tasks[$i];
				if($i>0){
					$coma = ",";
				}
				$query .= $coma."('".$TaskVO->userid."','".$TaskVO->date."','".$TaskVO->time."','".$TaskVO->description."','".$TaskVO->reminders."','".$TaskVO->noReminder."')";
			}

			$q = "insert into user_calendar_details (userid, date, time, description, reminders, isRemind ) values ".$query.";";
			$d = $this->db->execute($q);
			
			return $d;
		}

		public function updateDaysTask($tasks)	{
			$query = "";
			$dataObj;
			$len = sizeof($tasks);
			$coma = "";
			for($i =0; $i<$len; $i++)	{
				$TaskVO = $tasks[$i];				
				$query .= "update user_calendar_details set description='".$TaskVO->description."',reminders='".$TaskVO->reminders."',isRemind='".$TaskVO->noReminder."' WHERE userid='".$TaskVO->userid."' and date='".$TaskVO->date."' and time='".$TaskVO->time."';";
			}

			
			$d = $this->db->execute($query);
			
			
			return $d;
		}





    
    /*function addNewCustomer($customerName, $description, $permittedUsers) {
      
    }
    
    function addNewUserType($displayName, $description) {
     $q = "insert into usertype (displayName, description) values ('". $displayName ."', '". $description ."')"; 
     $d = $this->db->execute($q);
     
     return $d; 
    }
    
    function getAllUserTypes() {
      $q = "select * from usertype";
      $d = $this->db->execute($q);
      
      return $d;
    }
    
    function getUserType($userTypeId) {
      $q = "select * from usertype where id=". $userTypeId .";";
      $d = $this->db->execute($q);
      
      return mysqli_fetch_object($d);
    }
    
    function updateUserType($userTypeId, $displayName, $description) {
      $q = "update usertype set displayName = '". $displayName ."', description = '".$description."' where id=".$userTypeId .";";
      $d = $this->db->execute($q);
      
      return $d;
    }
    
    function getAllUsers() {
      $q = "select fullName, userName, displayName from users a, usertype b where a.type = b.id;";
      
      $d = $this->db->execute($q);
      
      return $d;
    }
    
    function getAllServices() {
      $q = "select * from services";
      $d = $this->db->execute($q);
      
      return $d;
    }
    
    function getAllServicesForUserType($userTypeId) {
      $q = "select * from privileges where userTypeId = ". $userTypeId .";";
      $d = $this->db->execute();
      
      return $d;
    }
    
    function upateServiceForUserType($serviceId, $userTypeId) {
      $q = "update privileges set userTypeId = ". $userTypeId .", serviceId = ". $serviceId .";";
      $d = $this->db->execute($q);
      
      return $d;
    }
    
    function getCustomersForUser($userId) {
      $q = "select a.name from customers a, association b where b.cid = a.id and b.uid = ". $userId .";";
      $d = $this->db->execute($q);
      
      return $d;
    }
    
    function getProjectsForUser($userId) {
      $q = "select a.name from projects a, association b where b.pid = a.id and b.uid = ". $userId .";";
      $d = $this->db->execute($q);
      
      return $d;
    }*/
	}
	
?>