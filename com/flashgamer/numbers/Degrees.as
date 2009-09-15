package com.flashgamer.numbers
{
	/**
	 * @author jensa
	 */
	
	public class Degrees 
	{
		public static const RADTODEG : Number = 180/Math.PI;		
		public static const DEGTORAD : Number = Math.PI/180;
	
		public function Degrees()
		{
			// empty contructor for static classes
		}
		public static function dCos(angle:Number):Number
		{
			return Math.cos( angle*DEGTORAD );
		}
		public static function dSin(angle:Number):Number
		{
			return Math.sin( angle*DEGTORAD );
		}
		// returns answer as radians
		public static function findAngle(point1:Point, point2:Point):Number
		{
			var dx:Number = point2.x - point1.x;
			var dy:Number = point2.y - point1.y;
			return -Math.atan2(dx,dy);
		}
	}
}
