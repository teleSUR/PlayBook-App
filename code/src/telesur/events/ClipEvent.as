package telesur.events
{
	import flash.events.Event;
	
	public class ClipEvent extends Event
	{
		public static const PLAY:String = "PLAY";
		public static const INFO:String = "INFO";
		
		private var _data:Object;
		
		public function get data():Object {
			return this._data;
		}
		
		public function ClipEvent(type:String, clipData:Object, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this._data = clipData;
		}
	}
}