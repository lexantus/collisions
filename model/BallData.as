//__________UTILS_____________
import flash.geom.Point;

class model.BallData
{
		private var _x:Number;
		private var _y:Number;
		private var _radius:Number;
		private var _mass:Number;
		private var _angle:Number;
		
		private var _tempX:Number;
		private var _tempY:Number;
		private var _speedX:Number;
		private var _speedY:Number;
		
		public function get radius():Number 
		{
			return _radius;
		}
		public function set radius(value:Number):Void 
		{
			_radius = value;
		}
		public function get angle():Number 
		{
			return _angle;
		}
		public function set angle(value:Number):Void 
		{
			_angle = value;
		}
		public function get speedX():Number 
		{
			return _speedX;
		}
		public function set speedX(value:Number):Void 
		{
			_speedX = value;
		}
		public function get speedY():Number 
		{
			return _speedY;
		}
		public function set speedY(value:Number):Void 
		{
			_speedY = value;
		}
		public function get tempX():Number 
		{
			return _tempX;
		}
		public function set tempX(value:Number):Void 
		{
			_tempX = value;
		}
		public function get tempY():Number 
		{
			return _tempY;
		}
		public function set tempY(value:Number):Void 
		{
			_tempY = value;
		}
		public function get mass():Number 
		{
			return _mass;
		}
		public function set mass(value:Number):Void 
		{
			_mass = value;
		}
		public function get x():Number 
		{
			return _x;
		}
		public function set x(value:Number):Void 
		{
			_x = value;
		}
		public function get y():Number 
		{
			return _y;
		}
		public function set y(value:Number):Void 
		{
			_y = value;
		}
}