package com.ezplanner.calander.ui.controls
{
	import com.ezplanner.calander.events.PlannerEvent;
	import com.ezplanner.calander.model.vos.TaskVO;
	import com.ezplanner.calander.utils.Constants;
	
	import flash.events.MouseEvent;
	
	import mx.controls.Text;
	
	import spark.components.Label;
	import spark.components.TextArea;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.events.TextOperationEvent;
	
	public class TaskInputComponent extends SkinnableComponent
	{
		[SkinPart(required="true")]	public var mobile:IconButton;
		[SkinPart(required="true")]	public var email:IconButton;
		[SkinPart(required="true")]	public var land_phone:IconButton;
		[SkinPart(required="true")]	public var noreminder:IconButton;
		[SkinPart(required="true")]	public var timeLbl:Label;
		[SkinPart(required="true")]	public var descTxt:TextArea;
		
		private var _taskVo:TaskVO;
		
		
		public function TaskInputComponent()
		{
			super();
		}
		
		[Bindable]
		public function set taskVo(v:TaskVO):void{this._taskVo = v;}
		public function get taskVo():TaskVO {return this._taskVo;}
		
		protected override function partAdded(partName:String, instance:Object):void{
			super.partAdded(partName,instance);
			
			if(instance == mobile){
				mobile.addEventListener(MouseEvent.CLICK,doReminderHandler);
			}
			if(instance == land_phone){
				land_phone.addEventListener(MouseEvent.CLICK,doReminderHandler);
			}
			if(instance == email){
				email.addEventListener(MouseEvent.CLICK,doReminderHandler);
			}
			if(instance == noreminder){
				noreminder.addEventListener(MouseEvent.CLICK,doReminderHandler);
			}
			if(instance == descTxt){
				descTxt.addEventListener(TextOperationEvent.CHANGE,textChangeEventHandler);
			}
			if(instance == timeLbl){
				//timeLbl.text = taskVo.time;
			}
		}
		private function textChangeEventHandler(event:TextOperationEvent):void	{
			taskVo.isEdited = true;
			taskVo.description = descTxt.text;
		}
		private function doReminderHandler(event:MouseEvent):void{
			var ic:IconButton = event.target as IconButton;
			if(ic.getStyle("highlight") == Constants.HIGHLIGHT_COLOR)	{
				ic.setStyle("highlight",Constants.HIGHLIGHT_COLOR_NO);
				setReminders(false,ic);
			}
			else	{
				ic.setStyle("highlight",Constants.HIGHLIGHT_COLOR);
				setReminders(true,ic);
			}
		}
		
		private function setReminders(isSet:Boolean,ic:IconButton):void	{
			taskVo.isEdited = true;
			var toogleStr:String = isSet ? "1" : "0";
			switch(ic)
			{
				case mobile:
					taskVo.reminders = toogleStr+taskVo.reminders.substring(1);
					break;
				case land_phone:
					taskVo.reminders = taskVo.reminders.substring(0,2)+toogleStr+taskVo.reminders.substring(3);
					break;
				case email:
					taskVo.reminders = taskVo.reminders.substring(0,taskVo.reminders.length-1)+toogleStr
					break;
				case noreminder:
					taskVo.noReminder = toogleStr;
					break;
			}
			
		}
	}
}