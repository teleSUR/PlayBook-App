package telesur.components.nav.infopanel
{
	import flash.events.Event;
	
	public class ClipInfoPanelEvent extends Event
	{
		public static const PLAY_CLIP:String = "PlayClip";
		public static const CLOSE:String = "Close";
		
		private var _clipData:Object;
		public function get clipData():Object {
			return this._clipData;
		}
		
		public function ClipInfoPanelEvent(type:String, clipData:Object, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this._clipData = clipData;
		}
	}
}