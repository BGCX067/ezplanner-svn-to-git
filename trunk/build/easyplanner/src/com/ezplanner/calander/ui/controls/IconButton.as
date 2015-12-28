package com.ezplanner.calander.ui.controls
{
	import com.ezplanner.calander.ui.skins.IconButtonSkin;
	
	import spark.components.Button;
	
		[Style(name="icon",type="*")]
		[Style(name="iconOver",type="*")]
		[Style(name="iconDown",type="*")]
		[Style(name="highlight",type="*")]
	
	public class IconButton extends Button
	{
		
		public function IconButton()
		{
			super();
			this.buttonMode = this.useHandCursor = true;
			this.setStyle("skinClass",IconButtonSkin);
		}
	}
}