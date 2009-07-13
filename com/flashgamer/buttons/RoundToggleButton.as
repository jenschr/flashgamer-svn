package com.flashgamer.buttons
{
	import flash.display.GradientType;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;

	public class RoundToggleButton extends BaseButton implements IButton
	{
		private var w:Number;
		private var h:Number;
		private var isPlaying:Boolean = false;
		public function RoundToggleButton(width:Number, height:Number)
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
			if(isPlaying){
				isPlaying = false;
			} else {
				isPlaying = true;
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
			
			if(!isPlaying){
				this.graphics.moveTo(w/4*1.4+reduceBy,h/4+reduceBy);
				this.graphics.beginFill(iconColor);
				this.graphics.lineTo(w/4*3-reduceBy,h/2);
				this.graphics.lineTo(w/4*1.4+reduceBy,h/4*3-reduceBy);
				this.graphics.lineTo(w/4*1.4+reduceBy,h/4+reduceBy);
				this.graphics.endFill();
			} else {
				this.graphics.beginFill(iconColor);
				var sW:Number = w/8;
				this.graphics.drawRect(w/4+(sW*0.5),h/4,sW,h/2);
				this.graphics.drawRect(w/4+(sW*2.5),h/4,w/8,h/2);
				this.graphics.endFill();
			}
			
			this.graphics.endFill();
		}
	}
}