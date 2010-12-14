package trunk.com.flashgamer.text
{
	public class StringUtil
	{
		private function makeRandomCharacters(num:Number):String {
			var str:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcedefghijklmnopqrstuvwxyz";
			var rnd:Number; var ret:String = "";
			var i:int: var l:int = num;
			for(i=0;i<l;i++){
				rnd = Math.floor( Math.random()*str.length );
				ret += str.substr(rnd,1);
			}
			return ret;
		}
		
		private function paddedString(howMany:int, padWhat:String, padWith:String = "0"):String {
			var i:int; var l:int = howMany-padWhat.length; var pad:String = "";
			for(i=0;i<l;i++){
				pad += padWith;
			}
			return pad+padWhat;
		}
	}
}