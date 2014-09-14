//__________MODEL_____________
import model.Model;
import model.BallData;

//__________VIEWS_____________
import view.BallView;

//__________UTILS_____________
import flash.geom.Point;


class controller.StartScreenViewController
{
	
	public function StartScreenViewController()
	{
		fscommand("allowscale", "true");
		
		try
		{
			Model.gi().fetchXML(handleXMLData, start);
		
		}catch (e:Error) {
			
			// do something to continue app working
		}
	}
	
	private function start():Void
	{
		initBalls();
		
		_root["tick"] = tick;
		
		_root.onEnterFrame = function():Void
		{	
			tick();
		}
		
		function tick():Void
		{
			updatePositions();
			collisionDetection();
			
			checkCollisionWithWalls();
			moveBalls();
		}
				
	
		function initBalls():Void
		{
			var ballsData:Array = Model.gi().ballsData;

			var mc:MovieClip;
			
			for (var i:Number = 0; i < ballsData.length; i++)
			{
				mc = _root.attachMovie("ball", "ball" + i, _root.getNextHighestDepth());
				mc._x = ballsData[i].x;
				mc._y = ballsData[i].y;
				mc._width = mc._height = 2 * ballsData[i].radius;
			}
		}
		
		function updatePositions():Void
		{
			var ballsData:Array = Model.gi().ballsData;
			
			for (var i:Number = 0; i < ballsData.length; i++)
			{
				ballsData[i].x = _root["ball" + i]._x;
				ballsData[i].y = _root["ball" + i]._y;
			}
		}
		
		function moveBalls():Void
		{
			var ballsData:Array = Model.gi().ballsData;
			var ballData:BallData;
			
			for (var i:Number = 0; i < ballsData.length; i++)
			{
				ballData = ballsData[i];
					
				_root["ball" + i]._x = ballData.x + ballData.speedX;
				_root["ball" + i]._y = ballData.y + ballData.speedY;	
			}
		}
		
		function collisionDetection()
		{
			var ballsData:Array = Model.gi().ballsData;
			
			for (var i:Number = 0; i < (ballsData.length - 1); i++)
			{	
				for (var j:Number = i+1; j < ballsData.length; j++)
				{
					 var x1:Number = new Number(ballsData[i].x + ballsData[i].speedX);
					 var y1:Number = new Number(ballsData[i].y + ballsData[i].speedY);
					 
					 var x2:Number = new Number(ballsData[j].x + ballsData[j].speedX);
					 var y2:Number = new Number(ballsData[j].y + ballsData[j].speedY);
					 
					 var distance:Number = Math.sqrt(Math.pow(x1 - x2, 2) + Math.pow(y1 - y2, 2));
					 var radiusSum:Number = ballsData[i].radius + ballsData[j].radius;
					 
					 trace("distance = " + distance + " radiusSum = " + radiusSum);
					 
					 if (distance < radiusSum)
					 {
						 trace("collistion");
						 reaction(ballsData[i], ballsData[j]);
					 }
				}
			}
		}
		
		function reaction(ballData1:BallData, ballData2:BallData, time:Number):Void
		{
			// get the masses
			var mass1:Number = ballData1.mass;
			var mass2:Number = ballData2.mass;
				
			// set initial velocity vars
			var xVel1:Number = ballData1.speedX;
			var xVel2:Number = ballData2.speedX;
			var yVel1:Number = ballData1.speedY;
			var yVel2:Number = ballData2.speedY;
							
			var run:Number = ballData1.x - ballData2.x;
			var rise:Number = ballData1.y - ballData2.y;
			var Theta:Number = Math.atan2(rise, run);
			var cosTheta:Number = Math.cos(Theta);
			var sinTheta:Number = Math.sin(Theta);
				
			// find the velocities along the line of action
			var xVel1prime:Number = xVel1 * cosTheta + yVel1 * sinTheta;
			var xVel2prime:Number = xVel2 * cosTheta + yVel2 * sinTheta;
				
			// find the velocities perpendicular to the line of action
			var yVel1prime:Number = yVel1 * cosTheta - xVel1 * sinTheta;
			var yVel2prime:Number = yVel2 * cosTheta - xVel2 * sinTheta;
				
			// conservation equations
			var P:Number = (mass1 * xVel1prime + mass2 * xVel2prime);
			var V:Number = (xVel1prime - xVel2prime);
			var v2f:Number = (P + mass1 * V) / (mass1 + mass2);
			var v1f:Number = v2f - xVel1prime + xVel2prime;
			var xVel1prime:Number = v1f;
			var xVel2prime:Number = v2f;
				
			// project back to Flash's x and y axes
			var xVel1:Number = xVel1prime * cosTheta - yVel1prime * sinTheta;
			var xVel2:Number = xVel2prime * cosTheta - yVel2prime * sinTheta;
			var yVel1:Number = yVel1prime * cosTheta + xVel1prime * sinTheta;
			var yVel2:Number = yVel2prime * cosTheta + xVel2prime * sinTheta;
					
			ballData1.speedX = xVel1;
			ballData2.speedX = xVel2;
			ballData1.speedY = yVel1;
			ballData2.speedY = yVel2;
		}	
		
		function checkCollisionWithWalls():Void
		{	
			var ballData:BallData;
			
			for (var i:Number = 0; i < Model.gi().ballsData.length; i++)
			{
				ballData = Model.gi().ballsData[i];
				ballData.tempX = ballData.x + ballData.speedX;
				ballData.tempY = ballData.y + ballData.speedY;
				
				if (ballData.tempX < ballData.radius) 
				{
					ballData.tempX = ballData.radius;
					ballData.speedX *= -1;
							
				}else if (ballData.tempX > (Stage.width - ballData.radius))
				{
					ballData.tempX = Stage.width - ballData.radius;
					ballData.speedX *= -1;
				}	
							
				if (ballData.tempY < ballData.radius) 
				{
					ballData.tempY = ballData.radius;
					ballData.speedY *= -1;
							
				}else if (ballData.tempY > (Stage.height - ballData.radius))
				{
					ballData.tempY = Stage.height - ballData.radius;
					ballData.speedY *= -1;
				}	
			}
		}
	}
	
	private function handleXMLData(success:Boolean):Void
	{
		if (success)
		{
			var xmlData:XML = Model.gi().xmlData;
				
			var listNode:XMLNode = xmlData.firstChild;
					
			var numNodes:Number = listNode.childNodes.length;
				
			var ballsData:Array = Model.gi().ballsData;
				
			for (var i:Number = 0; i < numNodes; i++)
			{
				 var ballData:BallData = new BallData();
				 var ballAttributes:Array = listNode.childNodes[i].attributes;
					 
				 ballData.x = new Number(ballAttributes["x"]);
				 ballData.y = new Number(ballAttributes["y"]);
												
				 ballData.radius = new Number(ballAttributes["radius"]);
				 ballData.mass = new Number(ballData.radius * 5);
				 ballData.angle = new Number(ballAttributes["angle"]);
				 var speed:Number = new Number(ballAttributes["speed"]);
					 
				 ballData.speedX = speed * Math.cos(ballData.angle * Math.PI / 180);
				 ballData.speedY = speed * Math.sin(ballData.angle * Math.PI / 180);
				
				 ballsData.push(ballData);
			}
				
				// TODO: find balls intersections and correct them or show error message
				
				this.start();
				
		}else {
				
			throw new Error("ERROR: Fail load xml data.");
		}	
	}
}