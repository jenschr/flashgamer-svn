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
	}
}
