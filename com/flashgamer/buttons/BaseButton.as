package com.flashgamer.buttons
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class BaseButton extends Sprite
	{
		public function BaseButton()
		{
			this.addEventListener(MouseEvent.ROLL_OVER,over);
			this.addEventListener(MouseEvent.ROLL_OUT,out);
			this.addEventListener(MouseEvent.MOUSE_DOWN,down);
			this.addEventListener(MouseEvent.MOUSE_UP,up);
			this.addEventListener(Event.ADDED_TO_STAGE,addedToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE,removedFromStage);
		}
		private function addedToStage(e:Event):void
		{
			//trace("addedToStage");
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE,dragOut);
		}
		private function removedFromStage(e:Event):void
		{
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE,dragOut);
		}
		private function dragOut(e:MouseEvent):void
		{
			var isStillOver:Boolean = this.hitTestPoint(e.stageX,e.stageY,true);
			//trace("dragOut stillover? "+isStillOver+" stillDown "+e.buttonDown);
			if(isStillOver){
				if(e.buttonDown){
					down(e);
				} else {
					over(e);
				}
			} else {
				out(e);
			}
		}
		private function up(e:MouseEvent):void
		{
			var isStillOver:Boolean = this.hitTestPoint(e.stageX,e.stageY,true);
			if(isStillOver){
				over(e);
			} else {
				out(e);
			}
		}
		public function over(e:MouseEvent):void
		{
			trace("override the over-function");
		}
		public function out(e:MouseEvent):void
		{
			trace("override the out-function");
		}
		public function down(e:MouseEvent):void
		{
			trace("override the down-function");
		}
	}
}