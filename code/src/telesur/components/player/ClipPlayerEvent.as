package telesur.components.player
{
	import flash.events.Event;
	
	public class ClipPlayerEvent extends Event
	{
		public static const CLOSE:String = "CLIPPLAYEREVENT_CLOSE";
		
		public function ClipPlayerEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}