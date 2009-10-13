package trunk.com.flashgamer.numbers
{
	public class Randomizing
	{
		/**
		 * Randomize an array/vector
		 * 
		 * var a:Array = new Array(”a”, “b”, “c”, “d”, “e”);
		 * var b:Array = a.sort(shuffle);
		 * 
		 * Made by MrSteel, http://mrsteel.wordpress.com/2007/05/26/random-array-in-as2-as3-example-using-sort/
		 **/
		
		private function shuffle(a,b):int {
			var num : int = Math.round(Math.random()*2)-1;
			return num;
		}
		
		private function randomArraySort(_array:Array):Array {
			var _length:Number = _array.length;
			var mixed:Array = _array.slice();
			var rn:Number;
			var it:Number;
			var el:Object;
			for (it = 0; it<_length; it++) {
				el = mixed[it];
				rn = Math.floor(Math.random() * _length);
				mixed[it] = mixed[rn];
				mixed[rn] = el;
			}
			return mixed;
		}
	}
}