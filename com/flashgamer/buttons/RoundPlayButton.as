package com.flashgamer.buttons
{
	import flash.display.GradientType;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;

	public class RoundPlayButton extends BaseButton implements IButton
	{
		private var w:Number;
		private var h:Number;
		public function RoundPlayButton(width:Number, height:Number)
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
		}
		private function draw(backgroundColor:Number,hightlightColor:Number,iconColor:Number, reduceBy:Number = 0):void
		{
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(w,h);
			this.graphics.clear();
			this.graphics.beginGradientFill(GradientType.RADIAL,[hightlightColor,backgroundColor],[1,1],[0,255],matrix);
			this.graphics.drawCircle(w/2,h/2,w/2);
			this.graphics.endFill();
			this.graphics.moveTo(w/4*1.4+reduceBy,h/4+reduceBy);
			this.graphics.beginFill(iconColor);
			this.graphics.lineTo(w/4*3-reduceBy,h/2);
			this.graphics.lineTo(w/4*1.4+reduceBy,h/4*3-reduceBy);
			this.graphics.lineTo(w/4*1.4+reduceBy,h/4+reduceBy);
			this.graphics.endFill();
		}
	}
}