package zomg
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.utils.getTimer;
  
	/**
	 * @author André Berlemont
   * http://www.andreberlemont.com
   * Github branch : https://github.com/Legogo/zomg.git
	 */
  
	public class DeltaTime 
	{
		static public var time:Number = 0;
		static public var delta:Number = 0;
		
		static public function init(stage:Stage = null):void {
			delta = time = 0;
			
			if (stage == null) {
				trace("WARNING > DeltaTime > delta won't update, no stage");
				return;
			}
			stage.addEventListener(Event.ENTER_FRAME, update);
		}
		
		static public function update(evt:Event = null):void {
			delta = (getTimer() - time) / 1000;
			time = getTimer();
			
			//Console.log("Time", "delta ? " + delta + ", time ? " + time);
		}
	}

}