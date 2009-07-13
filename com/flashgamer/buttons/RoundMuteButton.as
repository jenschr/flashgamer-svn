package com.flashgamer.buttons
{
	import flash.display.GradientType;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;

	public class RoundMuteButton extends BaseButton implements IButton
	{
		private var w:Number;
		private var h:Number;
		private var isMuted:Boolean = false;
		public function RoundMuteButton(width:Number, height:Number)
		{
			w = width;
			h = height;
			draw(0x747474,0x8e8e8e,0xffffff);
			
			super()
		}
		public override function over(e:MouseEvent):void
		{
			draw(0xc61f1f,0xef2d50,0xffffff,0.5);
		}
		public override function out(e:MouseEvent):void
		{
			draw(0x747474,0x8e8e8e,0xffffff);
		}
		public override function down(e:MouseEvent):void
		{
			draw(0x9e9e9e,0x646464,0xffffff,-0.5);
			if(isMuted){
				isMuted = false;
			} else {
				isMuted = true;
			}
		}
		private function draw(backgroundColor:Number,hightlightColor:Number,iconColor:Number, reduceBy:Number = 0):void
		{
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(w,h);
			this.graphics.clear();
			this.graphics.beginGradientFill(GradientType.RADIAL,[hightlightColor,backgroundColor],[1,1],[0,255],matrix);
			this.graphics.drawCircle(w/2,h/2,w/2);
			this.graphics.endFill();
			
			// icon
			this.graphics.beginFill(iconColor);
			var u:Number = w/9;
			var v:Number = w/8;
			
			this.graphics.moveTo(u*2,v*3);
			this.graphics.lineTo(u*4,v*3);
			this.graphics.lineTo(u*6,v*1);
			this.graphics.lineTo(u*6,v*7);
			this.graphics.lineTo(u*4,v*5);
			this.graphics.lineTo(u*2,v*5);
			this.graphics.lineTo(u*2,v*3);
			
			if(isMuted){
				this.graphics.moveTo(u*2,v*2);
				this.graphics.lineStyle(2,iconColor,1,true);
				this.graphics.lineTo(u*7,v*6);
			}
			
			this.graphics.endFill();
		}
	}
}