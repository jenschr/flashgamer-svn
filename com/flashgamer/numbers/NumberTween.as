package com.flashgamer.numbers
	import flash.media.Sound;	
	import flash.events.Event;	
	import flash.events.EventDispatcher;	
	
	/**
	 * @author jensa
	 */
	public class NumberTween extends EventDispatcher
	{
		private var fromNum:Number = 0;
		private var toNum:Number = 0;
		private var total:Number = 1;
		private var current:Number = 0;
		private var zero:Number;
		
		[Embed(source="/assets.swf", symbol="TriangleSFX")]
		private var triangleSound:Class;
		
		private var s:Sound;
		public  var soundEnabled:Boolean = false;

		public function NumberTween()
		{
			// Nada here. just make an instance and call setNumber and getNumber from there
			s = new triangleSound();
		}
		public function setNumber(from:Number, to:Number, iterations:Number, zeros:Number = 1):void
		{
			trace("NumberTween.setNumber "+arguments)
			fromNum	= from;
			toNum	= to;
			total	= iterations
			current	= 1;
			zero	= zeros*10;
		}
		public function getNumber():Number
		{
			var diff:Number = toNum - fromNum;
			if(current < total){
				current++;
			} else {
				dispatchEvent(new Event(Event.COMPLETE));
			}
			var rez:Number = fromNum + Math.floor( ( (diff/total)*current)/zero )*zero;
			if(rez<0){ rez = 0; }
			if(isNaN(rez)){
				// break
			}
			if( current%6 == 0 && soundEnabled){
				makeSound();
			}
			//trace("rez "+rez);
			return rez;
		}
		public function finish():void
		{
			current == total;
			dispatchEvent(new Event(Event.COMPLETE));
		}
		public function makeSound():void
		{
			s.play(0);
		}
	}
}
