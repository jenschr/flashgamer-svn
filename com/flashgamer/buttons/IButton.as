package com.flashgamer.buttons
{
	import flash.events.MouseEvent;
	
	public interface IButton
	{
		function over(e:MouseEvent):void
		function out(e:MouseEvent):void
		function down(e:MouseEvent):void
	}
}