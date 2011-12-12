package telesur.components.nav.map
{
	import flash.events.Event;

	public class CorresponsalesMapEvent extends Event
	{
		public static const CLIP_SELECTED:String = "ClipSelected";
		
		private var _clipData:Object;
		
		public function get clipData():Object {
			return this._clipData;
		}
		
		public function CorresponsalesMapEvent(type:String, clipData:Object, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this._clipData = clipData;
		}
	}
}