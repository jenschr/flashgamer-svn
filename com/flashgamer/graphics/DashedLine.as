package com.flashgamer.graphics
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;

	public class DashedLine extends Bitmap {
		
		public function DashedLine(){
			
		}
		
		// lineTo method
		public function lineTo(w:Number,color:Number = 0):void
		{	
			var bd:BitmapData = new BitmapData(w,1,true);
			var i:int;
			for(i=0;i<w;i++){
				if(i%2){
					bd.setPixel(i,0,color);
				}
			}
			this.bitmapData = bd;
		}
	}
}