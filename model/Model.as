
class model.Model 
{
		private var _fileName:String = "model/data.xml";
		
		private var _xmlData:XML;
		
		private var _ballsData:Array;
	
		private static var _instance:Model = null;
		
		private function Model() { }
		
		public static function gi():Model
		{
				if (Model._instance == null)
				{
						Model._instance = new Model();
				}
				
				return Model._instance;
		}
		
		public function fetchXML(callback_XML_OnLoad_Function:Function, startFunction:Function):Void
		{
				_xmlData = new XML();
				_xmlData["start"] = startFunction;
				_xmlData.ignoreWhite = true;
				_xmlData.ignoreWhite = true;
				_xmlData.onLoad = callback_XML_OnLoad_Function;
				_xmlData.load(_fileName);
		}
		
		public function set ballsData(ballsdata:Array):Void
		{
				_ballsData = ballsdata;
		}
		
		public function get ballsData():Array
		{
				if (!_ballsData)
				{
						_ballsData = new Array;
				}
					
				return _ballsData;
		}
		
		public function get xmlData():XML
		{
				return _xmlData;
		}

}