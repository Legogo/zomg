package zomg
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author ...
	 */
	public class Color
	{
		public var num:uint = 0; // 0xXXXXXX
		
		public function Color(value:uint = 0, alpha:int = 255)
		{
			this.num = value;
			if(alpha < 255)	this.alpha = alpha;
		}
		
    public function getColor():uint {
      return num;
    }
    
		public function set alpha(v:int):void {
			num = rgbaToUint(getComponentValue(num, "r"), getComponentValue(num, "b"), getComponentValue(num, "b"), v);
		}
		
		public function toString():String {
			var str:String = "ColorManager >> ";
			
			// http://www.adobe.com/devnet/flash/articles/bitwise_operators_print.html
			
			str += " A:" + ((num & 0xFF000000) >>> 24);
			str += " R:" + ((num & 0x00FF0000) >>> 16);
			str += " G:" + ((num & 0x0000FF00) >>> 8);
			str += " B:" + (num & 0x000000FF);
			
			return str;
		}
		
		// ###### STATIC
		
		static public function setSpriteColor(sprite:Sprite, color:uint):void {
			var r:Number = color >> 16 & 0xFF;
			var g:Number = color >> 8 & 0xFF;
			var b:Number = color & 0xFF;
			trace(r,g,b)
			sprite.transform.colorTransform = new ColorTransform(0, 0, 0, 255, r, g, b, 255);
		}
		
		static public function changeAlpha(target:BitmapData, alpha:uint = 255):void {
            var ct:ColorTransform = new ColorTransform();
            ct.alphaMultiplier = alpha;
            target.colorTransform(new Rectangle(0, 0, target.width, target.height), ct);
        }
		
		static public function setColor(target:BitmapData, color:uint, alpha:uint = 255):void {
            var ct:ColorTransform = new ColorTransform();
            ct.color = color;
            ct.alphaMultiplier = alpha;
            target.colorTransform(new Rectangle(0, 0, target.width, target.height), ct);
        }
		
		
		static public function drawCross(length:Number = 10, tickness:Number = 1, color:uint = 0xFF0000):Sprite {
			var s:Sprite = new Sprite();
			s.graphics.lineStyle(3, color);
			s.graphics.moveTo( -length, 0);
			s.graphics.lineTo(length, 0);
			s.graphics.moveTo(0, -length);
			s.graphics.lineTo(0, length);
			
			return s;
		}
		
		static public function rgbaToUint(r:Number = 0, g:Number = 0, b:Number = 0, a:Number = 255):uint
		{
			return (0 & 0xFFFFFFFF) + (a << 24) + (r << 16) + (g << 8 ) + b;
			//return (a + 0xFF) + (r & 0x00FF0000) + (g & 0x0000FF00) + (b & 0x000000FF);
		}
		
		//public static function uintToRgba(color:uint,component:String)
		
		static public function getPixelComponent(map:BitmapData, x:Number, y:Number, component:String):Number
		{
			return  getComponentValue(map.getPixel32(x, y), component);
		}
		
		static public function getComponentValue(color:uint, component:String):Number
		{
			switch(component) {
				case "a" : return ((color & 0xFF000000) >>> 24); break;
				case "r" : return ((color & 0x00FF0000) >>> 16); break;
				case "g" : return ((color & 0x0000FF00) >>> 8); break;
				case "b" : return (color & 0x000000FF); break;
				default : trace("World >> getPixelCompo error"); break;
			}
			
			return -1;
		}
		
		static public function uintToTransform(color:uint, alpha:int = 255):ColorTransform {
			var r:Number = color >> 16 & 0xFF;
			var g:Number = color >> 8 & 0xFF;
			var b:Number = color & 0xFF;
			
			return new ColorTransform(0, 0, 0, 0, r, g, b, alpha);
		}
		
		static public function getRandomColorComponent(component:String = "r", alpha:Number = 255):uint {
			var r:Number = 0;
			var g:Number = 0;
			var b:Number = 0;
			
			switch(component) {
				case "r" : r = Maths.randomBetween(0, 255); break;
				case "g" : g = Maths.randomBetween(0, 255); break;
				case "b" : b = Maths.randomBetween(0, 255); break;
			}
			
			alpha = Maths.threshold(0, 255, alpha);
			return new ColorTransform(0, 0, 0, 0, r,g,b, alpha).color;
		}
		
		static public function getRandomColor(alpha:Number = 255):uint {
			alpha = Maths.threshold(0, 255, alpha);
			return new ColorTransform(0, 0, 0, 0, Maths.randomBetween(0, 255),Maths.randomBetween(0, 255),Maths.randomBetween(0, 255), alpha).color;
		}
		
		static public function getRandomGrayscale(alpha:Number = 255, min:Number = 0, max:Number = 255):uint {
			alpha = Maths.threshold(0, 255, alpha); //cap
			var rand:Number = Maths.randomBetween(min, max);
			return new ColorTransform(0, 0, 0, 0, rand, rand, rand, alpha).color;
		}
		
		//from left, 0-100
		static public function getCroppedImage(sheet:BitmapData, percent:int):BitmapData {
			var qty:Number = (sheet.width / 100) * percent;
			if (qty > 0)	return getImageFromSheet(sheet, new Point(qty, sheet.height));
			
			return sheet;
		}
		
		static public function getImageFromSheet(sheet:BitmapData, size:Point, posOnSheet:Point = null):BitmapData {
			
			if (!posOnSheet)	posOnSheet = new Point();
			
			//trace("Zocolor > "+sheet, size, posOnSheet);
			
			var current:BitmapData = new BitmapData(size.x, size.y);
			
			var upLeft:Point = new Point((posOnSheet.y * size.x), ( posOnSheet.x * size.y ));
			var coord:Rectangle = new Rectangle(upLeft.x, upLeft.y, size.x, size.y);
			
			current.copyPixels(sheet, coord, new Point());
			
			return current;
		}
	}

}