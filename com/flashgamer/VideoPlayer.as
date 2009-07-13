package com.flashgamer
{
	import com.flashgamer.buttons.RoundPauseButton;
	import com.flashgamer.buttons.RoundPlayButton;
	import com.flashgamer.events.VideoEvent;
	import com.flashgamer.video.VideoStream;
	
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import com.flashgamer.buttons.RoundMuteButton;
	import com.flashgamer.buttons.RoundToggleButton;
	import com.flashgamer.buttons.RoundStopButton;
	
	public class VideoPlayer extends Sprite
	{
		public var w:Number = 320;
		public var h:Number = 300;
		public var hControls:Number = 70;
		public var pad:Number = 5;
		public var rad:Number = 8;
		public var grad1:Number = 0xffffff;
		public var grad2:Number = 0xe7e7e7; // 0xe3e3e3 0x990000
		
		private var background:Sprite;
		private var video:VideoStream;
		private var foreground:Sprite;
		private var scrubber:Sprite;
		private var progressbar:Sprite;
		private var progressmask:Sprite;
		private var controls:Sprite;
		private var elapsedTime:TextField;
		private var totalTime:TextField;
		private var format:TextFormat;
		private var isScrubbing:Boolean = false;
		public static const DEGTORAD : Number = Math.PI/180;
		
		public function VideoPlayer(width:Number,height:Number,heightOfControls:Number)
		{
			// Save sizes
			w = width;
			h = height;
			hControls = heightOfControls;
			
			// Setup text formatting
			format = new TextFormat("_sans",10,0x878787);
			
			// Create containers
			progressmask = new Sprite();
			background = new Sprite();
			foreground = new Sprite();
			controls = new Sprite();
			video = new VideoStream(width-(pad*2),height-(pad*2)-hControls,"http://www.birdie1.no/video/Birdie1_v2.flv");
			video.x = pad;
			video.y = pad;
			video.addEventListener(VideoEvent.METADATA,setTotal);
			video.addEventListener(VideoEvent.PROGRESS,setCurrentTime);
			background.addEventListener(MouseEvent.MOUSE_UP,video.playPause);
			
			// Container stacking order
			this.addChild( background );
			this.addChild( video );
			this.addChild( foreground );
			this.addChild( progressmask );
			this.addChild( controls );
			
			// draw the visuals
			drawPlayer();
			drawTextFields();
			drawScrubber();
			drawProgressbar();
			drawButtons();
		}
		public function drawPlayer():void
		{
			background.graphics.clear();
			background.graphics.beginFill(0xdde0dc);
			background.graphics.drawRoundRect(0,0,w,h,rad*2,rad*2);
			background.graphics.endFill();
			
			foreground.graphics.clear();
			//foreground.graphics.beginFill(0xffffff);
			var startPoint:Number = 255*((h-hControls+(pad*2))/h);
			var matrix:Matrix = new Matrix(1,0,0,1,-100,0);
			matrix.createGradientBox(w,h,90*VideoPlayer.DEGTORAD)
			foreground.graphics.beginGradientFill(GradientType.LINEAR,[grad1,grad2],[1,1],[startPoint,255],matrix);
			foreground.graphics.lineStyle(0,0xdde0dc);
			foreground.graphics.moveTo(0,rad);
			foreground.graphics.curveTo(0,0,rad,0);
			foreground.graphics.lineTo(w-rad-1,0);
			foreground.graphics.curveTo(w-1,0,w-1,rad);
			foreground.graphics.lineTo(w-1,h-rad-1);
			foreground.graphics.curveTo(w-1,h-1,w-rad-1,h-1);
			foreground.graphics.lineTo(rad,h-1);
			foreground.graphics.curveTo(0,h-1,0,h-rad-1);
			foreground.graphics.lineTo(0,rad);
			 
			// inner window
			foreground.graphics.lineStyle();
			foreground.graphics.moveTo(pad,pad+rad);
			foreground.graphics.curveTo(pad,pad,pad+rad,pad);
			foreground.graphics.lineTo(w-pad-rad,pad);
			foreground.graphics.curveTo(w-pad,pad,w-pad,pad+rad);
			foreground.graphics.lineTo(w-pad,h-pad-pad-hControls);
			foreground.graphics.curveTo(w-pad,h-pad-hControls,w-pad-rad,h-pad-hControls);
			foreground.graphics.lineTo(pad+rad,h-pad-hControls);
			foreground.graphics.curveTo(pad,h-pad-hControls,pad,h-pad-rad-hControls);
			foreground.graphics.lineTo(pad,pad+rad);
		}
		private function drawTextFields():void
		{
			// elapsed time textfield
			elapsedTime = new TextField();
			elapsedTime.autoSize = TextFieldAutoSize.NONE;
			elapsedTime.width = 40;
			elapsedTime.height = 15;
			elapsedTime.border = false;
			elapsedTime.x = pad+rad;
			elapsedTime.y = h-hControls+10;
			this.addChild( elapsedTime );
			setTime(elapsedTime,"00:00");
			
			totalTime = new TextField();
			totalTime.autoSize = TextFieldAutoSize.NONE;
			totalTime.width = 40;
			totalTime.height = 15;
			totalTime.border = false;
			totalTime.x = w-pad-rad-40;
			totalTime.y = h-hControls+10;
			this.addChild( totalTime );
			setTime(totalTime,"--:--");
		}
		
		private function drawScrubber():void
		{
			var sWidth:Number  = w-pad-rad-40-pad-rad-40;
			var sHeight:Number = 5;
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(sWidth,sHeight,90*VideoPlayer.DEGTORAD);
			
			scrubber = new Sprite();
			scrubber.x = pad+rad+40;
			scrubber.y = h-hControls+10+6;
			scrubber.graphics.beginGradientFill(GradientType.LINEAR,[0xa4a4a4,0xd8d8d8],[1,1],[0,255],matrix);
			scrubber.graphics.drawRoundRect(0,0,sWidth,sHeight,sHeight,sHeight);
			this.addChild( scrubber );
			
			scrubber.addEventListener(MouseEvent.MOUSE_DOWN,startScrubbing);
			this.addEventListener(MouseEvent.MOUSE_MOVE,setScrubbing);
			this.addEventListener(MouseEvent.MOUSE_UP,stopScrubbing);
		}
		private function drawProgressbar():void
		{
			var sWidth:Number  = w-pad-rad-40-pad-rad-40;
			var sHeight:Number = 5;
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(sWidth,sHeight,90*VideoPlayer.DEGTORAD);
			
			progressbar = new Sprite();
			progressbar.x = pad+rad+40;
			progressbar.y = h-hControls+10+6;
			progressbar.graphics.beginGradientFill(GradientType.LINEAR,[0x1ea1ff,0x52d7ff],[1,1],[0,255],matrix);
			progressbar.graphics.drawRoundRect(0,0,sWidth,sHeight,sHeight,sHeight);
			progressbar.mouseEnabled = false;
			progressbar.mask = progressmask;
			this.addChild( progressbar );			
		}
		private function drawProgress(prog:Number):void
		{
			var sWidth:Number  = (w-pad-rad-40-pad-rad-40)*prog;
			var sHeight:Number = 5;
			progressmask.x = pad+rad+40;
			progressmask.y = h-hControls+10+6;
			progressmask.graphics.clear();
			progressmask.graphics.beginFill(0xff00ff);
			progressmask.graphics.drawRect(0,0,sWidth,sHeight);
			progressmask.graphics.endFill();
		}
		private function drawButtons():void
		{
			controls.x = pad+rad;
			controls.y = h-pad-hControls+38;
			controls.filters = [new GlowFilter(0,0.1,8,8,3)];
			var startX:Number = 95;
			 
			var play:RoundToggleButton = new RoundToggleButton(17,17);
			controls.addChild( play );
			play.addEventListener(MouseEvent.CLICK,video.playPause);
			play.x = startX;
			
			var stopp:RoundStopButton = new RoundStopButton(17,17);
			controls.addChild( stopp );
			stopp.addEventListener(MouseEvent.CLICK,video.stop);
			stopp.x = startX+45;
			
			var mute:RoundMuteButton = new RoundMuteButton(17,17);
			controls.addChild( mute );
			mute.addEventListener(MouseEvent.CLICK,video.mute);
			mute.x = startX+90;
			
			controls.graphics.clear();
			controls.graphics.moveTo(startX+32,-2);
			controls.graphics.lineStyle(1,0xbbbbbb,1,true);
			controls.graphics.lineTo(startX+32,18);
			controls.graphics.moveTo(startX+32+45,-2);
			controls.graphics.lineStyle(1,0xbbbbbb,1,true);
			controls.graphics.lineTo(startX+32+45,18);
		}
		
		/**
		 * Scrubbing video
		 **/
		 
		private function startScrubbing(e:MouseEvent):void
		{
			isScrubbing = true;
			setScrubbing(e);
		}
		private function setScrubbing(e:MouseEvent):void
		{
			if(isScrubbing && video.duration){
				var xOffset:Number = progressbar.x;
				var xClick:Number  = e.stageX-xOffset;
				var percent:Number = xClick / progressbar.width;
				if(percent < 0){ percent = 0; }
				if(percent > 1){ percent = 1; }
				var time:Number = ( video.duration*percent );
				
				video.seek( time );
				setTime(elapsedTime,formatTime(time));
				drawProgress(percent);
			}
		}
		private function stopScrubbing(e:MouseEvent):void
		{
			if(isScrubbing){
				isScrubbing = false;
				video.play();
			}
		}
		
		/**
		 * Time functions
		 **/
		private function setTotal(e:VideoEvent):void
		{
			var time:Number = e.object as Number; 
			setTime(totalTime,formatTime(time));
		}
		private function setCurrentTime(e:VideoEvent):void
		{
			var time:Number = e.object as Number; 
			setTime(elapsedTime,formatTime(time));
			if(video.duration != 0){
				var prog:Number = video.currentTime/video.duration;
				drawProgress( prog );
			}
		}
		private function setTime(tf:TextField, txt:String):void
		{
			tf.text = txt;
			if(tf == elapsedTime){
				format.align = TextFormatAlign.LEFT;
			} else {
				format.align = TextFormatAlign.RIGHT;
			}
			tf.setTextFormat( format );
		}
		
		/**
		 * @author andrewwright
		 * Returns time in hh:mm:ss format from seconds
		 **/
		public static function formatTime ( time:Number ):String
		{
			var remainder:Number;
			var hours:Number = time / ( 60 * 60 );
			remainder = hours - (Math.floor ( hours ));
			hours = Math.floor ( hours );
			
			var minutes:Number = remainder * 60;
			remainder = minutes - (Math.floor ( minutes ));
			minutes = Math.floor ( minutes );
			
			var seconds:Number = remainder * 60;
			remainder = seconds - (Math.floor ( seconds ));
			seconds = Math.floor ( seconds );
			
			var hString:String = hours < 10 ? "0" + hours : "" + hours;	
			var mString:String = minutes < 10 ? "0" + minutes : "" + minutes;
			var sString:String = seconds < 10 ? "0" + seconds : "" + seconds;
						
			if ( time < 0 || isNaN(time)) return "00:00";
			if ( hours > 0 )
			{			
				return hString + ":" + mString + ":" + sString;
			}else {
				return mString + ":" + sString;
			}
		}
	}
}
