package com.ezplanner.calander.ui.presenters
{
	import com.ezplanner.calander.core.ServiceManager;
	import com.ezplanner.calander.events.PlannerEvent;
	import com.ezplanner.calander.model.vos.TaskVO;
	import com.ezplanner.calander.model.vos.UserVO;
	import com.ezplanner.calander.utils.Constants;
	import com.flexoop.utilities.dateutils.DateUtils;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	public class MasterPresentationModel extends EventDispatcher
	{
		private var dispatcher:IEventDispatcher;
		
		private var _stackIndex:Number = 0;
		
		public var userVO:UserVO;
		public var isRowEdit:Boolean = false;
		
		[Bindable]public var currentDate:Date = new Date();
		[Bindable]public var taskList:ArrayCollection;
		[Bindable]public var dbData:Array = new Array(); //id,time
		
		public function MasterPresentationModel(target:IEventDispatcher)
		{
			this.dispatcher = target;
		}
		[Bindable(Event="StackChangeEvent")]
		public function get stackIndex():Number {return this._stackIndex} 
		public function set navigatePages(mode:Number):void{
			switch(mode)
			{
				case Constants.MODE_LOGIN : this._stackIndex = 0;break;
				case Constants.MODE_WELCOME : this._stackIndex = 1 ;break;
				case Constants.MODE_START_CALENDAR : this._stackIndex = 2 ;break;
				case Constants.MODE_START_DATE_ENTRY : this._stackIndex = 3;break;
			}
			this.dispatchEvent(new Event("StackChangeEvent"));
		}
		/***************************
		 * Login stories
		 ***************************
		 *  */
		public function login(userid:String,password:String):void{
			if(userid != "" && password != "")	{
				ServiceManager.getInstance().call("login",loginSuccess,loginFault,null,userid,password);
			}
			else	{
				Alert.show("Please provide User ID and password.","Incomplete Information")
			}
		}
		private function loginSuccess(event:ResultEvent):void{
			this.navigatePages = Constants.MODE_WELCOME;
			ServiceManager.getInstance().call("getUserDetails",userDetailsSuccess,userDetailsFault,event.result,event.result);
		}
		private function loginFault(event:FaultEvent):void{
			Alert.show("Error found in login credentials. Please login again.","Sign in Error");
		}
		/*************************
		 * User data stories
		 * **********************
		 * */
		private function userDetailsSuccess(event:ResultEvent,passback:Object):void{
			var rs:Object = event.result;
			userVO = new UserVO(Number(rs.id),rs.displayName,rs.fullName,rs.userName);
			ServiceManager.getInstance().call("isEventAdded",eventCheckHandler,genericFaultHandler,null,userVO.id);
		}
		private function userDetailsFault(event:FaultEvent,passback:Object):void{
			userVO = new UserVO(Number(passback),'','','');
		}
		/**************************
		 * Event Check stories
		 * */
		
		private function eventCheckHandler(event:ResultEvent):void{
			if(event.result != null){
				userVO.endDate = new Date(String(event.result.endDate));
				userVO.startDate = new Date(String(event.result.startDate));
			  //this.navigatePages = Constants.MODE_START_DATE_ENTRY;
			}
			else{
			  	
			}
		}
		/****************************
		 * New User  stories
		 ****************************
		 *  */
		public function createViewCalendar(uid:String,pswd:String,fname:String):void{
			if(uid != "" && pswd != "" && fname != "" )	{
				var usrObj:Object = {user:uid,name:fname}
				ServiceManager.getInstance().call("addNewUser",newUserSuccess,newUserFault,usrObj,uid,pswd,fname,1);
			}
			else	{
				Alert.show("Please fill up all the fields.","Incomplete Information")
			}
		}
		private function newUserSuccess(event:ResultEvent, passBackObj:Object):void{
			this.userVO = new UserVO(Number(event.result),passBackObj.name,passBackObj.user,passBackObj.user)
			this.navigatePages = Constants.MODE_WELCOME;
		}
		private function newUserFault(event:FaultEvent, passBackObj:Object):void{
			if(event.fault.faultString.toString() == "USER_EXISTS"){
				Alert.show("The User ID is already taken by some other user. Please try with another User ID","Add New User - User Exists");
			}
			else{
				Alert.show("Could not add a new user now. Pleas try again later","Add New User - Error");
			}
		}
		/****************************
		 * New Event  stories
		 **************************** 
		 *  */
		public function addNewEvent(desc:String,sdate:String,edate:String):void{
			ServiceManager.getInstance().call("addNewEvent",newEventSuccess,newEventFault,null,userVO.id,desc,1,sdate,edate);
		}
		private function newEventSuccess(e:ResultEvent):void{
			this.navigatePages = Constants.MODE_START_DATE_ENTRY;
		}
		private function newEventFault(e:FaultEvent):void{
			Alert.show("A Calendar is already been set into your account, please goto Accounts page and edit the event. ",
				"Calendar is been set Already",2);
		}
		/**************
		 * 
		 * Tasks in a day stories
		 * 
		 * ***********/
		public function getTasksByDay(date:String):void	{
			ServiceManager.getInstance().call("getTasksFromDate",taskInDayRetrieved,taskInDayFault,null,userVO.id,date);
		}
		private function taskInDayRetrieved(e:ResultEvent):void	{
			var resultData:Array = e.result as Array;
			this.dbData = new Array();
			if(resultData.length>0 )	{
				var taskVO:TaskVO;
				var tempList:Array = new Array();
				var tempTaskList:Array = resultData;
				var i:Number = 0; var j:Number = 0;
				for(i = 0; i<24; i++)	{
					taskVO = new TaskVO(i,userVO.id,null,i.toString(),"","0|0|0","1");
					tempList[i] = taskVO;
					for(j=0; j<tempTaskList.length; j++)	{
						taskVO = tempTaskList[j] as TaskVO;
						if(i == Number(taskVO.time))	{
							tempList[i] = tempTaskList[j];
							this.dbData.push({id:taskVO.id,time:i});
							break;
						}
					}
				}
	
				this.taskList = new ArrayCollection(tempList);
				isRowEdit = true;	
			}
			else{
				this.taskList = createTaskList(); isRowEdit = false;
			}
		}
		private function taskInDayFault(e:FaultEvent):void	{
			//if error creates a temp task list and puts in box
			this.dbData = new Array();
			this.taskList = createTaskList(); isRowEdit = false;
		}
		/**
		 * 
		 * Add data entry stories
		 * 
		 * **/
		public function addDaysTask(tasks:ArrayCollection,edited:ArrayCollection):void{
			ServiceManager.getInstance().call("addDaysTask",dayTaskSuccess,dayTaskFault,{data:edited},tasks.source);
		}
		private function dayTaskSuccess(e:ResultEvent,editData:Object):void	{
			if(editData.data.length >0)	{
				editDaysTask(editData.data)
			}
			else	{
				getTasksByDay(com.flexoop.utilities.dateutils.DateUtils.getMidDate(currentDate));
			}
		}
		private function dayTaskFault(e:FaultEvent,editData:Object):void	{
			if(editData.data.length >0)	
			editDaysTask(editData.data)
		}
		/**
		 * Edit data entry stories
		 * 
		 * **/
		
		public function editDaysTask(tasks:ArrayCollection):void	{
			ServiceManager.getInstance().call("updateDaysTask",dayEditSuccess,dayEditFault,null,tasks.source);
		}
		private function dayEditSuccess(e:ResultEvent):void	{
			getTasksByDay(com.flexoop.utilities.dateutils.DateUtils.getMidDate(currentDate))
		}
		private function dayEditFault(e:FaultEvent):void	{
			trace(e)	
		}
		/******************************
		 * 
		 * Common methods
		 * 
		 *  */
		private function genericFaultHandler(event:FaultEvent):void{
			Alert.show("Error in the server. Please try again later.", "Server Error");
		}
		public function gotoPages(pageId:Number):void{
			trace("Data")
			if(pageId ==Constants.MODE_START_CALENDAR && userVO.startDate != null){
				this.navigatePages = Constants.MODE_START_DATE_ENTRY;
				return;
			}
			this.navigatePages = pageId;
		}
		
		private function createTaskList():ArrayCollection	{
			var taskVo:TaskVO;
			//var ampm:String = ":AM";
			var tl:ArrayCollection = new ArrayCollection();
			for(var i:int = 0; i<24; i++){
				//ampm = i>=12 ? (i-12).toString()+":PM" : (i).toString()+":AM"; 
				//ampm = i ==0 ?"12:AM" : ampm; 
				//ampm = i-12 ==0 ?"12:PM" : ampm; 
				taskVo = new TaskVO(i,userVO.id,null,i.toString(),"","0|0|0","1");
				tl.addItem(taskVo);
			}
			return tl;
		}
	}
}