package telesur.components.nav.infopanel
{
	import flash.events.Event;
	
	public class RelatedClipsPanelEvent extends Event
	{
		public static const CLIP_SELECTED:String = "ClipSelected";
		
		private var _clipData:Object;
		public function get clipData():Object {
			return this._clipData;
		}
		
		public function RelatedClipsPanelEvent(type:String, clipData:Object, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this._clipData = clipData;
		}
	}
}