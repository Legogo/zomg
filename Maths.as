package zomg
{
	import flash.display.Sprite;
	import flash.geom.Point;
  
	/**
	 * @author André Berlemont
   * http://www.andreberlemont.com
   * Github branch : https://github.com/Legogo/zomg.git
	 */
  
	public class Maths
	{
		
		// NUMBERS
		public static function threshold(min:Number, max:Number, val:Number):Number {
			if (val < min)	val = min;
			else if (val > max)	val = max;
			return val;
		}
		
		public static function thresholdInt(min:int, max:int, val:int):int {
			if (val < min)	val = min;
			else if (val > max)	val = max;
			return val;
		}
		
		public static function sign(val:Number):Number {
			if (val > 0)	return 1;
			else if (val < 0)	return -1;
			
			return 0;
		}
		
		static public function isBetween(x:Number, min:Number, max:Number):Boolean {
			if (x < min || x > max)	return false;
			return true;
		}
		
		//Check si la valeur est proche de zero. Limit est l'écart au dessus/dessous de 0.
		public static function isNearZeroThreshold(limit:Number, val:Number):Number {
			if (val > -limit && val < limit)	return 0;
			else return val;
		}
		
		public static function isNearValue(val:Number, nearValue:Number, gap:Number = 0.1, deg:Boolean = false):Boolean {
			var interv:Point = new Point(nearValue-gap, nearValue + gap);
			var flag:Boolean = false;
			
			if (val < interv.y && val > interv.x )	flag = true;
			else {
				if (deg) {
					var intervB:Point = new Point();
					
					if (nearValue + gap > 360) {
						intervB.x = 0;
						intervB.y = nearValue + gap - 360; // [0,3]
					}else if (nearValue - gap < 0) {
						intervB.x = 360 - nearValue - gap;  // [357,360]
						intervB.y = 360;
					}
					
					if (val < intervB.y && val > intervB.x)	flag = true;
					
					//trace("value:"+val+" / nearvalue:"+nearValue+" / A:"+interv + " - B:" + intervB+ " == "+flag);
				}
			}
			
			return flag;
		}
		
		static public function reduceToMax(aim:Number, step:Number, value:Number):Number {
			
			if (Math.abs(value) > Math.abs(aim))
				return value += (-Maths.sign(aim) * step);
			
			return value;
		}
		
		static public function roundNear(val:Number, digit:Number = 2):Number {
			var num:Number = Math.pow(10, digit);
			return (Math.round(val * num)/num);
		}
		
		public static function randomBetween(min:Number, max:Number, round:Boolean = false):Number	{
			var val:Number = (Math.random() * (max - min) + min);
			if (round)	return Math.round(val); // Arrondie au plus proche
			return val;
		}
		
		public static function getRandomVector(Xminmax:Point, Yminmax:Point, round:Boolean = false):Point {
			return new Point(Maths.randomBetween(Xminmax.x, Xminmax.y, round), Maths.randomBetween(Yminmax.x, Yminmax.y, round));
		}
		
		static public function randomBoolean():Boolean {
			if (Math.random() > 0.5)	return true;
			return false;
		}
		
		static public function linearTransform(intA:Point, intB:Point, val:Number):Number{
			return (((val - intA.x) / (intA.y - intA.x)) * (intB.y - intB.x)) + intB.x;
		}
		
		//GEOM
		
		//hypothénus = côté adjacent / cosinus (angle)
		//puis A² = B² + C²
		
		static public function getAdj(adjLen:Number, adjAng:Number):Number {
			var hyp:Number = adjLen / Math.cos(adjAng);
			return Math.sqrt(Math.pow(hyp, 2) - Math.pow(adjLen, 2));
		}
		
		static public function getAdjAngle(adjLen:Number, oppoLen:Number):Number {
			/*
			 * Avec A l'angle droit. Triangle CAB. Recup l'angle de C.
			 * A---B
			 * |  /
			 * | /
			 * |/
			 * C
			 * */
			
			var hyp:Number = Math.sqrt(Math.pow(adjLen, 2) + Math.pow(oppoLen, 2));
			var c:Number = adjLen / hyp;
			return Maths.radianToDegree(Math.acos(c));
		}
		
		// VECTOR
		
		static public function distance(pta:Point, ptb:Point):Number {
			return Math.sqrt(Math.pow((ptb.x - pta.x), 2) + Math.pow((ptb.y - pta.y), 2));
		}
		
		static public function normalize(pt:Point):Point {
			var length:Number = Math.sqrt((pt.x * pt.x) + (pt.y * pt.y));
			if (length != 0)	return new Point(pt.x / length, pt.y / length);
			else return new Point();
		}
		
		static public function destinationPoint(origin:Point, dir:Point, lenght:Number):Point {
			return new Point((origin.x + dir.x * lenght), (origin.y + dir.y * lenght));
		}
		
		static public function vectorLength(pt:Point):Number {
			return Math.sqrt(Math.pow(pt.x, 2) + Math.pow(pt.y, 2));
		}
		
		static public function getDirectionObj(me:Object, aim:Object ):Point {
			return normalize(new Point(aim.x - me.x, aim.y - me.y));
		}
		
		static public function getDirectionVec(myPos:Point, aimPos:Point ):Point {
			return normalize(new Point(aimPos.x - myPos.x, aimPos.y - myPos.y));
		}
		
		static public function getAngleVector180(pt:Point):Number {
			var angle:Number = Maths.radianToDegree(Math.acos(pt.x));
			if (pt.y < 0)	return -angle;
			else if (pt.y > 0)	return angle;
			else return 0;
		}
		
		static public function getAngleVector(myPos:Point, aimPos:Point):Number {
			var angle:Number = Maths.dirRotation(myPos, aimPos);
			if (angle < 0)	return -angle; // Au dessus
			return 360 - angle; // En dessous
		}
		
		static public function getCirclePointAngle(circleCenter:Point, radius:Number, deg:Number):Point {
			return Maths.destinationPoint(circleCenter, angleToVector(deg), radius);
		}

		static public function angleToVector(angle:Number):Point {
			var rad:Number = Maths.degreeToRadian(angle);
			return new Point(Math.cos(rad), Math.sin(rad));
		}
		
		static public function getVectorAngle(pt:Point):Number {
			var degCos:Number = Maths.radianToDegree(Math.acos(pt.x));
			
			if (pt.x > 0) {
				if (pt.y == 0)	return 0;
				else if (pt.y > 0)	return degCos;
				else if (pt.y < 0)	return 360 - degCos;
			}else if (pt.x < 0) {
				if(pt.y == 0)	return 180;
				else if(pt.y > 0)	return degCos;
				else if(pt.y < 0)	return 180 + (180 - degCos);
			}else if (pt.x == 0) {
				if(pt.y == 0)	return 0;
				else if(pt.y > 0)	return 90;
				else if(pt.y < 0)	return 270;
			}
			
			return 0;
		}
		
		static public function addDirRotation(dir:Point, rot:Number = 90):Point {
			var diff:Number = Maths.degreeToRadian(Maths.radianToDegree(Math.acos(dir.x)) + rot);
			var pt:Point = new Point(Math.cos(diff), Math.sin(diff));
			//trace("Radian : "+diff+" - pt : "+pt);
			return pt;
		}
		
		
		//Look at
		static public function dirRotation(pta:Point, ptb:Point):Number {
			return Math.atan2(ptb.y - pta.y, ptb.x - pta.x) / (Math.PI / 180);
		}
		
		// DEGREE RADIAN
		static public function degreeToRadian(angle:Number):Number {
			return (angle * (Math.PI / 180));
		}
		
		static public function radianToDegree(angle:Number):Number {
			return (angle * (180 / Math.PI));
		}
		
		static public function circleInter(home:Point, dest:Point, circleCenter:Point, circleRadius:Number):Point {
			var a:Number = Math.pow((dest.x - home.x), 2) + Math.pow((dest.y - home.y), 2);
			var b:Number = 2 * ( ((dest.x - home.x) * (home.x - circleCenter.x)) + ((dest.y - home.y) * (home.y - circleCenter.y)) );
			var c:Number = Math.pow(circleCenter.x, 2) + Math.pow(circleCenter.y, 2) + Math.pow(home.x, 2) + Math.pow(home.y, 2) - (2 * ((circleCenter.x * home.x) + (circleCenter.y * home.y))) - Math.pow(circleRadius, 2);
			
			var coef:Number = b * b - 4 * a * c;
			var k1:Number = 0;
			var k2:Number = 0;
			
			var ptA:Point = new Point();
			var ptB:Point = new Point();
			
			if (coef == 0) {
				//trace("only one point");
				k1 = -b / (2 * a);
			}else if (coef > 0) {
				k1 = ( -b - Math.sqrt(coef)) / (2 * a);
				k2 = ( -b + Math.sqrt(coef)) / (2 * a);
				//trace("Two points ("+coef+") "+k1+","+k2);
			}
			//Si coerf < 0, no points
			
			
			//On retourne le point le plus proche de "home"
			if (k1 != 0) {
				ptA = new Point(home.x + (k1 * (dest.x - home.x)), home.y + (k1 * (dest.y - home.y)));
				var distA:Number = Maths.distance(home, ptA);
				
				if (k2 != 0) {
					ptB = new Point(home.x + (k2 * (dest.x - home.x)), home.y + (k2 * (dest.y - home.y)));
					var distB:Number = Maths.distance(home, ptB);
					
					
					if (distA < distB)	return ptA;
					else return ptB;
				}else return ptA;
			}
			
			return new Point();
		}
		
	}

}