package com.flashgamer.graphics
{
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	
	public class GradientBox extends Sprite
	{
		protected static const DEG2RAD:Number = Math.PI / 180;
		public function GradientBox(width:Number, height:Number, startColor:Number, endColor:Number, rotation:Number = 90)
		{
			var myMatrix:Matrix = new Matrix();
			myMatrix.createGradientBox(width,height,rotation*DEG2RAD);
			this.graphics.beginGradientFill(GradientType.LINEAR, [startColor,endColor], [1,1], [0,255], myMatrix);
			this.graphics.drawRect(0, 0, width, height);
		}
	}
}