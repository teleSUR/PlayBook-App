package telesur.components.nav
{
	import flash.events.Event;
	
	public class NavigationEvent extends Event
	{
		public static const CLIPSELECTED:String = "Telesur_NavigationEvent_ClipSelected";
		public static const LIVESELECTED:String = "Telesur_Navigation_LiveSelected";
				
		private var _data:Object;
		public function get data():Object {
			return this._data;
		}
		
		public function NavigationEvent(type:String, data:Object, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this._data = data;
		}
	}
}