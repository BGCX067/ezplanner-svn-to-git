package com.ezplanner.calander.model.vos 
{
	[Bindable] [RemoteClass(alias="TaskVO")]
	public class TaskVO
	{
		public var id:int;
		public var userid:int;
		public var date:String;
		public var time:String;
		public var description:String;
		public var reminders:String;
		public var noReminder:String;
		
		public var isEdited:Boolean = false;
		
		public function TaskVO(id:int=0,uid:int=0,date:String="",time:String="",desc:String="",remnr:String="",noRemnr:String="")
		{
			this.id = id;
			this.userid = uid;
			this.date = date;
			this.time = time;
			this.description =desc;
			this.reminders = remnr;
			this.noReminder = noRemnr;
		}
	}
}