package com.ezplanner.calander.events
{
	import flash.events.Event;
	
	public class PlannerEvent extends Event
	{
		public var data : *;
		
		public static const EVENT_GO_WELCOME : String = "LoginSuccess";
		public static const EVENT_DO_LOGIN : String = "DoLoginEvent";
		
		
		public static const EVENT_PREFILL_EVENTS: String = "EventPreFill";
		
		public function PlannerEvent(type:String, data:*, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.data = data;
		}
		
		override public function clone():Event{
			
			return new PlannerEvent(this.type,this.data,this.bubbles,this.cancelable);
		}
	}
}