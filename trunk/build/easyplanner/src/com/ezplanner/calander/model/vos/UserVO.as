package com.ezplanner.calander.model.vos
{
	public class UserVO
	{
		public var id:Number;
		public var displayName:String;
		public var fullName:String;
		public var userName:String;
		
		private var _sdate:Date;
		private var _edate:Date;
		
		public function UserVO(id:Number,dsName:String,fName:String,uName:String)
		{
			this.id = id;
			this.displayName = dsName;
			this.fullName = fName;
			this.userName = uName;
		}
		
		public function set startDate(d:Date):void{this._sdate = d}
		public function get startDate():Date {return this._sdate}

		public function set endDate(d:Date):void{this._edate = d;}
		public function get endDate():Date {return this._edate;}
		
		
	}
}