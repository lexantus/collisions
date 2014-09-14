//__________MODEL_____________
import model.Model;
import model.BallData;
import mx.data.types.Int;

//__________VIEWS_____________
import view.BallView;

//__________UTILS_____________
import flash.geom.Point;


class controller.StartScreenViewController
{
	
	public function StartScreenViewController()
	{
		fscommand("allowscale", "false");
		
		try
		{
			Model.gi().fetchXML(handleXMLData, start);
		
		}catch (e:Error) {
			
			// do something to continue app working
		}
	}
	
	private function start():Void
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
		
		function updatePositions():Void
		{
			trace("update positions");
		}
		
		function moveBalls():Void
		{
			trace("move balls");
		}
		
		_root.onEnterFrame = function():Void
		{	
				for (i = 0; i < Model.gi().ballsData.length; i++)
				{
					var ballData:BallData =  Model.gi().ballsData[i];
					
					ballData.tempX = ballData.x + ballData.speedX;
					ballData.tempY = ballData.y + ballData.speedY;
					
					_root.checkCollisionWithWalls();
					
					ballData.tempX = ballData.x + ballData.speedX;
					ballData.tempY = ballData.y + ballData.speedY;
					
					//_root.checkCollisionWithWalls();
					
					_root.checkCollision();
					
					ballData.x = ballData.tempX + ballData.speedX;
					ballData.y = ballData.tempY + ballData.speedY;
					
					this["ball" + i]._x = ballData.tempX;
				    this["ball" + i]._y = ballData.tempY;	
				}
				
				_root["checkCollisionWithWalls"] = function(ballData:BallData):Void
				{	
					for (var i:Number = 0; i < Model.gi().ballsData.length; i++)
					{
						
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
				
				
				_root["checkCollision"] = function():Void
				{
					for (var i:Number = 0; i < Model.gi().ballsData.length; i++)
					{	
						for (var j:Number = i+1; j < Model.gi().ballsData.length; j++)
						{	
							
							var speedX1 = Model.gi().ballsData[i].speedX;
							var speedY1 = Model.gi().ballsData[i].speedY;
							var speedX2 = Model.gi().ballsData[j].speedX;
							var speedY2 = Model.gi().ballsData[j].speedY;
							
							// set the position variables
							var xl1 = this["ball" + i]._x;
							var yl1 = this["ball" + i]._y;
							var xl2 = this["ball" + j]._x;
							var yl2 = this["ball" + j]._y;
							// define the constantants
							var radius1:Number = new Number(Model.gi().ballsData[j].radius);
							var radius2:Number = new Number(Model.gi().ballsData[i].radius);
							var R = radius1 + radius2;
							var a = -2 * speedX1 * speedX2 + speedX1 * speedX1 + speedX2 * speedX2;
							var b = -2 * xl1 * speedX2 - 2 * xl2 * speedX1 + 2 * xl1 * speedX1 + 2 * xl2 * speedX2;
							var c = -2 * xl1 * xl2 + xl1 * xl1 + xl2 * xl2;
							var d = -2 * speedY1 * speedY2 + speedY1 * speedY1 + speedY2 * speedY2;
							var e = -2 * yl1 * speedY2 - 2 * yl2 * speedY1 + 2 * yl1 * speedY1 + 2 * yl2 * speedY2;
							var f = -2 * yl1 * yl2 + yl1 * yl1 + yl2 * yl2;
							var g = a + d;
							var h = b + e;
							var k = c + f - R * R;
							
							// solve the quadratic equation
							var sqRoot = Math.sqrt(h * h - 4 * g * k);
							var t1 = ( -h + sqRoot) / (2 * g);
							var t2 = ( -h - sqRoot) / (2 * g);
							
							if (t1 > 0 && t1 <= 1)
							{
									var whatTime = t1;
									var ballsCollided = true;
							}
							if (t2 > 0 && t2 <= 1)
							{
									if (whatTime == null || t2 < t1)
									{
											var whatTime = t2;
											var ballsCollided = true;
									}
							}
							
							if (ballsCollided)
							{
									// Collision has happened
									trace(++_root.kk + " Collision " + i + " with " + j);
									_root.ball2BallReaction(Model.gi().ballsData[i], Model.gi().ballsData[j], 1);
					
							}
						}
					}
				};
				
				_root["ball2BallReaction"] = function(ballData1:BallData, ballData2:BallData, time:Number):Void
				{
						// get the masses
						var mass1 = ballData1.mass;
						var mass2 = ballData2.mass;
						// set initial velocity vars
						var xVel1 = ballData1.speedX;
						var xVel2 = ballData2.speedX;
						var yVel1 = ballData1.speedY;
						var yVel2 = ballData2.speedY;
						
						var run = ballData1.x - ballData2.x;
						var rise = ballData1.y - ballData2.y;
						var Theta = Math.atan2(rise, run);
						var cosTheta = Math.cos(Theta);
						var sinTheta = Math.sin(Theta);
						// find the velocities along the line of action
						var xVel1prime = xVel1 * cosTheta + yVel1 * sinTheta;
						var xVel2prime = xVel2 * cosTheta + yVel2 * sinTheta;
						// find the velocities perpendicular to the line of action
						var yVel1prime = yVel1 * cosTheta - xVel1 * sinTheta;
						var yVel2prime = yVel2 * cosTheta - xVel2 * sinTheta;
						// conservation equations
						var P = (mass1 * xVel1prime + mass2 * xVel2prime);
						var V = (xVel1prime - xVel2prime);
						var v2f = (P + mass1 * V) / (mass1 + mass2);
						var v1f = v2f - xVel1prime + xVel2prime;
						var xVel1prime = v1f;
						var xVel2prime = v2f;
						// project back to Flash's x and y axes
						var xVel1 = xVel1prime * cosTheta - yVel1prime * sinTheta;
						var xVel2 = xVel2prime * cosTheta - yVel2prime * sinTheta;
						var yVel1 = yVel1prime * cosTheta + xVel1prime * sinTheta;
						var yVel2 = yVel2prime * cosTheta + xVel2prime * sinTheta;
						// changle old pos
						ballData1.tempX = ballData1.x + ballData1.speedX * time;
						ballData1.tempY = ballData1.y + ballData1.speedY * time;
						ballData2.tempX = ballData2.x + ballData2.speedX * time;
						ballData2.tempY = ballData2.y + ballData2.speedY * time;
				
						ballData1.speedX = xVel1;
						ballData2.speedX = xVel2;
						ballData1.speedY = yVel1;
						ballData2.speedY = yVel2;
				};	
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
					 ballData.mass = new Number(ballData.radius/10);
					 ballData.angle = new Number(ballAttributes["angle"]);
					 var speed:Number = new Number(ballAttributes["speed"]);
					 
					 ballData.speedX = speed * Math.cos(ballData.angle * Math.PI / 180);
					 ballData.speedY = speed * Math.sin(ballData.angle * Math.PI / 180);
				
					 ballsData.push(ballData);
				}
				
				this.start();
				
			}else {
				
				throw new Error("ERROR: Fail load xml data.");
			}	
	}
}