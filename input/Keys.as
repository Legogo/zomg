package	zomg.input
{
	import adobe.utils.CustomActions;
	import flash.display.Stage;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;

	/*
	 * http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/ui/Keyboard.html
	 * */
	
	public class Keys
	{
		static private var keys:Vector.<Boolean>; // All keys
		static private var keysPress:Vector.<uint>;
		static private var keysRelease:Vector.<uint>;
		
		static private var _lastPressed:uint; // Keycode
		static private var _lastReleased:uint; // Keycode
		static private var _stage:Stage;
		
		static public function init(s:Stage = null):Boolean
		{
			if (_stage != null) {
				if (s == null) return false;
				else return true;
			}
			
			_stage = s;
			
			keys = new Vector.<Boolean>();
			keysRelease = new Vector.<uint>();
			keysPress = new Vector.<uint>();
			
			for (var i:uint = 0; i < 255; i++) {
				keys.push(false);
				keysRelease.push(0);
				keysPress.push(0);
			}
			
			toggleKeys(true);
			
			return true;
		}
		
		static private function myKeyDown(e:KeyboardEvent):void {
			pressKey(e.keyCode);
		}
		
		static private function myKeyUp(e:KeyboardEvent):void {
			keys[e.keyCode] = false;
			keysRelease[e.keyCode] = 2;
			lastReleased = e.keyCode;
		}
		
		static public function pressKey(keyCode:uint):void {
			if(!keys[keyCode])	keysPress[keyCode] = 2;
			keys[keyCode] = true;
			
			//justPressed.push(e.keyCode);
			lastPressed = keyCode;
		}
		
		static public function getKeyState(keyCode:uint):Boolean {
			return keys[keyCode];
		}
		static public function getKeyPressState(keyCode:uint):Boolean {
			return (keysPress[keyCode] > 0 && keysRelease[keyCode] == 0);
		}
		static public function getKeyReleaseState(keyCode:uint):Boolean {
			return (!keys[keyCode] && keysRelease[keyCode] > 0);
		}
		
		// Remet toute les touches à false
		static public function clean():void {
			var i:uint;
			for (i = 0; i < keys.length; i++)	keys[i] = false;
			for (i = 0; i < keysRelease.length; i++)	keysRelease[i] = 0;
		}
		
		static public function update(evt:Event):void {
			var i:uint = 0;
			for (i = 0; i < keysRelease.length; i++)	if(keysRelease[i] > 0)	keysRelease[i]--;
			for (i = 0; i < keysPress.length; i++)	if(keysPress[i] > 0)	keysPress[i]--;
		}
		
		// Si l'ensemble des touches sont actives ou non
		static public function toggleKeys(active:Boolean):void {
			
			if (!_stage.hasEventListener(KeyboardEvent.KEY_DOWN)) {
				_stage.addEventListener(KeyboardEvent.KEY_DOWN, myKeyDown );
				_stage.addEventListener(KeyboardEvent.KEY_UP, myKeyUp);
				_stage.addEventListener(Event.ENTER_FRAME, update);
			}else if(_stage.hasEventListener(KeyboardEvent.KEY_DOWN)) {
				_stage.removeEventListener(KeyboardEvent.KEY_DOWN, myKeyDown);
				_stage.removeEventListener(KeyboardEvent.KEY_UP, myKeyUp);
				_stage.removeEventListener(Event.ENTER_FRAME, update);
				
				clean();
			}
			
			//trace("Keys >> toggle ("+owner+") : " + isActive);
		}
		
		static public function active():Boolean {	return _stage.hasEventListener(KeyboardEvent.KEY_DOWN); }
		
		static public function get lastPressed():uint { return _lastPressed; }
		static public function set lastPressed(v:uint):void { _lastPressed = v; }
		static public function get lastReleased():uint { return _lastReleased; }
		static public function set lastReleased(v:uint):void { _lastReleased = v; }
		
		static public function moveKeysPressed():Boolean {
			return (keys[KeysIndex.LEFT] || keys[KeysIndex.RIGHT] || keys[KeysIndex.UP] || keys[KeysIndex.DOWN]);
			
		}
	}
}