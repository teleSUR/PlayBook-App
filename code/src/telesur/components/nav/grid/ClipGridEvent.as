package telesur.components.nav.grid
{
	import flash.events.Event;
	
	public class ClipGridEvent extends Event
	{
		public static const CARGARMAS:String = "CLIPGRIDEVENT_CARGARMAS";
		public static const CLIPSELECTED:String = "CLIPGRIDEVENT_CLIPSELECTED";
		
		private var _clipData:Object;
		public function get clipData():Object {
			return this._clipData;
		}
		
		public function ClipGridEvent(type:String, clipData:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this._clipData = clipData;
		}
	}
}