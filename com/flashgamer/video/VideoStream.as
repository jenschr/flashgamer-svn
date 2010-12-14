package com.flashgamer.video
{
	import com.flashgamer.events.VideoEvent;
	
	import flash.display.Sprite;
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	public class VideoStream extends Sprite
	{
		private var _netStream:NetStream;
		private var video:Video;
		private var _file:String;
		private var _isPlaying:Boolean = false;
		private var isBuffered:Boolean = false;
		private var oldVolume:Number = 1;
		private var isEnded:Boolean = true;
		private var _w:Number;
		private var _h:Number;
		
		private var _autoSize:Boolean = true;
		private var _autoPlay:Boolean = true;
		public var loop:Boolean = false;
		public var duration:Number = 0;
		public var time:Number = 0;
		public var lastVideoPosition:Number = 0;
		
		/**
        * Defines the NetConnection we'll use
        */
        public var nc:NetConnection;
        
		public function VideoStream(file:String = null, width:Number = 0, height:Number = 0)
		{
			_w = width;
			_h = height;
			this.file = file;
			
			// Use null connection for progressive files
			nc = new NetConnection();
			nc.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler,false,0,true);
			nc.addEventListener(SecurityErrorEvent.SECURITY_ERROR,securityErrorHandler,false,0,true);
        	nc.connect(null);
        	
        	this.addEventListener(Event.ENTER_FRAME,progressHandler,false,0,true);
		}

		/**
        * Forces a certain size
        */
		public function setSize(width:Number, height:Number):void
		{
			trace("**** setSize "+width+":"+height);
			_w = width;
			_h = height;
            video.width = _w;
            video.height = _h;
            autoSize = false;
		}

		/**
        * Toggles playback
        */
		public function playPause(e:* = null):void
		{
//			trace("playPause "+isPlaying);
			if(isPlaying){
				pause();
			} else {
				play();
			}
		}
		/**
        * Plays the NetStream object. The material plays the NetStream object by default at init. Use this handler only if you pause the NetStream object;
        */
		public function play(e:*= null):void
		{
//			trace("play isStarted "+isStarted);
			if(_netStream.time != 0 && !isEnded){
				_netStream.resume();
				isPlaying = true;
			} else {
				_netStream.play(file);
				isEnded = false;
			}
		}
		
		/**
        * Pauses the NetStream object
        */
		public function pause(e:*= null):void
		{
			_netStream.pause();
			isPlaying = false;
		}
		
		/**
        * Pauses the NetStream object nd sets position to 0
        */
		public function stop(e:*= null):void
		{
			pause();
			_netStream.seek(0);
		}
		
		/**
        * Seeks to a given time in the file, specified in seconds, with a precision of three decimal places (milliseconds).
		* For a progressive download, you can seek only to a keyframe, so a seek takes you to the time of the first keyframe after the specified time. (When streaming, a seek always goes to the precise specified time even if the source FLV file doesn't have a keyframe there.) 
		* @param	val		Number: the playheadtime
        */
		public function seek(val:Number):void
		{ 
			pause();
			_netStream.seek(val);
		}
		
		private function whenAdded(e:Event):void
		{
			trace("whenAdded "+e);
			this.addEventListener(Event.ENTER_FRAME,progressHandler,false,0,true);
		}
		private function whenRemoved(e:Event):void
		{
			this.removeEventListener(Event.ENTER_FRAME,progressHandler,false);
		}
        private function playStream():void
        {
        	video = new Video(_w,_h);
        	video.smoothing = true;
        	this.addChild( video );
        	this.mouseEnabled = false;
        	
        	// setup stream and start it
        	_netStream = new NetStream(nc);
			_netStream.checkPolicyFile = true;
        	_netStream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler,false,0,true);
			_netStream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, ayncErrorHandler,false,0,true);
			_netStream.addEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler,false,0,true);
			play();
			
			// ignore metadata
			var anyObject:Object = {};
			anyObject["onCuePoint"] = metaDataHandler;
			anyObject["onMetaData"] = metaDataHandler;
			_netStream.client = anyObject;
			
			video.attachNetStream(_netStream);
        }
		private function netStatusHandler(e:NetStatusEvent):void
		{
			//trace("netStatusHandler "+e.info["code"])
            switch (e.info["code"]) {
                case "NetStream.Play.Stop": 
					dispatchEvent( new VideoEvent(VideoEvent.STOP,_netStream, file) );
					isPlaying = false;
					if(loop){ _netStream.play(file); }
					break;
                case "NetStream.Play.Start":
                    dispatchEvent( new VideoEvent(VideoEvent.PLAY_START,_netStream, file) );
					isPlaying = true;
					break;
                case "NetStream.Buffer.Empty":
					isEnded = true; // When the video ends, it'll dispatch this event - thus we should no longer resume, but rather play()
					break;
                case "NetStream.Play.Play":
					dispatchEvent( new VideoEvent(VideoEvent.PLAY,_netStream, file) );
					isPlaying = true;
					break;
                case "NetStream.Play.StreamNotFound":
					showError("The file "+file+"was not found", e);
					break;
                case "NetConnection.Connect.Success":
					playStream(); // Always start playing upon connect
					break;
                case "NetStream.Buffer.Full":
					if(!isBuffered){
                        isBuffered = true;
                        if(autoPlay){
                            play();
                        } else {
                            pause();
                        }
                    } // upon load, we want the movie to start loading, but only display frame 1 (no autostart)
					break;
            }
        }

        private function adjustSize(w:Number,  h:Number):void
        {
            if(autoSize){
                _w = w;
                _h = h;
                video.width = _w;
                video.height = _h;
            }
        }
		
		
		/**
        * Returns the actual time of the netStream
        */
		public function get currentTime():Number
		{
			return Math.floor( _netStream.time );
		}
		/**
        * Returns the actual time of the netStream
        */
		public function get totalTime():Number
		{
			return _netStream.decodedFrames;
		}
		/**
        * The sound pan
		* @param	val		Number: the sound pan, a value from -1 to 1. Default is 0;
        */
		public function set pan(val:Number):void
		{
            var transform:SoundTransform = _netStream.soundTransform;
            transform.pan = val;
            _netStream.soundTransform = transform;
        }
		/**
        * The sound volume
		* @param	val		Number: the sound volume, a value from 0 to 1. Default is 0;
        */
        public function set volume(val:Number):void
		{
            var transform:SoundTransform = _netStream.soundTransform;
            transform.volume = val;
            _netStream.soundTransform = transform;
            if(val != 0){
            	oldVolume = val;
            }
        }
        public function get volume():Number
		{
            var transform:SoundTransform = _netStream.soundTransform;
            return transform.volume;
        }
        
		/**
        * The sound volume
		* @param	val		Number: the sound volume, a value from 0 to 1. Default is 0;
        */
        public function mute(e:*=null):void
		{
            if(volume == 0){
            	volume = oldVolume;
            } else {
            	volume = 0;
            }
        }
        
        // Event handling
        private function progressHandler(e:Event):void
		{
			if(isPlaying && lastVideoPosition != currentTime){
				lastVideoPosition = currentTime;
				dispatchEvent( new VideoEvent(VideoEvent.PROGRESS,_netStream, file,lastVideoPosition) );
				time = _netStream.time;
			}
		}
		private function ayncErrorHandler(event:AsyncErrorEvent): void
		{
			// Must be present to prevent errors, but won't do anything
		}
		
		private function metaDataHandler(oData:Object = null):void
		{
			// Offers info such as oData.duration, oData.width, oData.height, oData.framerate and more (if encoded into the FLV)
			if(oData.duration){
				duration = oData.duration;
				dispatchEvent( new VideoEvent(VideoEvent.METADATA,_netStream, file,duration) );
			}
            if(oData.width && oData.height){
                adjustSize(oData.width, oData.height);
			}
		}
		
		private function ioErrorHandler(e:IOErrorEvent):void
		{
			showError("An IOerror occured: "+e.text);
		}
		
		private function securityErrorHandler(e:SecurityErrorEvent):void
		{
			showError("A security error occured: "+e.text+" Remember that the FLV must be in the same security sandbox as your SWF.");
		}
		
		private function showError(txt:String, e:* = null):void
		{
			trace(txt+":"+e);
		}

        public function get file():String
        {
            return _file;
        }

        public function set file(value:String):void
        {
            _file = value;
            if(_file && _file.length > 4){
                isBuffered = true;
                _netStream.play(_file);
            }
        }

        public function get autoPlay():Boolean
        {
            return _autoPlay;
        }

        public function set autoPlay(value:Boolean):void
        {
            _autoPlay = value;
        }

        public function get autoSize():Boolean
        {
            return _autoSize;
        }

        public function set autoSize(value:Boolean):void
        {
            _autoSize = value;
        }

        public function get isPlaying():Boolean
        {
            return _isPlaying;
        }

        public function set isPlaying(value:Boolean):void
        {
            _isPlaying = value;
        }
    }
}