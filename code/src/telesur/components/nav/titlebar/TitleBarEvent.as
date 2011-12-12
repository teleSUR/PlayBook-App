package telesur.components.nav.titlebar
{
	import flash.events.Event;
	
	public class TitleBarEvent extends Event
	{
		public static const PLAY_LIVE:String = "TITLEBAR_PLAY_LIVE";
		public static const REFRESH:String = "TITLEBAR_REFRESH";
		
		public function TitleBarEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}