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
		
		public function shuffle(a,b):int {
			var num : int = Math.round(Math.random()*2)-1;
			return num;
		}
		
		public function shuffleArray(arr:Array):Array {
			var arr2:Array = [];
			while (arr.length > 0) {
			    arr2.push(arr.splice(Math.round(Math.random() * (arr.length - 1)), 1)[0]);
			}
			return arr2;
		}
		
		// not tested
		public function shuffleVector(arr:Vector):Vector {
			var arr2:Array = [];
			while (arr.length > 0) {
			    arr2.push(arr.splice(Math.round(Math.random() * (arr.length - 1)), 1)[0]);
			}
			return arr2;
		}
		
		public function randomArraySort(_array:Array):Array {
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
		public function mixArray(array:Array):Array {
			var _length:Number = array.length, mixed:Array = array.slice(), rn:Number, it:Number, el:Object;
			while (it < _length) {
				el = mixed[it];
				mixed[it] = mixed[rn = it + random(_length - it)];
				mixed[rn] = el;
				it++;
			}
			return mixed;
		}
	}
}